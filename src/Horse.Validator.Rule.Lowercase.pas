unit Horse.Validator.Rule.Lowercase;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se todos os caracteres alfabéticos no campo estão em minúsculas.
  /// </summary>
  /// <remarks>
  ///   Caracteres não alfabéticos (números, símbolos, espaços) são ignorados na validação.
  /// </remarks>
  TRuleLowercase = class(TRule)
  public
    /// <summary>Executa a validação da regra "Lowercase".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleLowercase }

function TRuleLowercase.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  // Não usamos Trim() aqui, pois a comparação deve ser feita na string original.
  if not ARequired and AValue.IsEmpty then
    Exit(True);

  // A validação passa se a string original for idêntica à sua versão em minúsculas.
  // Isso funciona corretamente com números e símbolos, pois ToLower() não os afeta.
  Result := (AValue = AValue.ToLower);

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas caracteres em minúsculas.', [AFieldName]));
end;

end.
