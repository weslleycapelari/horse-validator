unit Horse.Validator.Rule.Different;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é diferente de um valor alvo.
  /// </summary>
  /// <remarks>
  ///   A comparação é feita como string, de forma case-sensitive.
  ///   Suporta comparação com valor literal ou referência a outro campo.
  /// </remarks>
  TRuleDifferent = class(TRuleContextAware)
  strict private
    FTarget: TArgument<Variant>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Different'.
    /// </summary>
    /// <param name="ATarget">O valor ou referência de campo para a comparação.</param>
    constructor Create(const ATarget: TArgument<Variant>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleDifferent }

constructor TRuleDifferent.Create(const ATarget: TArgument<Variant>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleDifferent.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LTargetVal: Variant;
  LTargetStr: string;
  LIsReference: Boolean;
begin
  // Nota: Para a regra "different", o valor do campo atual não é trimado,
  // pois a presença de espaços pode ser a diferença intencional.

  // Resolve o valor alvo.
  try
    LTargetVal := FTarget.GetValue(FValueProvider);
    LTargetStr := VarToStr(LTargetVal);
    LIsReference := FTarget.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor de comparação para Different: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Realiza a comparação.
  Result := (AValue <> LTargetStr);

  if not Result then
  begin
    if LIsReference then
      SetResultMessage(Format('O campo %s deve ser diferente do campo %s.', [AFieldName, FTarget.RefName]))
    else
      SetResultMessage(Format('O campo %s deve ter um valor diferente de "%s".', [AFieldName, LTargetStr]));
  end;
end;

end.
