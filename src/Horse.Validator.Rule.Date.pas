unit Horse.Validator.Rule.Date;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base,
  Horse.Validator.DateUtils;

type
  /// <summary>Valida se o campo contém uma data ou data/hora válida.</summary>
  TRuleDate = class(TRule)
  public
    /// <summary>Executa a validação da regra "Date".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleDate }

function TRuleDate.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  Result := IsDateTime(LValue);

  if not Result then
    SetResultMessage(Format('O campo %s não é uma data válida.', [AFieldName]));
end;

end.
