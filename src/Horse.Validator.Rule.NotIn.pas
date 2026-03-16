unit Horse.Validator.Rule.NotIn;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo NÃO está contido em um conjunto predefinido de valores.
  /// </summary>
  /// <remarks>
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleNotIn = class(TRule)
  strict private
    FForbiddenItems: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'NotIn'.
    /// </summary>
    /// <param name="AValues">Um array de valores proibidos (strings, inteiros, etc.).</param>
    constructor Create(const AValues: array of Variant);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.StrUtils;

{ TRuleNotIn }

constructor TRuleNotIn.Create(const AValues: array of Variant);
var
  LCount: Integer;
begin
  inherited Create;
  // Converte todos os valores de entrada (Variants) para um array de strings
  // para facilitar a comparação posterior.
  SetLength(FForbiddenItems, Length(AValues));
  for LCount := Low(AValues) to High(AValues) do
    FForbiddenItems[LCount] := VarToStr(AValues[LCount]);
end;

function TRuleNotIn.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação passa se o valor NÃO for encontrado (MatchStr retorna False).
  Result := not MatchStr(LValue, FForbiddenItems);

  if not Result then
    SetResultMessage(Format('O valor selecionado para o campo %s não é permitido.', [AFieldName]));
end;

end.
