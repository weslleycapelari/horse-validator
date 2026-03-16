unit Horse.Validator.Rule.IsArray;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é um array JSON válido (iniciando com '[' e terminando com ']').
  /// </summary>
  TRuleIsArray = class(TRule)
  public
    /// <summary>Executa a validação da regra "IsArray".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON;

{ TRuleIsArray }

function TRuleIsArray.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Checagem rápida de formato para otimizar o desempenho.
  if not (LValue.StartsWith('[') and LValue.EndsWith(']')) then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s deve ser um array JSON válido.', [AFieldName]));
    Exit;
  end;

  // Checagem completa: Tenta analisar a string e verifica se o resultado é um TJSONArray.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);
    if Assigned(LJSONValue) then
    try
      Result := (LJSONValue is TJSONArray);
    finally
      LJSONValue.Free;
    end
    else
      Result := False;
  except
    // Qualquer exceção durante o parsing indica que não é um array JSON válido.
    Result := False;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um array JSON válido.', [AFieldName]));
end;

end.
