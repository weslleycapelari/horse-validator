unit Horse.Validator.Rule.AfterOrEqual;

interface

uses
  System.SysUtils,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base,
  Horse.Validator.DateUtils,
  Horse.Validator.Interfaces;

type
  /// <summary>
  ///   Valida se a data do campo é posterior ou igual a uma data de referência.
  /// </summary>
  /// <remarks>
  ///   Suporta comparação com uma data fixa (Literal) ou com a data contida em outro campo (Referência).
  /// </remarks>
  TRuleAfterOrEqual = class(TRuleContextAware)
  strict private
    FRefDate: TArgument<TDateTime>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'AfterOrEqual'.
    /// </summary>
    /// <param name="ARefDate">A data (ou referência) que serve como limite inferior inclusivo.</param>
    constructor Create(const ARefDate: TArgument<TDateTime>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleAfterOrEqual }

constructor TRuleAfterOrEqual.Create(const ARefDate: TArgument<TDateTime>);
begin
  inherited Create;
  FRefDate := ARefDate;
end;

function TRuleAfterOrEqual.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LInputDate: TDateTime;
  LTargetDate: TDateTime;
  LIsReference: Boolean;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Passo 1: Verifica se o valor de entrada é uma data válida.
  if not IsDateTime(LValue, LInputDate) then
  begin
    SetResultMessage(Format('O campo %s não contém uma data válida.', [AFieldName]));
    Exit(False);
  end;

  // Passo 2: Resolve a data de referência (pode vir de outro campo).
  try
    LTargetDate := FRefDate.GetValue(FValueProvider, FCurrentFieldPath);
    LIsReference := FRefDate.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao obter a data de referência para validação AfterOrEqual: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Passo 3: Compara as datas.
  Result := LInputDate >= LTargetDate;

  if not Result then
  begin
    if LIsReference then
      SetResultMessage(Format('O campo %s deve ser uma data posterior ou igual ao campo %s.',
        [AFieldName, FRefDate.RefName]))
    else
      SetResultMessage(Format('O campo %s deve ser uma data posterior ou igual a %s.',
        [AFieldName, DateTimeToStr(LTargetDate)]));
  end;
end;

end.
