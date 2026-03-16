unit Horse.Validator.Rule.IfVal;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Meta-regra que aplica um conjunto de validações apenas se uma condição for satisfeita.
  /// </summary>
  /// <remarks>
  ///   Permite criar lógica condicional complexa (ex: Campo B é obrigatório apenas se Campo A for 'Sim').
  /// </remarks>
  TRuleIfVal = class(TRuleContextAware)
  strict private
    FCondition: TFunc<Boolean>;
    FRules: TArray<IRule>;
  public
    /// <summary>Cria a regra condicional.</summary>
    /// <param name="ACondition">Função anônima que retorna True se as regras devem ser aplicadas.</param>
    /// <param name="ARules">Array de regras a serem validadas condicionalmente.</param>
    constructor Create(const ACondition: TFunc<Boolean>; const ARules: array of IRule);

    /// <summary>Injeta o provider nas regras filhas, se elas suportarem contexto.</summary>
    procedure SetValueProvider(const AProvider: TValueProvider); override;

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleIfVal }

constructor TRuleIfVal.Create(const ACondition: TFunc<Boolean>; const ARules: array of IRule);
var
  I: Integer;
begin
  inherited Create;
  FCondition := ACondition;

  // Copia as regras para o array interno.
  SetLength(FRules, Length(ARules));
  for I := Low(ARules) to High(ARules) do
    FRules[I] := ARules[I];
end;

procedure TRuleIfVal.SetValueProvider(const AProvider: TValueProvider);
var
  LRule: IRule;
begin
  inherited SetValueProvider(AProvider);

  // Propaga o ValueProvider para as regras aninhadas.
  // Isso permite que regras internas (como Same, GreaterThan) acessem outros campos.
  for LRule in FRules do
  begin
    if Supports(LRule, IRuleContextAware) then
      (LRule as TRuleContextAware).SetValueProvider(AProvider);
  end;
end;

function TRuleIfVal.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LRule: IRule;
begin
  Result := True;

  // 1. Verifica a condição externa.
  // Se a condição for falsa, ignoramos as regras internas e retornamos True (sucesso).
  if not FCondition() then
    Exit;

  // 2. Se a condição for verdadeira, validamos todas as regras internas.
  for LRule in FRules do
  begin
    if not LRule.Validate(AFieldName, AValue, ARequired) then
    begin
      Result := False;
      // Captura a mensagem de erro da regra específica que falhou.
      SetResultMessage(LRule.Message);
      Break; // Para na primeira falha (Fail Fast dentro do grupo condicional)
    end;
  end;
end;

end.
