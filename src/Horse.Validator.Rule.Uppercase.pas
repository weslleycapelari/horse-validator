unit Horse.Validator.Rule.Uppercase;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se todos os caracteres alfabéticos no campo estão em maiúsculas.
  /// </summary>
  /// <remarks>
  ///   Caracteres não alfabéticos (números, símbolos, espaços) são ignorados na validação.
  /// </remarks>
  TRuleUppercase = class(TRule)
  public
    /// <summary>Executa a validação da regra "Uppercase".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleUppercase }

function TRuleUppercase.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  // Não usamos Trim() aqui, pois a comparação deve ser feita na string original.
  if not ARequired and AValue.IsEmpty then
    Exit(True);

  // A validação passa se a string original for idêntica à sua versão em maiúsculas.
  // Isso funciona corretamente com números e símbolos, pois ToUpper() não os afeta.
  Result := (AValue = AValue.ToUpper);

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas caracteres em maiúsculas.', [AFieldName]));
end;

end.
