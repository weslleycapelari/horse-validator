unit Horse.Validator.Rule.Prohibited;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo não está presente na requisição.
  /// </summary>
  /// <remarks>
  ///   A validação falha se o campo for enviado, mesmo que com um valor vazio ou nulo.
  /// </remarks>
  TRuleProhibited = class(TRule)
  public
    /// <summary>Executa a validação da regra "Prohibited".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleProhibited }

function TRuleProhibited.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // A validação para 'Prohibited' passa somente se o campo não existir no payload.
  // O nosso Core Validator (THorseValidator) passa uma string vazia para campos
  // que não foram encontrados. Portanto, a validação é bem-sucedida se o valor for vazio.
  Result := AValue.IsEmpty;

  if not Result then
    SetResultMessage(Format('O campo %s não é permitido.', [AFieldName]));
end;

end.
