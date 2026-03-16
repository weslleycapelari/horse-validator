unit Horse.Validator.Rule.GreaterThan;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é estritamente maior (>) que um valor alvo.
  /// </summary>
  /// <remarks>
  ///   - Se ambos os valores forem numéricos, compara os valores matematicamente.
  ///   - Caso contrário, compara o comprimento (Length) das strings.
  ///   Suporta comparação com valores literais ou valores de outros campos.
  /// </remarks>
  TRuleGreaterThan = class(TRuleContextAware)
  strict private
    FTarget: TArgument<Variant>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'GreaterThan'.
    /// </summary>
    /// <param name="ATarget">O valor ou referência de campo para comparação.</param>
    constructor Create(const ATarget: TArgument<Variant>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleGreaterThan }

constructor TRuleGreaterThan.Create(const ATarget: TArgument<Variant>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleGreaterThan.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LTargetVal: Variant;
  LTargetStr: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Resolve o valor alvo (pode vir de um literal ou de outro campo).
  try
    LTargetVal := FTarget.GetValue(FValueProvider);
    LTargetStr := VarToStr(LTargetVal).Trim;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor de comparação para GreaterThan: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Lógica de Comparação Polimórfica:
  // 1. Se ambos forem numéricos, compara valores (Ex: 10 > 5).
  if IsNumber(LValue) and IsNumber(LTargetStr) then
  begin
    Result := LValue.ToDouble > LTargetStr.ToDouble;

    if not Result then
    begin
      if FTarget.&Type = atReference then
        SetResultMessage(Format('O campo %s deve ser maior que o campo %s.', [AFieldName, FTarget.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ser maior que %s.', [AFieldName, LTargetStr]));
    end;
  end
  else
  begin
    // 2. Se não forem ambos números, compara o comprimento da string atual
    // com o valor alvo (assumindo que o alvo representa um tamanho ou outra string).
    // Se o alvo for numérico, comparamos Length(Valor) > Alvo.
    // Se o alvo for string, comparamos Length(Valor) > Length(Alvo).

    if IsNumber(LTargetStr) then
    begin
      // Compara Length com Número (ex: string deve ter mais que 5 chars).
      Result := LValue.Length > LTargetStr.ToDouble;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter mais de %s caracteres.', [AFieldName, LTargetStr]));
    end
    else
    begin
      // Compara Length com Length (ex: string A deve ser maior que string B).
      Result := LValue.Length > LTargetStr.Length;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter um comprimento maior que o do campo %s.',
          [AFieldName, FTarget.RefName]));
    end;
  end;
end;

end.
