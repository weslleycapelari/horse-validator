unit Horse.Validator.Exception;

interface

uses
  System.JSON,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Commons;

type
  /// <summary>Exceção customizada responsável por transportar os detalhes de falhas de validação.</summary>
  /// <remarks>Encapsula mensagens de erro, status HTTP e a lista detalhada de campos inválidos.</remarks>
  EHorseValidationException = class(Exception)
  strict private
    FError: string;
    FStatus: THTTPStatus;
    FType: TMessageType;
    FValidations: TDictionary<string, TList<string>>;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    /// <summary>Define a mensagem de erro principal da exceção.</summary>
    function Error(const AValue: string): EHorseValidationException; overload;

    /// <summary>Define o dicionário de validações (erros por campo).</summary>
    /// <remarks>A exceção assume a propriedade (ownership) do dicionário e o liberará ao ser destruída.</remarks>
    function Validations(const AValue: TDictionary<string, TList<string>>): EHorseValidationException; overload;

    /// <summary>Define o status HTTP a ser retornado (Padrão: 400 Bad Request).</summary>
    function Status(const AValue: THTTPStatus): EHorseValidationException; overload;

    /// <summary>Define o tipo da mensagem (para formatação de resposta customizada).</summary>
    function &Type(const AValue: TMessageType): EHorseValidationException; overload;

    /// <summary>Obtém a mensagem de erro principal.</summary>
    function Error: string; overload;

    /// <summary>Obtém o dicionário de validações.</summary>
    function Validations: TDictionary<string, TList<string>>; overload;

    /// <summary>Obtém o status HTTP.</summary>
    function Status: THTTPStatus; overload;

    /// <summary>Obtém o tipo da mensagem.</summary>
    function &Type: TMessageType; overload;

    /// <summary>Converte os dados da exceção para um objeto JSON formatado.</summary>
    function ToJSONObject: TJSONObject; virtual;

    /// <summary>Converte os dados da exceção para uma string JSON.</summary>
    function ToJSON: string; virtual;

    /// <summary>Factory para criar uma nova instância da exceção de forma fluente.</summary>
    class function New: EHorseValidationException;
  end;

implementation

{ EHorseValidationException }

constructor EHorseValidationException.Create;
begin
  inherited Create('');
  FStatus := THTTPStatus.BadRequest;
  FValidations := nil;
  FType := TMessageType.Default;
end;

destructor EHorseValidationException.Destroy;
var
  LList: TList<string>;
begin
  // Libera a memória do dicionário e de suas listas internas.
  if Assigned(FValidations) then
  begin
    for LList in FValidations.Values do
      LList.Free;
    FValidations.Free;
  end;
  inherited;
end;

function EHorseValidationException.Error(const AValue: string): EHorseValidationException;
begin
  Result := Self;
  FError := AValue;
  Self.Message := AValue;
end;

function EHorseValidationException.Error: string;
begin
  Result := FError;
end;

class function EHorseValidationException.New: EHorseValidationException;
begin
  Result := EHorseValidationException.Create;
end;

function EHorseValidationException.Status(const AValue: THTTPStatus): EHorseValidationException;
begin
  Result := Self;
  FStatus := AValue;
end;

function EHorseValidationException.Status: THTTPStatus;
begin
  Result := FStatus;
end;

function EHorseValidationException.ToJSON: string;
var
  LJSON: TJSONObject;
begin
  LJSON := ToJSONObject;
  try
    // Verifica a versão do compilador para usar o método correto de serialização.
    {$IF CompilerVersion > 27.0}
    Result := LJSON.ToJSON;
    {$ELSE}
    Result := LJSON.ToString;
    {$ENDIF}
  finally
    LJSON.Free;
  end;
end;

function EHorseValidationException.ToJSONObject: TJSONObject;
var
  LKey: string;
  LMessage: string;
  LMessagesJSONArray: TJSONArray;
  LValidationsJSON: TJSONObject;
begin
  Result := TJSONObject.Create;

  // Adiciona o tipo se for diferente do padrão.
  if FType <> TMessageType.Default then
    Result.AddPair('type', GetEnumName(TypeInfo(TMessageType), Integer(FType)));

  // Adiciona a mensagem de erro principal.
  if not FError.Trim.IsEmpty then
    Result.AddPair('error', FError);

  // Serializa o dicionário de validações para JSON.
  if Assigned(FValidations) and (FValidations.Count > 0) then
  begin
    LValidationsJSON := TJSONObject.Create;
    Result.AddPair('validations', LValidationsJSON);

    for LKey in FValidations.Keys do
    begin
      LMessagesJSONArray := TJSONArray.Create;
      LValidationsJSON.AddPair(LKey, LMessagesJSONArray);

      for LMessage in FValidations[LKey] do
        LMessagesJSONArray.Add(LMessage);
    end;
  end;
end;

function EHorseValidationException.&Type(const AValue: TMessageType): EHorseValidationException;
begin
  Result := Self;
  FType := AValue;
end;

function EHorseValidationException.&Type: TMessageType;
begin
  Result := FType;
end;

function EHorseValidationException.Validations(const AValue: TDictionary<string, TList<string>>): EHorseValidationException;
var
  LList: TList<string>;
begin
  Result := Self;
  // Se já existir um dicionário anterior, libera a memória para evitar vazamentos.
  if Assigned(FValidations) then
  begin
    for LList in FValidations.Values do
      LList.Free;
    FValidations.Free;
  end;
  // Assume a propriedade do novo dicionário.
  FValidations := AValue;
end;

function EHorseValidationException.Validations: TDictionary<string, TList<string>>;
begin
  Result := FValidations;
end;

end.
