unit Horse.Validator.Rule.MACAddress;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um endereço MAC válido.
  /// </summary>
  /// <remarks>
  ///   Formatos válidos consistem em 6 grupos de 2 dígitos hexadecimais,
  ///   separados por dois-pontos (:) ou hifens (-).
  ///   Ex: '00:0A:95:9D:68:16' ou '00-0A-95-9D-68-16'. A validação é case-insensitive.
  /// </remarks>
  TRuleMACAddress = class(TRule)
  public
    /// <summary>Executa a validação da regra "MACAddress".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleMACAddress }

function TRuleMACAddress.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Regex para validar um endereço MAC com separadores : ou -.
  // ^       - Início da string.
  // (...)   - Grupo.
  // {5}     - Repetido 5 vezes.
  // [0-9a-fA-F]{2} - Exatamente 2 caracteres hexadecimais.
  // [:-]    - O separador ( : ou - ).
  // $       - Fim da string.
  C_MAC_ADDRESS_REGEX = '^([0-9a-fA-F]{2}[:-]){5}([0-9a-fA-F]{2})$';
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  Result := TRegEx.IsMatch(LValue, C_MAC_ADDRESS_REGEX);

  if not Result then
    SetResultMessage(Format('O campo %s não é um endereço MAC válido.', [AFieldName]));
end;

end.
