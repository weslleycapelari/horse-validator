unit Horse.Validator.Rule.UUID;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um UUID (Universally Unique Identifier) válido.
  /// </summary>
  /// <remarks>
  ///   Valida o formato padrão 8-4-4-4-12, como '123e4567-e89b-12d3-a456-426614174000'.
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleUUID = class(TRule)
  public
    /// <summary>Executa a validação da regra "UUID".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleUUID }

function TRuleUUID.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Regex para validar o formato 8-4-4-4-12 de um UUID (case-insensitive).
  C_UUID_REGEX = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$';
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  Result := TRegEx.IsMatch(LValue, C_UUID_REGEX);

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um UUID válido.', [AFieldName]));
end;

end.
