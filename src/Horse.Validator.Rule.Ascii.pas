unit Horse.Validator.Rule.Ascii;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo contém apenas caracteres ASCII de 7 bits (0-127).
  /// </summary>
  TRuleAscii = class(TRule)
  public
    /// <summary>Executa a validação da regra "Ascii".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleAscii }

function TRuleAscii.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  C: Char;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  Result := True;

  // Itera sobre cada caractere da string.
  for C in LValue do
  begin
    // O conjunto ASCII padrão vai de 0 a 127.
    // Caracteres acima disso (acentos, símbolos estendidos, emojis) fazem a validação falhar.
    if Ord(C) > 127 then
    begin
      Result := False;
      Break;
    end;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve conter apenas caracteres ASCII de 7 bits.', [AFieldName]));
end;

end.
