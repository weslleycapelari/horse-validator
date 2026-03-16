unit Horse.Validator.Rule.uIn;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo está contido em um conjunto predefinido de valores.
  /// </summary>
  /// <remarks>
  ///   A validação é case-insensitive.
  /// </remarks>
  TRuleIn = class(TRule)
  strict private
    FValidItems: TArray<string>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'In'.
    /// </summary>
    /// <param name="AValues">Um array de valores permitidos (strings, inteiros, etc.).</param>
    constructor Create(const AValues: array of Variant);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.StrUtils;

{ TRuleIn }

constructor TRuleIn.Create(const AValues: array of Variant);
var
  LCount: Integer;
begin
  inherited Create;
  // Converte todos os valores de entrada (Variants) para um array de strings
  // para facilitar a comparação posterior.
  SetLength(FValidItems, Length(AValues));
  for LCount := Low(AValues) to High(AValues) do
    FValidItems[LCount] := VarToStr(AValues[LCount]);
end;

function TRuleIn.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // MatchStr faz uma busca case-insensitive do valor no array de itens válidos.
  Result := MatchStr(LValue, FValidItems);

  if not Result then
    SetResultMessage(Format('O valor selecionado para o campo %s não é válido.', [AFieldName]));
end;

end.
