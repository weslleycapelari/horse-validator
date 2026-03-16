unit Horse.Validator.Rule.MinCount;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se um campo (que deve ser um array JSON) contém no mínimo um número especificado de itens.
  /// </summary>
  TRuleMinCount = class(TRule)
  strict private
    FMinCount: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MinCount'.
    /// </summary>
    /// <param name="AMinCount">A quantidade mínima de itens que o array deve conter.</param>
    constructor Create(const AMinCount: Integer);

    /// <summary>Executa a validação da regra "MinCount".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON;

{ TRuleMinCount }

constructor TRuleMinCount.Create(const AMinCount: Integer);
begin
  inherited Create;
  if AMinCount < 0 then
    raise Exception.Create('A contagem mínima para a regra "MinCount" não pode ser negativa.');
  FMinCount := AMinCount;
end;

function TRuleMinCount.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONValue: TJSONValue;
  LJSONArray: TJSONArray;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Passo 1: O campo deve ser um array JSON válido.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);
    if not (Assigned(LJSONValue) and (LJSONValue is TJSONArray)) then
    begin
      if Assigned(LJSONValue) then LJSONValue.Free;
      Result := False;
      SetResultMessage(Format('O campo %s deve ser um array JSON.', [AFieldName]));
      Exit;
    end;
    LJSONArray := LJSONValue as TJSONArray;
  except
    Result := False;
    SetResultMessage(Format('O campo %s não é um array JSON válido.', [AFieldName]));
    Exit;
  end;

  // Passo 2: Verifica a contagem de itens.
  try
    Result := LJSONArray.Count >= FMinCount;

    if not Result then
      SetResultMessage(Format('O campo %s deve conter no mínimo %d itens.', [AFieldName, FMinCount]));
  finally
    LJSONArray.Free;
  end;
end;

end.
