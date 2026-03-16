unit Horse.Validator.Rule.IsObject;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é um objeto JSON válido (iniciando com '{' e terminando com '}').
  /// </summary>
  TRuleIsObject = class(TRule)
  public
    /// <summary>Executa a validação da regra "IsObject".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON;

{ TRuleIsObject }

function TRuleIsObject.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Checagem rápida de formato para evitar o custo do parsing se for obviamente inválido.
  if not (LValue.StartsWith('{') and LValue.EndsWith('}')) then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s deve ser um objeto JSON válido.', [AFieldName]));
    Exit;
  end;

  // Checagem completa: Tenta analisar a string e verifica se o resultado é um TJSONObject.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);
    if Assigned(LJSONValue) then
    try
      Result := (LJSONValue is TJSONObject);
    finally
      LJSONValue.Free;
    end
    else
      Result := False;
  except
    // Qualquer exceção durante o parsing indica que não é um objeto JSON válido.
    Result := False;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um objeto JSON válido.', [AFieldName]));
end;

end.
