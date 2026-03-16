unit Horse.Validator.Rule.AlphaNumeric;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas caracteres alfanuméricos (a-z, A-Z, 0-9).
  /// </summary>
  TRuleAlphaNumeric = class(TRule)
  public
    /// <summary>Executa a validação da regra "AlphaNumeric".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleAlphaNumeric }

function TRuleAlphaNumeric.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A expressão regular ^[a-zA-Z0-9]+$ garante que a string contenha apenas letras e números.
  Result := TRegEx.IsMatch(LValue, '^[a-zA-Z0-9]+$');

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas letras e números.', [AFieldName]));
end;

end.
