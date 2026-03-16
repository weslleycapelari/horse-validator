unit Horse.Validator.Rule.RequiredIf;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é obrigatório somente se outro campo atender a uma condição.
  /// </summary>
  TRuleRequiredIf = class(TRuleContextAware)
  strict private
    FOtherFieldName: string;
    FExpectedValue: string;
    FRules: TArray<IRule>;
    FOperator: string;
  public
    /// <summary>Cria uma nova instância da regra 'RequiredIf'.</summary>
    constructor Create(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses Horse.Validator.Rule.Required;

{ TRuleRequiredIf }

constructor TRuleRequiredIf.Create(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule);
var
  i: Integer;
begin
  inherited Create;
  FOtherFieldName := AOtherFieldName;
  FExpectedValue := AExpectedValue;
  FOperator := AOperator;
  SetLength(FRules, Length(ARules));
  if Length(ARules) > 0 then
    for i := 0 to High(ARules) do
      FRules[i] := ARules[i]
  else
    FRules[0] := TRuleRequired.Create;
end;

function TRuleRequiredIf.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LOtherFieldValue: string;
  LConditionMet: Boolean;
  LRule: IRule;
begin
  if not Assigned(FValueProvider) then
    raise Exception.Create('A regra RequiredIf requer um ValueProvider.');

  LOtherFieldValue := FValueProvider(FOtherFieldName);

  LConditionMet := False;
       if FOperator = '=' then  LConditionMet := (LOtherFieldValue = FExpectedValue)
  else if FOperator = '<>' then LConditionMet := (LOtherFieldValue <> FExpectedValue)
  else if FOperator = '>' then  LConditionMet := (LOtherFieldValue > FExpectedValue)
  else if FOperator = '<' then  LConditionMet := (LOtherFieldValue < FExpectedValue)
  else if FOperator = '>=' then LConditionMet := (LOtherFieldValue >= FExpectedValue)
  else if FOperator = '<=' then LConditionMet := (LOtherFieldValue <= FExpectedValue);

  // Se a condição não for atendida, a validação passa automaticamente.
  if not LConditionMet then
    Exit(True);

  // Se a condição for atendida, aplica a regra 'Required'.
  for LRule in FRules do
  begin
    if not LRule.Validate(AFieldName, AValue, ARequired) then
    begin
      Result := false;
      SetResultMessage(LRule.Message);
      Exit;
    end;
  end;

  Result := True;
end;

end.
