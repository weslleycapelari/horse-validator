unit Horse.Validator.Rule.RegularExpression;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo corresponde a uma expressão regular (RegEx) fornecida.
  /// </summary>
  TRuleRegularExpression = class(TRule)
  strict private
    FPattern: string;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'RegularExpression'.
    /// </summary>
    /// <param name="APattern">O padrão de expressão regular a ser verificado.</param>
    constructor Create(const APattern: string);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.RegularExpressions;

{ TRuleRegularExpression }

constructor TRuleRegularExpression.Create(const APattern: string);
begin
  inherited Create;
  FPattern := APattern;
end;

function TRuleRegularExpression.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação passa se o valor corresponder ao padrão Regex fornecido.
  Result := TRegEx.IsMatch(LValue, FPattern);

  if not Result then
    SetResultMessage(Format('O formato do campo %s é inválido.', [AFieldName]));
end;

end.
