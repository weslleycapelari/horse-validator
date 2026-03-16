unit Horse.Validator.Rule.LessThan;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é estritamente menor (<) que um valor alvo.
  /// </summary>
  /// <remarks>
  ///   - Se ambos os valores forem numéricos, compara os valores matematicamente.
  ///   - Caso contrário, compara o comprimento (Length) das strings.
  ///   Suporta comparação com valores literais ou valores de outros campos.
  /// </remarks>
  TRuleLessThan = class(TRuleContextAware)
  strict private
    FTarget: TArgument<Variant>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'LessThan'.
    /// </summary>
    /// <param name="ATarget">O valor ou referência de campo para comparação.</param>
    constructor Create(const ATarget: TArgument<Variant>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleLessThan }

constructor TRuleLessThan.Create(const ATarget: TArgument<Variant>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleLessThan.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LTargetVal: Variant;
  LTargetStr: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Resolve o valor alvo.
  try
    LTargetVal := FTarget.GetValue(FValueProvider);
    LTargetStr := VarToStr(LTargetVal).Trim;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor de comparação para LessThan: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Lógica de Comparação Polimórfica:
  // 1. Numérica.
  if IsNumber(LValue) and IsNumber(LTargetStr) then
  begin
    Result := LValue.ToDouble < LTargetStr.ToDouble;

    if not Result then
    begin
      if FTarget.&Type = atReference then
        SetResultMessage(Format('O campo %s deve ser menor que o campo %s.', [AFieldName, FTarget.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ser menor que %s.', [AFieldName, LTargetStr]));
    end;
  end
  else
  begin
    // 2. Comprimento (Length).

    if IsNumber(LTargetStr) then
    begin
      // Compara Length com Valor Numérico (ex: tamanho < 10).
      Result := LValue.Length < LTargetStr.ToDouble;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter menos de %s caracteres.', [AFieldName, LTargetStr]));
    end
    else
    begin
      // Compara Length com Length (ex: tamanho(A) < tamanho(B)).
      Result := LValue.Length < LTargetStr.Length;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter um comprimento menor que o do campo %s.',
          [AFieldName, FTarget.RefName]));
    end;
  end;
end;

end.
