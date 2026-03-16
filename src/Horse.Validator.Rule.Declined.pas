unit Horse.Validator.Rule.Declined;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor de um campo é "falso" ou "negado".
  /// </summary>
  /// <remarks>
  ///   Um campo é considerado "rejeitado" se seu valor for 'no', 'off', '0', ou 'false'.
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleDeclined = class(TRule)
  public
    /// <summary>Executa a validação da regra "Declined".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.StrUtils;

{ TRuleDeclined }

function TRuleDeclined.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Define a lista de valores que são considerados "rejeitados".
  C_DECLINABLE_VALUES: array of string = ['no', 'off', '0', 'false'];
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // MatchStr realiza uma busca case-insensitive do valor no array de valores permitidos.
  Result := MatchStr(LValue, C_DECLINABLE_VALUES);

  if not Result then
    SetResultMessage(Format('O campo %s precisa ser rejeitado.', [AFieldName]));
end;

end.
