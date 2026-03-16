unit Horse.Validator.Rule.AlphaDash;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas caracteres alfanuméricos, hifens (-) e underscores (_).
  /// </summary>
  TRuleAlphaDash = class(TRule)
  public
    /// <summary>Executa a validação da regra "AlphaDash".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleAlphaDash }

function TRuleAlphaDash.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A expressão regular ^[a-zA-Z0-9_-]+$ permite letras, números, hífen e underscore.
  Result := TRegEx.IsMatch(LValue, '^[a-zA-Z0-9_-]+$');

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas letras, números, hifens e underscores.', [AFieldName]));
end;

end.
