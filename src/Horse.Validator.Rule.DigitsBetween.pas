unit Horse.Validator.Rule.DigitsBetween;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas dígitos numéricos e se a quantidade de dígitos
  ///   está entre um mínimo e um máximo especificados.
  /// </summary>
  TRuleDigitsBetween = class(TRule)
  strict private
    FMinLength: Integer;
    FMaxLength: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'DigitsBetween'.
    /// </summary>
    /// <param name="AMinLength">A quantidade mínima de dígitos permitida.</param>
    /// <param name="AMaxLength">A quantidade máxima de dígitos permitida.</param>
    constructor Create(const AMinLength, AMaxLength: Integer);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleDigitsBetween }

constructor TRuleDigitsBetween.Create(const AMinLength, AMaxLength: Integer);
begin
  inherited Create;
  if (AMinLength < 0) or (AMaxLength < 0) then
    raise Exception.Create('Os comprimentos para a regra "DigitsBetween" não podem ser negativos.');

  if AMaxLength < AMinLength then
    raise Exception.Create('O comprimento máximo não pode ser menor que o mínimo.');

  FMinLength := AMinLength;
  FMaxLength := AMaxLength;
end;

function TRuleDigitsBetween.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LPattern: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A RegEx verifica se a string contém entre FMinLength e FMaxLength dígitos.
  // ^      : Início
  // \d     : Dígito
  // {m,n}  : Entre m e n ocorrências
  // $      : Fim
  LPattern := Format('^\d{%d,%d}$', [FMinLength, FMaxLength]);

  Result := TRegEx.IsMatch(LValue, LPattern);

  if not Result then
    SetResultMessage(Format('O campo %s deve ter entre %d e %d dígitos.', [AFieldName, FMinLength, FMaxLength]));
end;

end.
