unit Horse.Validator.Rule.Extensions;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida a extensão de um campo de arquivo enviado.
  /// </summary>
  /// <remarks>
  ///   Esta regra deve ser usada em conjunto com a regra 'File' e espera que o valor
  ///   do campo seja uma string JSON contendo as propriedades do arquivo, incluindo 'filename'.
  /// </remarks>
  TRuleExtensions = class(TRule)
  strict private
    FExtensions: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Extensions'.
    /// </summary>
    /// <param name="AExtensions">Um array de extensões permitidas, sem o ponto (ex: 'jpg', 'pdf').</param>
    constructor Create(const AExtensions: array of string);

    /// <summary>Executa a validação da regra "Extensions".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON,
  System.StrUtils,
  System.IOUtils;

{ TRuleExtensions }

constructor TRuleExtensions.Create(const AExtensions: array of string);
var
  LCount: Integer;
begin
  inherited Create;
  // Armazena as extensões permitidas para comparação posterior.
  SetLength(FExtensions, Length(AExtensions));
  for LCount := Low(AExtensions) to High(AExtensions) do
    FExtensions[LCount] := AExtensions[LCount];
end;

function TRuleExtensions.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
  LJSONObject: TJSONObject;
  LFileName: string;
  LFileExtension: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Passo 1: O valor deve ser um JSON válido representando o arquivo.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);
    if not (Assigned(LJSONValue) and (LJSONValue is TJSONObject)) then
    begin
      if Assigned(LJSONValue) then LJSONValue.Free;
      Result := False;
      SetResultMessage(Format('O campo %s não representa um arquivo válido.', [AFieldName]));
      Exit;
    end;
    LJSONObject := LJSONValue as TJSONObject;
  except
    Result := False;
    SetResultMessage(Format('O campo %s não representa um arquivo válido.', [AFieldName]));
    Exit;
  end;

  // Passo 2: Extrai o nome do arquivo, obtém sua extensão e valida.
  try
    LFileName := '';
    if LJSONObject.TryGetValue<string>('filename', LFileName) then
    begin
      // TPath.GetExtension retorna a extensão com um ponto (ex: '.jpg').
      LFileExtension := TPath.GetExtension(LFileName);

      // Remove o ponto inicial para a comparação.
      if not LFileExtension.IsEmpty then
        LFileExtension := LFileExtension.Substring(1);

      // Compara a extensão do arquivo com a lista de extensões permitidas (case-insensitive).
      Result := MatchStr(LFileExtension, FExtensions);

      if not Result then
        SetResultMessage(Format('A extensão do arquivo do campo %s não é permitida.', [AFieldName]));
    end
    else
    begin
      // Se a chave 'filename' não existir no JSON, o formato é inválido.
      Result := False;
      SetResultMessage(Format('Não foi possível determinar o nome do arquivo do campo %s.', [AFieldName]));
    end;
  finally
    LJSONObject.Free;
  end;
end;

end.
