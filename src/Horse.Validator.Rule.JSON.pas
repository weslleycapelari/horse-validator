unit Horse.Validator.Rule.JSON;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é uma string JSON válida (Objeto ou Array).
  /// </summary>
  TRuleJSON = class(TRule)
  public
    /// <summary>Executa a validação da regra "JSON".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON;

{ TRuleJSON }

function TRuleJSON.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Um JSON válido deve começar com '{' (objeto) ou '[' (array).
  if not (LValue.StartsWith('{') or LValue.StartsWith('[')) then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s deve ser uma string JSON válida.', [AFieldName]));
    Exit;
  end;

  // A validação consiste em tentar analisar a string.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);

    // Se o parse foi bem-sucedido, o objeto deve ser liberado para evitar vazamento de memória.
    if Assigned(LJSONValue) then
      LJSONValue.Free;

    Result := True;
  except
    // Qualquer exceção durante o parse indica que a string não é um JSON válido.
    Result := False;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser uma string JSON válida.', [AFieldName]));
end;

end.
