unit Horse.Validator.Rule.Same;

interface

uses
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é idêntico a um valor alvo.
  /// </summary>
  /// <remarks>
  ///   A comparação é feita como string, de forma case-sensitive.
  ///   Suporta comparação com valor literal ou referência a outro campo.
  /// </remarks>
  TRuleSame = class(TRuleContextAware)
  strict private
    FTarget: TArgument<Variant>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Same'.
    /// </summary>
    /// <param name="ATarget">O valor ou referência de campo para a comparação.</param>
    constructor Create(const ATarget: TArgument<Variant>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleSame }

constructor TRuleSame.Create(const ATarget: TArgument<Variant>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleSame.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LTargetVal: Variant;
  LTargetStr: string;
  LIsReference: Boolean;
begin
  // Nota: Não utilizamos Trim() no valor de entrada (AValue) para garantir
  // que a comparação seja exata, incluindo espaços em branco.

  // Resolve o valor alvo.
  try
    LTargetVal := FTarget.GetValue(FValueProvider);
    LTargetStr := VarToStr(LTargetVal);
    LIsReference := FTarget.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor de comparação para Same: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Realiza a comparação direta.
  Result := (AValue = LTargetStr);

  if not Result then
  begin
    if LIsReference then
      SetResultMessage(Format('O campo %s deve ser igual ao campo %s.', [AFieldName, FTarget.RefName]))
    else
      SetResultMessage(Format('O campo %s deve ser igual a "%s".', [AFieldName, LTargetStr]));
  end;
end;

end.
