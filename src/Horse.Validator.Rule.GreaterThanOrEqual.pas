unit Horse.Validator.Rule.GreaterThanOrEqual;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é maior ou igual (>=) a um valor alvo.
  /// </summary>
  /// <remarks>
  ///   - Se ambos os valores forem numéricos, compara os valores matematicamente.
  ///   - Caso contrário, compara o comprimento (Length) das strings.
  ///   Suporta comparação com valores literais ou valores de outros campos.
  /// </remarks>
  TRuleGreaterThanOrEqual = class(TRuleContextAware)
  strict private
    FTarget: TArgument<Variant>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'GreaterThanOrEqual'.
    /// </summary>
    /// <param name="ATarget">O valor ou referência de campo para comparação.</param>
    constructor Create(const ATarget: TArgument<Variant>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleGreaterThanOrEqual }

constructor TRuleGreaterThanOrEqual.Create(const ATarget: TArgument<Variant>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleGreaterThanOrEqual.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
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
      SetResultMessage(Format('Erro ao resolver o valor de comparação para GreaterThanOrEqual: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Lógica de Comparação Polimórfica:
  // 1. Numérica.
  if IsNumber(LValue) and IsNumber(LTargetStr) then
  begin
    Result := LValue.ToDouble >= LTargetStr.ToDouble;

    if not Result then
    begin
      if FTarget.&Type = atReference then
        SetResultMessage(Format('O campo %s deve ser maior ou igual ao campo %s.', [AFieldName, FTarget.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ser maior ou igual a %s.', [AFieldName, LTargetStr]));
    end;
  end
  else
  begin
    // 2. Comprimento (Length).

    if IsNumber(LTargetStr) then
    begin
      // Compara Length com Valor Numérico (ex: tamanho >= 5).
      Result := LValue.Length >= LTargetStr.ToDouble;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter no mínimo %s caracteres.', [AFieldName, LTargetStr]));
    end
    else
    begin
      // Compara Length com Length (ex: tamanho(A) >= tamanho(B)).
      Result := LValue.Length >= LTargetStr.Length;
      if not Result then
        SetResultMessage(Format('O campo %s deve ter um comprimento maior ou igual ao do campo %s.',
          [AFieldName, FTarget.RefName]));
    end;
  end;
end;

end.
