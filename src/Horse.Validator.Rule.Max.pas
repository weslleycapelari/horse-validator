unit Horse.Validator.Rule.Max;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo não excede um máximo especificado.
  /// </summary>
  /// <remarks>
  ///   - Para números, valida o valor numérico (Value &lt;= Max).
  ///   - Para strings, valida a quantidade de caracteres (Length &lt;= Max).
  ///   Suporta limites definidos por valores fixos ou referências a outros campos.
  /// </remarks>
  TRuleMax = class(TRuleContextAware)
  strict private
    FMax: TArgument<Double>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Max'.
    /// </summary>
    /// <param name="AMax">Argumento representando o valor máximo permitido.</param>
    constructor Create(const AMax: TArgument<Double>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleMax }

constructor TRuleMax.Create(const AMax: TArgument<Double>);
begin
  inherited Create;
  FMax := AMax;
end;

function TRuleMax.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LMaxVal: Double;
  LIsReference: Boolean;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Tenta resolver o valor máximo (pode vir de outro campo).
  try
    LMaxVal := FMax.GetValue(FValueProvider);
    LIsReference := FMax.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor máximo: %s', [E.Message]));
      Exit(False);
    end;
  end;

  if IsNumber(LValue) then
  begin
    // Validação Numérica
    Result := LValue.ToDouble <= LMaxVal;

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s não pode ser maior que o campo %s.', [AFieldName, FMax.RefName]))
      else
        SetResultMessage(Format('O campo %s não pode ser maior que %f.', [AFieldName, LMaxVal]));
    end;
  end
  else
  begin
    // Validação de Comprimento de String
    Result := LValue.Length <= Trunc(LMaxVal);

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s não pode ter mais caracteres que o valor do campo %s.',
          [AFieldName, FMax.RefName]))
      else
        SetResultMessage(Format('O campo %s não pode ter mais de %d caracteres.',
          [AFieldName, Trunc(LMaxVal)]));
    end;
  end;
end;

end.
