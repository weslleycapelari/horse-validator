unit Horse.Validator.Rule.HexColor;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um código de cor hexadecimal válido.
  /// </summary>
  /// <remarks>
  ///   Formatos aceitos são de 3 ou 6 dígitos, precedidos por '#'.
  ///   Exemplos válidos: '#f00', '#ff0000'. A validação é case-insensitive.
  /// </remarks>
  TRuleHexColor = class(TRule)
  public
    /// <summary>Executa a validação da regra "HexColor".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleHexColor }

function TRuleHexColor.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Regex para validar um código de cor hexadecimal.
  // ^       - Início da string
  // #       - Caractere literal '#'
  // ( ... ) - Grupo de captura
  // [0-9a-fA-F]{3} - Exatamente 3 caracteres hexadecimais
  // |       - OU
  // [0-9a-fA-F]{6} - Exatamente 6 caracteres hexadecimais
  // $       - Fim da string
  C_HEX_COLOR_REGEX = '^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$';
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  Result := TRegEx.IsMatch(LValue, C_HEX_COLOR_REGEX);

  if not Result then
    SetResultMessage(Format('O campo %s não é um código de cor hexadecimal válido.', [AFieldName]));
end;

end.
