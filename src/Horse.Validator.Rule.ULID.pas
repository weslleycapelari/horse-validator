unit Horse.Validator.Rule.ULID;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um ULID (Universally Unique Lexicographically Sortable Identifier) válido.
  /// </summary>
  /// <remarks>
  ///   A validação verifica o comprimento (26), o conjunto de caracteres (Crockford's Base32),
  ///   e a restrição de que o primeiro caractere não pode ser maior que '7'.
  /// </remarks>
  TRuleULID = class(TRule)
  public
    /// <summary>Executa a validação da regra "ULID".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleULID }

function TRuleULID.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Regex para validar o formato completo de um ULID (case-insensitive).
  // ^       - Início da string.
  // [0-7]   - O primeiro caractere, que não pode ser maior que 7.
  // [0-9A-HJKMNP-TV-Z]{25} - Os 25 caracteres restantes, usando o alfabeto Base32 de Crockford.
  // $       - Fim da string.
  C_ULID_REGEX = '^[0-7][0-9A-HJKMNP-TV-Z]{25}$';
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação é feita em uma única passada usando a RegEx sobre a string em maiúsculas.
  Result := TRegEx.IsMatch(LValue.ToUpper, C_ULID_REGEX);

  if not Result then
    SetResultMessage(Format('O campo %s não é um ULID válido.', [AFieldName]));
end;

end.
