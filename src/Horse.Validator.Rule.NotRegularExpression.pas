unit Horse.Validator.Rule.NotRegularExpression;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo NÃO corresponde a uma expressão regular (RegEx) fornecida.
  /// </summary>
  TRuleNotRegularExpression = class(TRule)
  strict private
    FPattern: string;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'NotRegularExpression'.
    /// </summary>
    /// <param name="APattern">O padrão de expressão regular a ser negado.</param>
    constructor Create(const APattern: string);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleNotRegularExpression }

constructor TRuleNotRegularExpression.Create(const APattern: string);
begin
  inherited Create;
  FPattern := APattern;
end;

function TRuleNotRegularExpression.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação passa se o valor NÃO corresponder ao padrão.
  Result := not TRegEx.IsMatch(LValue, FPattern);

  if not Result then
    SetResultMessage(Format('O formato do campo %s não é permitido.', [AFieldName]));
end;

end.
