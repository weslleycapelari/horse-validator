unit Horse.Validator.Rule.Boolean;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor de um campo representa um valor booleano.
  /// </summary>
  /// <remarks>
  ///   Um campo é considerado booleano se seu valor for 'true', 'false',
  ///   '1', ou '0'. A validação é case-insensitive.
  /// </remarks>
  TRuleBoolean = class(TRule)
  public
    /// <summary>Executa a validação da regra "Boolean".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.StrUtils;

{ TRuleBoolean }

function TRuleBoolean.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Define a lista de valores que são considerados booleanos.
  C_BOOLEAN_VALUES: array of string = ['true', 'false', '1', '0'];
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // MatchStr realiza uma busca case-insensitive do valor no array de valores permitidos.
  Result := MatchStr(LValue, C_BOOLEAN_VALUES);

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um valor booleano válido (true, false, 1, ou 0).', [AFieldName]));
end;

end.
