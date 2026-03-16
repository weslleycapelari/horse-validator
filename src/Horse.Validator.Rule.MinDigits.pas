unit Horse.Validator.Rule.MinDigits;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é numérico e tem pelo menos o número mínimo de dígitos especificado.
  /// </summary>
  TRuleMinDigits = class(TRule)
  strict private
    FMinLength: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MinDigits'.
    /// </summary>
    /// <param name="AMinLength">O número mínimo de dígitos requerido.</param>
    constructor Create(const AMinLength: Integer);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleMinDigits }

constructor TRuleMinDigits.Create(const AMinLength: Integer);
begin
  inherited Create;
  if AMinLength < 1 then
    raise Exception.Create('O comprimento mínimo para a regra "MinDigits" deve ser de no mínimo 1.');
  FMinLength := AMinLength;
end;

function TRuleMinDigits.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Passo 1: Verifica se o campo contém apenas dígitos.
  if not IsInteger(LValue) then
  begin
    SetResultMessage(Format('O campo %s deve conter apenas dígitos.', [AFieldName]));
    Exit(False);
  end;

  // Passo 2: Verifica o comprimento.
  Result := LValue.Length >= FMinLength;

  if not Result then
    SetResultMessage(Format('O campo %s deve ter no mínimo %d dígitos.', [AFieldName, FMinLength]));
end;

end.
