unit Horse.Validator.Types;

interface

uses
  System.Rtti,
  System.SysUtils,
  Horse.Validator.DateUtils,
  Horse.Validator.Interfaces;

type
  /// <summary>Define o tipo de dado armazenado no argumento (Valor Literal ou Referência a Campo).</summary>
  TArgumentType = (atLiteral, atReference);

  /// <summary>
  ///   Estrutura genérica para gerenciar valores que podem ser fixos (Literais)
  ///   ou dinâmicos (Referências a outros campos da requisição).
  /// </summary>
  /// <typeparam name="T">O tipo do valor esperado (ex: Integer, TDateTime, string).</typeparam>
  TArgument<T> = record
  strict private
    FValue: T;
    FRefName: string;
    FType: TArgumentType;
  public
    /// <summary>Cria um argumento do tipo Literal.</summary>
    class function Literal(const AValue: T): TArgument<T>; static;

    /// <summary>Cria um argumento do tipo Referência.</summary>
    class function Reference(const ARefName: string): TArgument<T>; static;

    /// <summary>
    ///   Permite a atribuição implícita de um valor do tipo T para TArgument.
    ///   Ex: MyArg := 10;
    /// </summary>
    class operator Implicit(const AValue: T): TArgument<T>;

    /// <summary>
    ///   Obtém o valor final. Se for referência, busca no provider e converte.
    ///   Se for literal, retorna o valor armazenado.
    /// </summary>
    /// <exception cref="EInvalidCast">Levantada se a conversão do valor da referência falhar.</exception>
    function GetValue(const AProvider: TValueProvider; const ACurrentPath: string = ''): T;

    /// <summary>Obtém o tipo do argumento (atLiteral ou atReference).</summary>
    property &Type: TArgumentType read FType;

    /// <summary>Obtém o nome do campo de referência (vazio se for literal).</summary>
    property RefName: string read FRefName;
  end;

implementation

{ TArgument<T> }

function TArgument<T>.GetValue(const AProvider: TValueProvider; const ACurrentPath: string): T;
var
  LStrValue: string;
  LValue: TValue;
  LTargetPath: string;
  LLastDot: Integer;
  LTypeName: string;
  LDateTime: TDateTime;
  LSeparator: string;
begin
  // Se for um valor literal, retorna diretamente sem processamento.
  if FType = atLiteral then
    Exit(FValue);

  LTargetPath := FRefName;
  if (Pos('.', FRefName) = 0) and (not ACurrentPath.IsEmpty) then
  begin
    // É uma referência relativa dentro de um contexto.
    LLastDot := ACurrentPath.LastDelimiter('.');
    if LLastDot > 0 then
      // Constrói o caminho absoluto para o campo irmão
      LTargetPath := ACurrentPath.Substring(0, LLastDot) + '.' + FRefName;
  end;

  LSeparator := FormatSettings.DecimalSeparator;
  // Se for referência, obtém o valor como string através do provider.
  LStrValue := AProvider(LTargetPath);

  try
    LTypeName := TRttiContext.Create.GetType(TypeInfo(T)).QualifiedName;
    if LTypeName.Contains('TDateTime') and (IsDateTime(LStrValue, LDateTime)) then
      LValue := TValue.From(LDateTime)
    else if LTypeName.Contains('Double') then
      LValue := TValue.From(LStrValue.Replace(',', LSeparator).Replace('.', LSeparator))
    else
      // Utiliza RTTI para converter a string obtida para o tipo T genérico.
      // TValue.From cria um container para a string.
      LValue := TValue.From(LStrValue);

    // AsType tenta converter o valor interno para o tipo solicitado T.
    // Isso lida automaticamente com conversões comuns (String -> Integer, String -> Date, etc).
    Result := LValue.AsType<T>;
  except
    on E: Exception do
      raise EInvalidCast.Create(Format('Erro ao converter o valor do campo de referência "%s" ("%s") para o tipo esperado: %s',
        [LTargetPath, LStrValue, E.Message]));
  end;
end;

class operator TArgument<T>.Implicit(const AValue: T): TArgument<T>;
begin
  Result := TArgument<T>.Literal(AValue);
end;

class function TArgument<T>.Literal(const AValue: T): TArgument<T>;
begin
  Result.FValue := AValue;
  Result.FRefName := '';
  Result.FType := atLiteral;
end;

class function TArgument<T>.Reference(const ARefName: string): TArgument<T>;
begin
  // Nota: O valor de FValue fica indefinido/default, pois não será usado.
  Result.FValue := Default(T);
  Result.FRefName := ARefName;
  Result.FType := atReference;
end;

end.
