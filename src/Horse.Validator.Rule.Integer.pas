unit Horse.Validator.Rule.Integer;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um número inteiro (contém apenas dígitos).
  /// </summary>
  TRuleInteger = class(TRule)
  public
    /// <summary>Executa a validação da regra "Integer".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleInteger }

function TRuleInteger.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Usa o método auxiliar da classe base, que já implementa a verificação com RegEx (^[\d]+$).
  Result := IsInteger(LValue);

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um número inteiro.', [AFieldName]));
end;

end.
