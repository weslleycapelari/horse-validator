unit Horse.Validator.Rule.CNPJ;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém um CNPJ (Cadastro Nacional da Pessoa Jurídica) brasileiro válido.
  /// </summary>
  /// <remarks>
  ///   A validação remove caracteres de formatação (pontos, barra e hífen), verifica o
  ///   comprimento de 14 dígitos, rejeita sequências de dígitos repetidos e
  ///   calcula os dois dígitos verificadores para confirmar a validade matemática.
  /// </remarks>
  TRuleCNPJ = class(TRule)
  public
    /// <summary>Executa a validação da regra "CNPJ".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleCNPJ }

function TRuleCNPJ.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LCNPJ: string;
  LChar: Char;
  LWeights1, LWeights2: TArray<Integer>;
  LSum, LRemainder, LDigit1, LDigit2: Integer;
  I: Integer;
  LAllDigitsSame: Boolean;
begin
  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and AValue.IsEmpty then
    Exit(True);

  // Passo 1: Limpa a string, mantendo apenas os dígitos.
  LCNPJ := '';
  for LChar in AValue do
  begin
    if CharInSet(LChar, ['0'..'9']) then
      LCNPJ := LCNPJ + LChar;
  end;

  // Passo 2: Verifica se o CNPJ tem 14 dígitos.
  if Length(LCNPJ) <> 14 then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CNPJ válido.', [AFieldName]));
    Exit;
  end;

  // Passo 3: Verifica se todos os dígitos são iguais (ex: '11111111111111'), o que é inválido.
  LAllDigitsSame := True;
  for I := 2 to 14 do
  begin
    if LCNPJ[I] <> LCNPJ[1] then
    begin
      LAllDigitsSame := False;
      Break;
    end;
  end;
  if LAllDigitsSame then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CNPJ válido.', [AFieldName]));
    Exit;
  end;

  // Passo 4: Calcula o primeiro dígito verificador.
  SetLength(LWeights1, 12);
  LWeights1 := [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  LSum := 0;
  for I := 0 to 11 do
    LSum := LSum + StrToInt(LCNPJ[I + 1]) * LWeights1[I];
  LRemainder := LSum mod 11;
  if LRemainder < 2 then
    LDigit1 := 0
  else
    LDigit1 := 11 - LRemainder;

  // Passo 5: Verifica se o primeiro dígito calculado corresponde ao dígito informado.
  if LDigit1 <> StrToInt(LCNPJ[13]) then
  begin
    Result := False;
    SetResultMessage(Format('O campo %s não é um CNPJ válido.', [AFieldName]));
    Exit;
  end;

  // Passo 6: Calcula o segundo dígito verificador.
  SetLength(LWeights2, 13);
  LWeights2 := [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  LSum := 0;
  for I := 0 to 12 do
    LSum := LSum + StrToInt(LCNPJ[I + 1]) * LWeights2[I];
  LRemainder := LSum mod 11;
  if LRemainder < 2 then
    LDigit2 := 0
  else
    LDigit2 := 11 - LRemainder;

  // Passo 7: Verifica se o segundo dígito calculado corresponde ao dígito informado.
  Result := LDigit2 = StrToInt(LCNPJ[14]);

  if not Result then
    SetResultMessage(Format('O campo %s não é um CNPJ válido.', [AFieldName]));
end;

end.
