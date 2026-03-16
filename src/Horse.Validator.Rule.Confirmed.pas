unit Horse.Validator.Rule.Confirmed;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo possui um campo de confirmação correspondente com o mesmo valor.
  /// </summary>
  /// <remarks>
  ///   Por exemplo, se o campo for 'password', esta regra verificará se existe um campo
  ///   chamado 'password_confirmation' na requisição e se seus valores são idênticos.
  /// </remarks>
  TRuleConfirmed = class(TRuleContextAware)
  public
    /// <summary>Executa a validação da regra "Confirmed".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleConfirmed }

function TRuleConfirmed.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LConfirmationFieldName: string;
  LConfirmationValue: string;
begin
  // Validação de segurança para garantir que o validador injetou o provider.
  if not Assigned(FValueProvider) then
    raise Exception.Create('A regra Confirmed requer que o ValueProvider seja injetado pelo THorseValidator.');

  // Constrói o nome do campo de confirmação por convenção.
  LConfirmationFieldName := AFieldName + '_confirmation';

  // Usa o ValueProvider para obter o valor do campo de confirmação.
  LConfirmationValue := FValueProvider(LConfirmationFieldName);

  // A validação passa se os dois valores forem idênticos. A comparação é case-sensitive.
  Result := (AValue = LConfirmationValue);

  if not Result then
    SetResultMessage(Format('A confirmação para o campo %s não corresponde.', [AFieldName]));
end;

end.
