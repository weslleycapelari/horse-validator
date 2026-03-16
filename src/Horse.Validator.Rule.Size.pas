unit Horse.Validator.Rule.Size;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo tem um "tamanho" específico.
  /// </summary>
  /// <remarks>
  ///   - Para strings, valida se o número de caracteres (length) é exatamente o valor especificado.
  ///   - Para números, valida se o valor numérico é exatamente o valor especificado.
  ///   Suporta limites definidos por valores fixos ou referências a outros campos.
  /// </remarks>
  TRuleSize = class(TRuleContextAware)
  strict private
    FSize: TArgument<Double>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'Size'.
    /// </summary>
    /// <param name="ASize">Argumento representando o tamanho exato requerido.</param>
    constructor Create(const ASize: TArgument<Double>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleSize }

constructor TRuleSize.Create(const ASize: TArgument<Double>);
begin
  inherited Create;
  FSize := ASize;
end;

function TRuleSize.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LTargetSize: Double;
  LIsReference: Boolean;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Tenta resolver o valor do tamanho alvo.
  try
    LTargetSize := FSize.GetValue(FValueProvider);
    LIsReference := FSize.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao resolver o tamanho alvo: %s', [E.Message]));
      Exit(False);
    end;
  end;

  if IsNumber(LValue) then
  begin
    // Validação Numérica
    // Nota: Comparação de ponto flutuante direta pode ser arriscada,
    // mas para validação de "Size" (geralmente inteiros ou quantidades exatas), é aceitável.
    Result := LValue.ToDouble = LTargetSize;

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s deve ser igual ao valor do campo %s.', [AFieldName, FSize.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ser igual a %f.', [AFieldName, LTargetSize]));
    end;
  end
  else
  begin
    // Validação de Comprimento de String
    Result := LValue.Length = Trunc(LTargetSize);

    if not Result then
    begin
      if LIsReference then
        SetResultMessage(Format('O campo %s deve ter o mesmo número de caracteres que o campo %s.',
          [AFieldName, FSize.RefName]))
      else
        SetResultMessage(Format('O campo %s deve ter exatamente %d caracteres.',
          [AFieldName, Trunc(LTargetSize)]));
    end;
  end;
end;

end.
