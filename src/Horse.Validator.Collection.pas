unit Horse.Validator.Collection;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Horse.Validator.Interfaces;

type
  /// <summary>Gerencia o repositório de regras de validação mapeadas por chaves de campo.</summary>
  /// <remarks>
  ///   Armazena as listas de regras (IRule) associadas a chaves (que podem conter wildcards).
  ///   É responsável por executar a validação de um valor específico contra as regras armazenadas.
  /// </remarks>
  TRuleCollection = class
  private type
    TRules = TDictionary<string, TList<IRule>>;
  strict private
    FRules: TRules;
    function IsRequiredRule(const ARule: IRule): Boolean;
    function GetKeys: TRules.TKeyCollection;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>Adiciona uma única regra para um determinado campo.</summary>
    procedure AddRule(const AFieldName: string; const ARule: IRule); overload;

    /// <summary>Adiciona múltiplas regras para um determinado campo.</summary>
    procedure AddRule(const AFieldName: string; const ARules: array of IRule); overload;

    /// <summary>Executa as regras associadas a uma chave de definição contra um valor real.</summary>
    /// <param name="ARuleKey">A chave da regra (ex: 'users.*.name').</param>
    /// <param name="AActualFieldName">O nome real do campo sendo validado (ex: 'users.0.name'). Usado nas mensagens de erro.</param>
    /// <param name="AValue">O valor concreto extraído do JSON.</param>
    /// <param name="AErrorList">Lista onde as mensagens de erro serão adicionadas em caso de falha.</param>
    /// <returns>True se todas as regras passaram, False caso contrário.</returns>
    function ExecuteRules(const ARuleKey, AActualFieldName, AValue: string; const AErrorList: TList<string>): Boolean;

    /// <summary>Retorna a lista de chaves (campos) que possuem regras definidas.</summary>
    property Keys: TRules.TKeyCollection read GetKeys;
  end;

implementation

uses
  Horse.Validator.Rule.Required;

{ TRuleCollection }

constructor TRuleCollection.Create;
begin
  inherited;
  FRules := TRules.Create;
end;

destructor TRuleCollection.Destroy;
var
  LRuleList: TList<IRule>;
begin
  // Itera sobre os valores do dicionário para liberar as listas internas.
  for LRuleList in FRules.Values do
  begin
    LRuleList.Free;
  end;
  FRules.Free;
  inherited;
end;

procedure TRuleCollection.AddRule(const AFieldName: string; const ARule: IRule);
begin
  AddRule(AFieldName, [ARule]);
end;

procedure TRuleCollection.AddRule(const AFieldName: string; const ARules: array of IRule);
var
  LRuleList: TList<IRule>;
  LRule: IRule;
begin
  // Verifica se já existe uma lista de regras para este campo/chave.
  if not FRules.TryGetValue(AFieldName, LRuleList) then
  begin
    LRuleList := TList<IRule>.Create;
    FRules.Add(AFieldName, LRuleList);
  end;

  // Adiciona as novas regras à lista existente.
  for LRule in ARules do
  begin
    LRuleList.Add(LRule);
  end;
end;

function TRuleCollection.IsRequiredRule(const ARule: IRule): Boolean;
begin
  // Verifica se a regra é explicitamente uma regra de obrigatoriedade.
  // Isso é crucial para determinar se processamos ou ignoramos valores vazios.
  Result := ARule is TRuleRequired;
end;

function TRuleCollection.ExecuteRules(const ARuleKey, AActualFieldName, AValue: string; const AErrorList: TList<string>): Boolean;
var
  LRuleList: TList<IRule>;
  LRule: IRule;
  LFieldIsRequired: Boolean;
  LValidationPassed: Boolean;
begin
  Result := True;

  // Se não houver regras para esta chave, retorna sucesso imediatamente.
  if not FRules.TryGetValue(ARuleKey, LRuleList) or (LRuleList.Count = 0) then
    Exit;

  // 1. Verifica se o campo está marcado como obrigatório neste conjunto de regras.
  LFieldIsRequired := False;
  for LRule in LRuleList do
  begin
    if IsRequiredRule(LRule) then
    begin
      LFieldIsRequired := True;
      Break;
    end;
  end;

  // 2. Itera sobre todas as regras e executa a validação.
  for LRule in LRuleList do
  begin
    // Injeta o caminho completo do campo atual na regra antes de validar.
    // Isso permite que a regra resolva referências relativas (campos irmãos).
    if Supports(LRule, IRuleContextAware) then
      (LRule as IRuleContextAware).SetCurrentFieldPath(AActualFieldName);

    // A regra 'Validate' recebe o nome real do campo para formatar a mensagem de erro corretamente.
    // Ex: "O campo users.0.name é obrigatório".
    LValidationPassed := LRule.Validate(AActualFieldName, AValue, LFieldIsRequired);

    if not LValidationPassed then
    begin
      Result := False;
      // Adiciona a mensagem de erro à lista fornecida pelo chamador.
      if Assigned(AErrorList) then
        AErrorList.Add(LRule.Message);
    end;
  end;
end;

function TRuleCollection.GetKeys: TRules.TKeyCollection;
begin
  Result := FRules.Keys;
end;

end.
