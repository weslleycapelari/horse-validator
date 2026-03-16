unit Horse.Validator.Rule.Base;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces;

type
  /// <summary>Classe base abstrata para todas as regras de validação.</summary>
  /// <remarks>
  ///   Implementa a interface IRule e fornece a infraestrutura básica,
  ///   incluindo o gerenciamento de mensagens de erro e funções auxiliares.
  /// </remarks>
  TRule = class(TInterfacedObject, IRule)
  strict private
    FUserMessage: string;
    FResultMessage: string;
  protected
    /// <summary>Verifica se a string representa um número válido (inteiro ou decimal).</summary>
    function IsNumber(const AValue: string): Boolean;

    /// <summary>Verifica se a string representa apenas dígitos numéricos.</summary>
    function IsInteger(const AValue: string): Boolean;

    /// <summary>Define a mensagem de erro resultante da lógica de validação interna.</summary>
    procedure SetResultMessage(const AMessage: string);

    // Implementação dos métodos de IRule
    function GetMessage: string;
    function SetMessage(const AMessage: string): IRule;
  public
    constructor Create;

    /// <summary>Método abstrato de validação a ser implementado pelas regras concretas.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; virtual; abstract;
  end;

  /// <summary>Classe base para regras que necessitam consultar valores de outros campos (Contexto).</summary>
  TRuleContextAware = class(TRule, IRuleContextAware)
  protected
    FValueProvider: TValueProvider;
    FCurrentFieldPath: string;
  public
    /// <summary>Recebe a injeção do provedor de valores do validador.</summary>
    procedure SetValueProvider(const AProvider: TValueProvider); virtual;
    /// <summary>Recebe o caminho do campo atual antes da validação.</summary>
    procedure SetCurrentFieldPath(const APath: string); virtual;
  end;

implementation

uses
  System.RegularExpressions;

{ TRule }

constructor TRule.Create;
begin
  inherited Create;
  FUserMessage := '';
  FResultMessage := '';
end;

function TRule.GetMessage: string;
begin
  // Prioriza a mensagem customizada pelo usuário via .SetMessage()
  if not FUserMessage.IsEmpty then
    Result := FUserMessage
  else
    Result := FResultMessage;
end;

function TRule.IsInteger(const AValue: string): Boolean;
begin
  Result := TRegEx.IsMatch(AValue.Trim, '^[\d]+$');
end;

function TRule.IsNumber(const AValue: string): Boolean;
begin
  // Aceita números inteiros ou com casas decimais (separador ponto ou vírgula)
  Result := TRegEx.IsMatch(AValue.Trim, '^[\d]+([.,]\d+)?$');
end;

function TRule.SetMessage(const AMessage: string): IRule;
begin
  FUserMessage := AMessage;
  Result := Self;
end;

procedure TRule.SetResultMessage(const AMessage: string);
begin
  FResultMessage := AMessage;
end;

{ TRuleContextAware }

procedure TRuleContextAware.SetCurrentFieldPath(const APath: string);
begin
  FCurrentFieldPath := APath;
end;

procedure TRuleContextAware.SetValueProvider(const AProvider: TValueProvider);
begin
  FValueProvider := AProvider;
end;

end.
