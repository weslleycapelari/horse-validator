unit Horse.Validator.Core;

interface

uses
  System.JSON,
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  Horse,
  Horse.Validator.Interfaces,
  Horse.Validator.Collection,
  Horse.Validator.Exception;

type
  /// <summary>
  ///   Classe central de validação. Responsável por orquestrar a leitura da requisição,
  ///   manter o estado das regras e executar a validação navegando no JSON unificado.
  /// </summary>
  THorseValidator = class(TInterfacedObject, IValidator)
  strict private
    FRequest: THorseRequest;
    FRuleCollection: TRuleCollection;
    FMasterJSON: TJSONObject;
    FCurrentContext: string;
    FCurrentField: string;

    /// <summary>Consolida os dados da requisição (Body, Header, Query, Params) em um único JSON.</summary>
    procedure BuildMasterJSON;

    /// <summary>Converte um array de pares (Horse Dictionary) para um TJSONObject.</summary>
    function DictionaryToJSON(const APairs: TArray<TPair<string, string>>): TJSONObject;

    /// <summary>
    ///   Navega recursivamente no JSON para encontrar valores baseados em um caminho (path).
    ///   Suporta wildcards (*) para arrays.
    /// </summary>
    /// <param name="AJSON">O nodo JSON atual sendo analisado.</param>
    /// <param name="APath">O caminho restante a ser percorrido (ex: 'users.*.name').</param>
    /// <param name="ACurrentFullPath">O caminho absoluto construído até o momento (para logs de erro).</param>
    /// <param name="AFoundValues">Dicionário de saída: Key = Caminho Real, Value = Valor String.</param>
    procedure ResolveValues(const AJSON: TJSONValue; const APath, ACurrentFullPath: string;
      const AFoundValues: TDictionary<string, string>);

    /// <summary>Helper para obter um valor único de um caminho absoluto (sem wildcards).</summary>
    function GetSingleValue(const APath: string): string;
  public
    constructor Create(ARequest: THorseRequest);
    destructor Destroy; override;

    /// <summary>Factory estático para criação rápida.</summary>
    class function New(ARequest: THorseRequest): IValidator;

    // --- Implementação de IValidator ---

    /// <summary>Define o campo atual para adição de regras. Suporta notação de ponto e wildcards.</summary>
    function Field(const AFieldName: string): IValidator;

    /// <summary>Adiciona uma regra ao campo atual.</summary>
    function AddRule(const ARule: IRule): IValidator; overload;

    /// <summary>Adiciona múltiplas regras ao campo atual.</summary>
    function AddRule(const ARules: array of IRule): IValidator; overload;

    /// <summary>Executa um callback de validação apenas se a condição for verdadeira.</summary>
    function IfVal(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator; overload;
    function IfVal(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator; overload;

    /// <summary>
    ///   Define um escopo aninhado. O campo atual definido por 'Field' torna-se o prefixo
    ///   para todas as chamadas 'Field' dentro do callback.
    /// </summary>
    function Scope(const ACallback: TValidationScopeCallback): IValidator;

    function GroupWhen(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator; overload;
    function GroupWhen(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator; overload;

    // --- Execução ---

    /// <summary>
    ///   Executa todo o processo de validação.
    ///   Levanta EHorseValidationException em caso de falha.
    /// </summary>
    procedure Validate;
  end;

implementation

uses
  Horse.Validator.Rule.Base;

{ THorseValidator }

constructor THorseValidator.Create(ARequest: THorseRequest);
begin
  inherited Create;
  FRequest := ARequest;
  FRuleCollection := TRuleCollection.Create;
  FMasterJSON := nil;
  FCurrentContext := '';
  FCurrentField := '';

  BuildMasterJSON;
end;

destructor THorseValidator.Destroy;
begin
  if Assigned(FMasterJSON) then
    FMasterJSON.Free;
  FRuleCollection.Free;
  inherited;
end;

class function THorseValidator.New(ARequest: THorseRequest): IValidator;
begin
  Result := THorseValidator.Create(ARequest);
end;

procedure THorseValidator.BuildMasterJSON;
var
  LJSONBody: TJSONValue;
begin
  FMasterJSON := TJSONObject.Create;

  // 1. Processa o Body
  // Tenta parsear o body como JSON. Se falhar ou for vazio, trata adequadamente.
  if (FRequest.Body.Trim.StartsWith('{')) or (FRequest.Body.Trim.StartsWith('[')) then
  begin
    LJSONBody := TJSONObject.ParseJSONValue(FRequest.Body);
    if Assigned(LJSONBody) then
      FMasterJSON.AddPair('body', LJSONBody)
    else
      FMasterJSON.AddPair('body', TJSONNull.Create);
  end
  else
  begin
    // Se não for JSON estruturado, guarda como string simples sob a chave 'body'
    // ou cria um objeto vazio se estiver vazio.
    if FRequest.Body.IsEmpty then
      FMasterJSON.AddPair('body', TJSONNull.Create)
    else
      FMasterJSON.AddPair('body', FRequest.Body);
  end;

  // 2. Adiciona as outras fontes de dados convertidas para JSON Object
  FMasterJSON.AddPair('query', DictionaryToJSON(FRequest.Query.ToArray));
  FMasterJSON.AddPair('params', DictionaryToJSON(FRequest.Params.ToArray));
  FMasterJSON.AddPair('headers', DictionaryToJSON(FRequest.Headers.ToArray));

  // Exemplo da estrutura final:
  // {
  //   "body": { "users": [...] },
  //   "query": { "page": "1" },
  //   "params": { "id": "10" },
  //   "headers": { "Authorization": "..." }
  // }
end;

function THorseValidator.DictionaryToJSON(const APairs: TArray<TPair<string, string>>): TJSONObject;
var
  LPair: TPair<string, string>;
begin
  Result := TJSONObject.Create;
  for LPair in APairs do
  begin
    Result.AddPair(LPair.Key, LPair.Value);
  end;
end;

function THorseValidator.Field(const AFieldName: string): IValidator;
var
  LFinalFieldName: string;
begin
  Result := Self;

  // Se estivermos dentro de um contexto (Scope), simplesmente concatenamos o caminho.
  if not FCurrentContext.IsEmpty then
  begin
    FCurrentField := FCurrentContext + '.' + AFieldName;
    Exit;
  end;

  // Se estamos no nível raiz (sem contexto), aplicamos a lógica de busca global.
  // Se o nome do campo já contém um ponto, o usuário está especificando o caminho completo.
  if Pos('.', AFieldName) > 0 then
  begin
    LFinalFieldName := AFieldName;
  end
  else
  begin
    // Se não contém ponto, é um campo de raiz. Adicionamos um wildcard de escopo.
    LFinalFieldName := '*.' + AFieldName;
  end;

  FCurrentField := LFinalFieldName;
end;

function THorseValidator.AddRule(const ARule: IRule): IValidator;
begin
  Result := AddRule([ARule]);
end;

function THorseValidator.AddRule(const ARules: array of IRule): IValidator;
var
  LRule: IRule;
  LProvider: TValueProvider;
begin
  Result := Self;

  if FCurrentField.IsEmpty then
    raise Exception.Create('A chamada AddRule deve ser precedida por Field().');

  // Define o Provider que permite que as regras busquem valores (ex: Same, GreaterThan).
  // O Provider usa caminhos absolutos no MasterJSON.
  LProvider := function(const AKey: string): string
    begin
      Result := GetSingleValue(AKey);
    end;

  for LRule in ARules do
  begin
    // Se a regra precisa de contexto (acesso a outros campos), injeta o provider.
    if Supports(LRule, IRuleContextAware) then
      (LRule as TRuleContextAware).SetValueProvider(LProvider);

    // Adiciona a regra à coleção usando o caminho completo (que pode conter wildcards).
    FRuleCollection.AddRule(FCurrentField, LRule);
  end;
end;

function THorseValidator.IfVal(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator;
begin
  Result := IfVal(ACondition(), ACallback);
end;

function THorseValidator.Scope(const ACallback: TValidationScopeCallback): IValidator;
var
  LPreviousContext: string;
begin
  Result := Self;
  LPreviousContext := FCurrentContext;

  try
    // A chave para a correção está aqui. Adicionamos '.*' ao final do campo atual
    // para transformar o contexto em um iterador de array.
    FCurrentContext := FCurrentField + '.*';

    ACallback(Self);
  finally
    FCurrentContext := LPreviousContext;
  end;
end;

function THorseValidator.GetSingleValue(const APath: string): string;
var
  LFoundValues: TDictionary<string, string>;
  LKey: string;
begin
  Result := '';
  LFoundValues := TDictionary<string, string>.Create;
  try
    // Reutiliza a lógica de resolução, mas esperamos apenas um resultado.
    ResolveValues(FMasterJSON, APath, '', LFoundValues);

    // Retorna o primeiro valor encontrado (se houver).
    for LKey in LFoundValues.Keys do
    begin
      Result := LFoundValues[LKey];
      Break;
    end;
  finally
    LFoundValues.Free;
  end;
end;

function THorseValidator.GroupWhen(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator;
begin
  Result := IfVal(ACondition, ACallback);
end;

function THorseValidator.GroupWhen(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator;
begin
  Result := IfVal(ACondition(), ACallback);
end;

function THorseValidator.IfVal(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator;
begin
  Result := Self;

  // Simplesmente executa o callback se a condição for verdadeira.
  // O callback adicionará as regras normalmente.
  if ACondition then
    ACallback(Self);
end;

procedure THorseValidator.ResolveValues(const AJSON: TJSONValue; const APath, ACurrentFullPath: string;
  const AFoundValues: TDictionary<string, string>);
var
  LNextSegment, LRemainingPath: string;
  LDotPos: Integer;
  LIsLastSegment: Boolean;
  LJSONObj: TJSONObject;
  LJSONArray: TJSONArray;
  LItem: TJSONValue;
  LPair: TJSONPair;
  LArrayPos, LArrayCount: Integer;
  LCurrentPathSegment: string;
begin
  if not Assigned(AJSON) then
    Exit;

  // 1. Separa o próximo segmento do caminho (ex: 'users' de 'users.0.name')
  LDotPos := Pos('.', APath);
  if LDotPos > 0 then
  begin
    LNextSegment := Copy(APath, 1, LDotPos - 1);
    LRemainingPath := Copy(APath, LDotPos + 1, Length(APath));
    LIsLastSegment := False;
  end
  else
  begin
    LNextSegment := APath;
    LRemainingPath := '';
    LIsLastSegment := True;
  end;

  // 2. Lógica para Wildcard (*) e inteiros -> Array
  LArrayPos := -1;
  if (LNextSegment = '*') or (TryStrToInt(LNextSegment, LArrayPos)) then
  begin
    // Wildcard de escopo no nível raiz (ex: '*.nome')
    if (AJSON = FMasterJSON) and (ACurrentFullPath = '') then
    begin
      LJSONObj := AJSON as TJSONObject;
      for LPair in LJSONObj do
      begin
        // Procura o restante do caminho em cada escopo (body, query, params, headers)
        ResolveValues(LPair.JsonValue, LRemainingPath, LPair.JsonString.Value, AFoundValues);
      end;
      Exit; // Termina aqui para este nível
    end;

    if AJSON is TJSONArray then
    begin
      LJSONArray := AJSON as TJSONArray;
      if LArrayPos < 0 then
      begin
        LArrayPos := 0;
        LArrayCount := LJSONArray.Count - 1;
      end
      else
        LArrayCount := LArrayPos;

      for LArrayPos := 0 to LArrayCount do
      begin
        LItem := LJSONArray.Items[LArrayPos];

        // Constrói o caminho real: "users.*" vira "users.0"
        if ACurrentFullPath.IsEmpty then
          LCurrentPathSegment := IntToStr(LArrayPos)
        else
          LCurrentPathSegment := ACurrentFullPath + '.' + IntToStr(LArrayPos);

        if LIsLastSegment then
        begin
          // Se for o fim do caminho e é um array, pega o valor do item.
          // Nota: Validar o valor de um objeto complexo como string retorna seu JSON.
          AFoundValues.AddOrSetValue(LCurrentPathSegment, LItem.Value);
        end
        else
        begin
          // Continua descendo na árvore.
          ResolveValues(LItem, LRemainingPath, LCurrentPathSegment, AFoundValues);
        end;
      end;
    end;
    Exit;
  end;

  // 3. Lógica para Propriedade de Objeto
  if AJSON is TJSONObject then
  begin
    LJSONObj := AJSON as TJSONObject;
    LPair := LJSONObj.Get(LNextSegment);

    if Assigned(LPair) then
    begin
      // Constrói o caminho real
      if ACurrentFullPath.IsEmpty then
        LCurrentPathSegment := LNextSegment
      else
        LCurrentPathSegment := ACurrentFullPath + '.' + LNextSegment;

      if LIsLastSegment then
      begin
        // Chegou no destino, adiciona o valor.
        // Se for null, adiciona string vazia.
        if LPair.JsonValue is TJSONNull then
          AFoundValues.AddOrSetValue(LCurrentPathSegment, '')
        else
          AFoundValues.AddOrSetValue(LCurrentPathSegment, LPair.JsonValue.Value);
      end
      else
      begin
        // Continua descendo.
        ResolveValues(LPair.JsonValue, LRemainingPath, LCurrentPathSegment, AFoundValues);
      end;
    end;
  end
  // Caso especial: Tentativa de acessar propriedade em algo que não é objeto (ignora silenciosamente)
end;

procedure THorseValidator.Validate;
var
  LRuleKey: string;
  LValuesToValidate: TDictionary<string, string>;
  LActualField: string;
  LValidationErrors: TDictionary<string, TList<string>>;
  LCurrentErrors: TList<string>;
  LHasError: Boolean;
begin
  LValidationErrors := TDictionary<string, TList<string>>.Create;
  LValuesToValidate := TDictionary<string, string>.Create;
  LHasError := False;

  try
    // Itera sobre todas as definições de regras (Rule Keys podem ter wildcards)
    for LRuleKey in FRuleCollection.Keys do
    begin
      LValuesToValidate.Clear;

      // Resolve os valores reais baseados na chave (expande wildcards).
      // Ex: LRuleKey='users.*.name' -> Retorna {'users.0.name': 'Diego', 'users.1.name': 'Jose'}
      ResolveValues(FMasterJSON, LRuleKey, '', LValuesToValidate);

      // Se a chave não retornou nenhum valor (campo não existe ou array vazio)...
      if LValuesToValidate.Count = 0 then
      begin
        // ...só adicionamos uma entrada vazia para validação (para a regra 'Required' falhar)
        // SE a chave NÃO contiver um wildcard. Se contiver, significa que
        // o array estava vazio ou não existia, e as regras aninhadas devem ser ignoradas.
        if Pos('*', LRuleKey) = 0 then
        begin
          LValuesToValidate.Add(LRuleKey, ''); // Valor vazio para campos únicos não encontrados
        end;
      end;

      // Executa as regras para cada valor encontrado
      for LActualField in LValuesToValidate.Keys do
      begin
        LCurrentErrors := TList<string>.Create;
        try
          if not FRuleCollection.ExecuteRules(LRuleKey, LActualField, LValuesToValidate[LActualField], LCurrentErrors) then
          begin
            LHasError := True;
            if not LValidationErrors.ContainsKey(LActualField) then
            begin
               // Transfere a ownership da lista para o dicionário
               LValidationErrors.Add(LActualField, LCurrentErrors);
               LCurrentErrors := nil; // Zera para não liberar no finally
            end
            else
            begin
               // Se já existe lista para este campo, copia e libera
               LValidationErrors[LActualField].AddRange(LCurrentErrors);
            end;
          end;
        finally
          if Assigned(LCurrentErrors) then
            LCurrentErrors.Free;
        end;
      end;
    end;

    if LHasError then
    begin
      // Levanta a exceção passando a ownership do dicionário de erros.
      raise EHorseValidationException.New
        .Error('A validação dos dados falhou.')
        .Validations(LValidationErrors);
    end;

  finally
    // Se LHasError for True, LValidationErrors pertence à exceção.
    // Se for False, precisamos liberar aqui.
    if not LHasError then
    begin
      // Libera as listas internas
      for LCurrentErrors in LValidationErrors.Values do
        LCurrentErrors.Free;
      LValidationErrors.Free;
    end;
    LValuesToValidate.Free;
  end;
end;

end.
