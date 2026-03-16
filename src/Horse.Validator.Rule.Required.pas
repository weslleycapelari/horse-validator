unit Horse.Validator.Rule.Required;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo está presente e não está vazio.
  /// </summary>
  /// <remarks>
  ///   Um campo é considerado "vazio" se for uma string nula ou contiver apenas
  ///   caracteres de espaço em branco (whitespace). O valor '0' é considerado presente.
  /// </remarks>
  TRuleRequired = class(TRule)
  public
    /// <summary>Executa a validação da regra "Required".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleRequired }

function TRuleRequired.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // A validação para 'Required' é a mais fundamental: a string, após
  // a remoção de espaços em branco no início e no fim, não pode ser vazia.
  Result := not AValue.Trim.IsEmpty;

  if not Result then
    SetResultMessage(Format('O campo %s é obrigatório.', [AFieldName]));
end;

end.
