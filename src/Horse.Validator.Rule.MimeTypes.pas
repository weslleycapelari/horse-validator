unit Horse.Validator.Rule.MimeTypes;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida o MIME Type de um campo de arquivo enviado.
  /// </summary>
  /// <remarks>
  ///   Esta regra deve ser usada em conjunto com a regra 'File' e espera que o valor
  ///   do campo seja uma string JSON contendo as propriedades do arquivo.
  /// </remarks>
  TRuleMimeTypes = class(TRule)
  strict private
    FMimeTypes: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MimeTypes'.
    /// </summary>
    /// <param name="AMimeTypes">Um array de MIME Types permitidos (ex: 'image/jpeg', 'application/pdf').</param>
    constructor Create(const AMimeTypes: array of string);

    /// <summary>Executa a validação da regra "MimeTypes".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON,
  System.StrUtils;

{ TRuleMimeTypes }

constructor TRuleMimeTypes.Create(const AMimeTypes: array of string);
var
  LCount: Integer;
begin
  inherited Create;
  SetLength(FMimeTypes, Length(AMimeTypes));
  for LCount := Low(AMimeTypes) to High(AMimeTypes) do
    FMimeTypes[LCount] := AMimeTypes[LCount];
end;

function TRuleMimeTypes.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
  LJSONObject: TJSONObject;
  LFileMimeType: string;
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

  // Passo 2: Extrai o MimeType e valida.
  try
    LFileMimeType := '';
    if LJSONObject.TryGetValue<string>('mimetype', LFileMimeType) then
    begin
      // Compara o MimeType do arquivo com a lista de tipos permitidos (case-insensitive).
      Result := MatchStr(LFileMimeType, FMimeTypes);

      if not Result then
        SetResultMessage(Format('O tipo de arquivo do campo %s não é permitido.', [AFieldName]));
    end
    else
    begin
      // Se a chave 'mimetype' não existir no JSON, o formato é inválido.
      Result := False;
      SetResultMessage(Format('Não foi possível determinar o tipo de arquivo do campo %s.', [AFieldName]));
    end;
  finally
    LJSONObject.Free;
  end;
end;

end.
