unit Horse.Validator.Rule.Distinct;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se todos os valores dentro de um campo (que deve ser um array JSON) são únicos.
  /// </summary>
  /// <remarks>
  ///   A validação é feita na representação string de cada item do array.
  ///   Funciona para arrays de valores simples como `[1, 2, 3]` ou `["a", "b", "c"]`.
  /// </remarks>
  TRuleDistinct = class(TRule)
  public
    /// <summary>Executa a validação da regra "Distinct".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.JSON,
  System.Generics.Collections;

{ TRuleDistinct }

function TRuleDistinct.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LJSONArray: TJSONArray;
  LJSONValue: TJSONValue;
  LSeenValues: TDictionary<string, Boolean>;
  LItem: TJSONValue;
  LItemValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Passo 1: O campo deve ser um array JSON válido.
  try
    LJSONValue := TJSONObject.ParseJSONValue(LValue);
    if not (LJSONValue is TJSONArray) then
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

  // Passo 2: Verifica a unicidade dos itens.
  LSeenValues := TDictionary<string, Boolean>.Create;
  Result := True; // Assume que é válido até encontrar um duplicado.
  try
    for LItem in LJSONArray do
    begin
      // Usamos LItem.Value para obter a representação string do item (seja ele número, string, etc.)
      LItemValue := LItem.Value;

      if LSeenValues.ContainsKey(LItemValue) then
      begin
        Result := False;
        SetResultMessage(Format('O campo %s não pode conter valores duplicados.', [AFieldName]));
        Break; // Otimização: para no primeiro duplicado encontrado.
      end
      else
      begin
        LSeenValues.Add(LItemValue, True);
      end;
    end;
  finally
    LSeenValues.Free;
    LJSONArray.Free;
  end;
end;

end.
