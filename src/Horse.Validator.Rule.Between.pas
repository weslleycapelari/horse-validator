unit Horse.Validator.Rule.Between;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo está dentro de um intervalo (inclusivo).
  /// </summary>
  /// <remarks>
  ///   - Para números, valida o valor numérico.
  ///   - Para strings, valida a quantidade de caracteres (Length).
  ///   Suporta limites definidos por valores fixos ou referências a outros campos.
  /// </remarks>
  TRuleBetween = class(TRuleContextAware)
  strict private
    FMin: TArgument<Double>;
    FMax: TArgument<Double>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Between'.
    /// </summary>
    /// <param name="AMin">Argumento representando o valor mínimo.</param>
    /// <param name="AMax">Argumento representando o valor máximo.</param>
    constructor Create(const AMin, AMax: TArgument<Double>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleBetween }

constructor TRuleBetween.Create(const AMin, AMax: TArgument<Double>);
begin
  inherited Create;
  FMin := AMin;
  FMax := AMax;
end;

function TRuleBetween.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LMinVal, LMaxVal, LNumericValue: Double;
  LStrLength: Integer;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Resolve os valores dos limites (pode buscar de outros campos se for referência)
  try
    LMinVal := FMin.GetValue(FValueProvider);
    LMaxVal := FMax.GetValue(FValueProvider);
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver os limites da validação Between: %s', [E.Message]));
      Exit(False);
    end;
  end;

  if LMaxVal < LMinVal then
  begin
    SetResultMessage('Configuração inválida: o valor máximo não pode ser menor que o mínimo.');
    Exit(False);
  end;

  if IsNumber(LValue) then
  begin
    // Validação Numérica
    LNumericValue := LValue.ToDouble;
    Result := (LNumericValue >= LMinVal) and (LNumericValue <= LMaxVal);

    if not Result then
      SetResultMessage(Format('O campo %s deve estar entre %f e %f.', [AFieldName, LMinVal, LMaxVal]));
  end
  else
  begin
    // Validação de Comprimento de String (trunca os limites para inteiros)
    LStrLength := LValue.Length;
    Result := (LStrLength >= Trunc(LMinVal)) and (LStrLength <= Trunc(LMaxVal));

    if not Result then
      SetResultMessage(Format('O campo %s deve ter entre %d e %d caracteres.',
        [AFieldName, Trunc(LMinVal), Trunc(LMaxVal)]));
  end;
end;

end.
