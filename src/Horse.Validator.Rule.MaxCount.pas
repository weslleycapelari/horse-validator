unit Horse.Validator.Rule.MaxCount;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se um campo (que deve ser um array JSON) contém no máximo um número especificado de itens.
  /// </summary>
  TRuleMaxCount = class(TRule)
  strict private
    FMaxCount: Integer;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'MaxCount'.
    /// </summary>
    /// <param name="AMaxCount">A quantidade máxima de itens que o array deve conter.</param>
    constructor Create(const AMaxCount: Integer);

    /// <summary>Executa a validação da regra "MaxCount".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON;

{ TRuleMaxCount }

constructor TRuleMaxCount.Create(const AMaxCount: Integer);
begin
  inherited Create;
  if AMaxCount < 0 then
    raise Exception.Create('A contagem máxima para a regra "MaxCount" não pode ser negativa.');
  FMaxCount := AMaxCount;
end;

function TRuleMaxCount.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
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
    Result := LJSONArray.Count <= FMaxCount;

    if not Result then
      SetResultMessage(Format('O campo %s não pode conter mais de %d itens.', [AFieldName, FMaxCount]));
  finally
    LJSONArray.Free;
  end;
end;

end.
