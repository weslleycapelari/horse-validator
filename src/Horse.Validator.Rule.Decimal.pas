unit Horse.Validator.Rule.Decimal;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um número com um número exato de casas decimais.
  /// </summary>
  TRuleDecimal = class(TRule)
  strict private
    FDecimalPlaces: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Decimal'.
    /// </summary>
    /// <param name="ADecimalPlaces">O número exato de casas decimais requerido.</param>
    constructor Create(const ADecimalPlaces: Integer);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleDecimal }

constructor TRuleDecimal.Create(const ADecimalPlaces: Integer);
begin
  inherited Create;
  if ADecimalPlaces < 0 then
    raise Exception.Create('O número de casas decimais não pode ser negativo.');
  FDecimalPlaces := ADecimalPlaces;
end;

function TRuleDecimal.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LPattern: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Primeiro, uma verificação geral para garantir que é um número (usa o helper da classe base).
  if not IsNumber(LValue) then
  begin
    SetResultMessage(Format('O campo %s deve ser um número decimal.', [AFieldName]));
    Exit(False);
  end;

  // Constrói a RegEx dinamicamente para validar as casas decimais.
  // Aceita tanto ponto (.) quanto vírgula (,) como separador decimal.
  if FDecimalPlaces = 0 then
    // Deve ser um inteiro (sem casas decimais)
    LPattern := '^\d+$'
  else
    // Deve ter um separador decimal seguido pelo número exato de dígitos.
    LPattern := Format('^\d+([.,]\d{%d})$', [FDecimalPlaces]);

  Result := TRegEx.IsMatch(LValue, LPattern);

  if not Result then
    SetResultMessage(Format('O campo %s deve ter exatamente %d casas decimais.', [AFieldName, FDecimalPlaces]));
end;

end.
