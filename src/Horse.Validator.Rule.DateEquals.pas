unit Horse.Validator.Rule.DateEquals;

interface

uses
  System.SysUtils,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base,
  Horse.Validator.DateUtils,
  Horse.Validator.Interfaces;

type
  /// <summary>
  ///   Valida se a data do campo é igual a uma data especificada.
  /// </summary>
  /// <remarks>
  ///   A comparação ignora a parte do tempo de ambos os valores, comparando apenas o dia, mês e ano.
  ///   Suporta comparação com valor literal ou referência a outro campo.
  /// </remarks>
  TRuleDateEquals = class(TRuleContextAware)
  strict private
    FTarget: TArgument<TDateTime>;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'DateEquals'.
    /// </summary>
    /// <param name="ATarget">A data (ou referência) para comparação.</param>
    constructor Create(const ATarget: TArgument<TDateTime>);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.DateUtils;

{ TRuleDateEquals }

constructor TRuleDateEquals.Create(const ATarget: TArgument<TDateTime>);
begin
  inherited Create;
  FTarget := ATarget;
end;

function TRuleDateEquals.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
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

  // Passo 2: Resolve a data alvo.
  try
    LTargetDate := FTarget.GetValue(FValueProvider);
    LIsReference := FTarget.&Type = atReference;
  except
    on E: Exception do
    begin
      SetResultMessage(Format('Erro ao obter a data de comparação para DateEquals: %s', [E.Message]));
      Exit(False);
    end;
  end;

  // Passo 3: Compara apenas a parte da data (ignora hora).
  Result := CompareDate(LInputDate, LTargetDate) = 0;

  if not Result then
  begin
    if LIsReference then
      SetResultMessage(Format('O campo %s deve ser uma data igual ao campo %s.', [AFieldName, FTarget.RefName]))
    else
      SetResultMessage(Format('O campo %s deve ser a data %s.', [AFieldName, DateToStr(LTargetDate)]));
  end;
end;

end.
