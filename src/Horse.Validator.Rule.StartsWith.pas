unit Horse.Validator.Rule.StartsWith;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo começa com uma das substrings especificadas.
  /// </summary>
  /// <remarks>
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleStartsWith = class(TRule)
  strict private
    FSubstrings: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'StartsWith'.
    /// </summary>
    /// <param name="ASubstrings">Um array de substrings permitidas no início do valor.</param>
    constructor Create(const ASubstrings: array of string);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleStartsWith }

constructor TRuleStartsWith.Create(const ASubstrings: array of string);
var
  LCount: Integer;
begin
  inherited Create;
  SetLength(FSubstrings, Length(ASubstrings));
  for LCount := Low(ASubstrings) to High(ASubstrings) do
    FSubstrings[LCount] := ASubstrings[LCount];
end;

function TRuleStartsWith.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LSubstring: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação falha por padrão, até que uma correspondência seja encontrada.
  Result := False;
  for LSubstring in FSubstrings do
  begin
    // TStringHelper.StartsWith com o terceiro parâmetro True realiza uma comparação case-insensitive.
    if LValue.StartsWith(LSubstring, True) then
    begin
      Result := True;
      Break;
    end;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve começar com um dos valores especificados.', [AFieldName]));
end;

end.
