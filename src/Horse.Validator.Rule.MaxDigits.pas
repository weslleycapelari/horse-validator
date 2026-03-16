unit Horse.Validator.Rule.MaxDigits;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é numérico e não tem mais que o número máximo de dígitos especificado.
  /// </summary>
  TRuleMaxDigits = class(TRule)
  strict private
    FMaxLength: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MaxDigits'.
    /// </summary>
    /// <param name="AMaxLength">O número máximo de dígitos permitido.</param>
    constructor Create(const AMaxLength: Integer);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleMaxDigits }

constructor TRuleMaxDigits.Create(const AMaxLength: Integer);
begin
  inherited Create;
  if AMaxLength < 1 then
    raise Exception.Create('O comprimento máximo para a regra "MaxDigits" deve ser de no mínimo 1.');
  FMaxLength := AMaxLength;
end;

function TRuleMaxDigits.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
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
  Result := LValue.Length <= FMaxLength;

  if not Result then
    SetResultMessage(Format('O campo %s não pode ter mais de %d dígitos.', [AFieldName, FMaxLength]));
end;

end.
