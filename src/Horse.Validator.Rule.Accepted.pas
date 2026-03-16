unit Horse.Validator.Rule.Accepted;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor de um campo é "verdadeiro".
  /// </summary>
  /// <remarks>
  ///   Um campo é considerado "aceito" se seu valor for 'yes', 'on', '1', ou 'true'.
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleAccepted = class(TRule)
  public
    /// <summary>Executa a validação da regra "Accepted".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.StrUtils;

{ TRuleAccepted }

function TRuleAccepted.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Define a lista de valores que são considerados "aceitos".
  C_ACCEPTABLE_VALUES: array of string = ['yes', 'on', '1', 'true'];
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // MatchStr realiza uma busca case-insensitive do valor no array de valores aceitáveis.
  Result := MatchStr(LValue, C_ACCEPTABLE_VALUES);

  if not Result then
    SetResultMessage(Format('O campo %s precisa ser aceito.', [AFieldName]));
end;

end.
