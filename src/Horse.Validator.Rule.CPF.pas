unit Horse.Validator.Rule.CPF;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém um CPF (Cadastro de Pessoas Físicas) brasileiro válido.
  /// </summary>
  /// <remarks>
  ///   A validação remove caracteres de formatação (pontos e hífen), verifica o
  ///   comprimento de 11 dígitos, rejeita sequências de dígitos repetidos e
  ///   calcula os dois dígitos verificadores para confirmar a validade matemática.
  /// </remarks>
  TRuleCPF = class(TRule)
  public
    /// <summary>Executa a validação da regra "CPF".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleCPF }

function TRuleCPF.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LCPF: string;
  LChar: Char;
  LSum, LRemainder, LDigit1, LDigit2: Integer;
  I: Integer;
  LAllDigitsSame: Boolean;
begin
  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and AValue.IsEmpty then
    Exit(True);

  // Passo 1: Limpa a string, mantendo apenas os dígitos.
  LCPF := '';
  for LChar in AValue do
  begin
    if CharInSet(LChar, ['0'..'9']) then
      LCPF := LCPF + LChar;
  end;

  // Passo 2: Verifica se o CPF tem 11 dígitos.
  if Length(LCPF) <> 11 then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CPF válido.', [AFieldName]));
    Exit;
  end;

  // Passo 3: Verifica se todos os dígitos são iguais (ex: '11111111111'), o que é inválido.
  LAllDigitsSame := True;
  for I := 2 to 11 do
  begin
    if LCPF[I] <> LCPF[1] then
    begin
      LAllDigitsSame := False;
      Break;
    end;
  end;
  if LAllDigitsSame then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CPF válido.', [AFieldName]));
    Exit;
  end;

  // Passo 4: Calcula o primeiro dígito verificador.
  LSum := 0;
  for I := 1 to 9 do
    LSum := LSum + StrToInt(LCPF[I]) * (11 - I);
  LRemainder := (LSum * 10) mod 11;
  if LRemainder = 10 then
    LRemainder := 0;
  LDigit1 := LRemainder;

  // Passo 5: Verifica se o primeiro dígito calculado corresponde ao dígito informado.
  if LDigit1 <> StrToInt(LCPF[10]) then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CPF válido.', [AFieldName]));
    Exit;
  end;

  // Passo 6: Calcula o segundo dígito verificador.
  LSum := 0;
  for I := 1 to 10 do
    LSum := LSum + StrToInt(LCPF[I]) * (12 - I);
  LRemainder := (LSum * 10) mod 11;
  if LRemainder = 10 then
    LRemainder := 0;
  LDigit2 := LRemainder;

  // Passo 7: Verifica se o segundo dígito calculado corresponde ao dígito informado.
  Result := LDigit2 = StrToInt(LCPF[11]);

  if not Result then
    SetResultMessage(Format('O campo %s não é um CPF válido.', [AFieldName]));
end;

end.
