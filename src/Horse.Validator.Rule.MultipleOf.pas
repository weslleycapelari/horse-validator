unit Horse.Validator.Rule.MultipleOf;

interface

uses
  System.SysUtils,
  System.Math,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é um múltiplo de um número especificado.
  /// </summary>
  TRuleMultipleOf = class(TRule)
  strict private
    FMultiple: Double;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MultipleOf'.
    /// </summary>
    /// <param name="AValue">O número do qual o valor do campo deve ser um múltiplo.</param>
    constructor Create(const AValue: Double);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleMultipleOf }

constructor TRuleMultipleOf.Create(const AValue: Double);
begin
  inherited Create;
  if AValue = 0 then
    raise Exception.Create('O valor para a regra "MultipleOf" não pode ser zero.');
  FMultiple := AValue;
end;

function TRuleMultipleOf.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Epsilon para comparação de ponto flutuante, evitando erros de precisão.
  C_EPSILON = 1E-9;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // O campo deve ser um número para esta validação fazer sentido.
  if not IsNumber(LValue) then
  begin
    SetResultMessage(Format('O campo %s deve ser um valor numérico.', [AFieldName]));
    Exit(False);
  end;

  // Usamos FMod para calcular o resto da divisão de ponto flutuante.
  // Um número é múltiplo de outro se o resto da divisão for (próximo de) zero.
  Result := Abs(FMod(LValue.ToDouble, FMultiple)) < C_EPSILON;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um múltiplo de %f.', [AFieldName, FMultiple]));
end;

end.
