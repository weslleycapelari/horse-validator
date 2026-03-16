unit Horse.Validator.Rule.DoesntEndWith;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo não termina com nenhuma das substrings especificadas.
  /// </summary>
  /// <remarks>
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleDoesntEndWith = class(TRule)
  strict private
    FSubstrings: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'DoesntEndWith'.
    /// </summary>
    /// <param name="ASubstrings">Um array de substrings proibidas no final do valor.</param>
    constructor Create(const ASubstrings: array of string);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleDoesntEndWith }

constructor TRuleDoesntEndWith.Create(const ASubstrings: array of string);
var
  LCount: Integer;
begin
  inherited Create;
  SetLength(FSubstrings, Length(ASubstrings));
  for LCount := Low(ASubstrings) to High(ASubstrings) do
    FSubstrings[LCount] := ASubstrings[LCount];
end;

function TRuleDoesntEndWith.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LSubstring: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Assume que a validação passa, a menos que uma correspondência proibida seja encontrada.
  Result := True;
  for LSubstring in FSubstrings do
  begin
    // TStringHelper.EndsWith com o terceiro parâmetro True realiza uma comparação case-insensitive.
    if LValue.EndsWith(LSubstring, True) then
    begin
      Result := False;
      Break;
    end;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s não pode terminar com um dos valores especificados.', [AFieldName]));
end;

end.
