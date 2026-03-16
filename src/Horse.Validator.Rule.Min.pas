unit Horse.Validator.Rule.Min;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo atinge um mínimo especificado.
  /// </summary>
  /// <remarks>
  ///   - Para números, valida o valor numérico (Value >= Min).
  ///   - Para strings, valida a quantidade de caracteres (Length >= Min).
  ///   Suporta limites definidos por valores fixos ou referências a outros campos.
  /// </remarks>
  TRuleMin = class(TRuleContextAware)
  strict private
    FMin: TArgument<Double>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Min'.
    /// </summary>
    /// <param name="AMin">Argumento representando o valor mínimo permitido.</param>
    constructor Create(const AMin: TArgument<Double>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleMin }

constructor TRuleMin.Create(const AMin: TArgument<Double>);
begin
  inherited Create;
  FMin := AMin;
end;

function TRuleMin.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LMinVal: Double;
  LIsReference: Boolean;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Tenta resolver o valor mínimo (pode vir de outro campo).
  try
    LMinVal := FMin.GetValue(FValueProvider);
    LIsReference := FMin.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o valor mínimo: %s', [E.Message]));
      Exit(False);
    end;
  end;

  if IsNumber(LValue) then
  begin
    // Validação Numérica
    Result := LValue.ToDouble >= LMinVal;

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s deve ser no mínimo igual ao campo %s.', [AFieldName, FMin.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ser no mínimo %f.', [AFieldName, LMinVal]));
    end;
  end
  else
  begin
    // Validação de Comprimento de String
    Result := LValue.Length >= Trunc(LMinVal);

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s não pode ter menos caracteres que o valor do campo %s.',
          [AFieldName, FMin.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ter no mínimo %d caracteres.',
          [AFieldName, Trunc(LMinVal)]));
    end;
  end;
end;

end.
