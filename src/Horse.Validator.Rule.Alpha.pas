unit Horse.Validator.Rule.Alpha;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas caracteres alfabéticos (a-z, A-Z).
  /// </summary>
  TRuleAlpha = class(TRule)
  public
    /// <summary>Executa a validação da regra "Alpha".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleAlpha }

function TRuleAlpha.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A expressão regular ^[a-zA-Z]+$ garante que a string contenha apenas letras.
  // ^       : Início
  // [a-zA-Z]: Intervalo de letras maiúsculas e minúsculas
  // +       : Uma ou mais ocorrências
  // $       : Fim
  Result := TRegEx.IsMatch(LValue, '^[a-zA-Z]+$');

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas letras.', [AFieldName]));
end;

end.
