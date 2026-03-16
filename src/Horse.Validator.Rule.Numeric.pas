unit Horse.Validator.Rule.Numeric;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um valor numérico válido (inteiro ou com casas decimais).
  /// </summary>
  /// <remarks>
  ///   Aceita separadores decimais como ponto (.) ou vírgula (,), dependendo da implementação base.
  /// </remarks>
  TRuleNumeric = class(TRule)
  public
    /// <summary>Executa a validação da regra "Numeric".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleNumeric }

function TRuleNumeric.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Usa o método auxiliar da classe base, que valida via RegEx.
  Result := IsNumber(LValue);

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um número.', [AFieldName]));
end;

end.
