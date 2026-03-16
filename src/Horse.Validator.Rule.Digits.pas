unit Horse.Validator.Rule.Digits;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas dígitos numéricos e possui um comprimento exato.
  /// </summary>
  TRuleDigits = class(TRule)
  strict private
    FLength: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Digits'.
    /// </summary>
    /// <param name="ALength">O número exato de dígitos que o campo deve ter.</param>
    constructor Create(const ALength: Integer);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleDigits }

constructor TRuleDigits.Create(const ALength: Integer);
begin
  inherited Create;
  if ALength < 0 then
    raise Exception.Create('O comprimento para a regra "Digits" não pode ser negativo.');
  FLength := ALength;
end;

function TRuleDigits.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LPattern: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A RegEx verifica se a string contém exatamente FLength dígitos do início ao fim.
  // ^      : Início
  // \d     : Dígito
  // {N}    : Quantidade exata
  // $      : Fim
  LPattern := Format('^\d{%d}$', [FLength]);

  Result := TRegEx.IsMatch(LValue, LPattern);

  if not Result then
    SetResultMessage(Format('O campo %s deve ter exatamente %d dígitos.', [AFieldName, FLength]));
end;

end.
