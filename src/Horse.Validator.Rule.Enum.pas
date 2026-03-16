unit Horse.Validator.Rule.Enum;

interface

uses
  System.SysUtils,
  System.TypInfo,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo corresponde a um dos membros de um tipo enumerado (Enum) específico.
  /// </summary>
  /// <remarks>
  ///   A validação é feita de forma case-insensitive contra os nomes dos membros do enum.
  ///   Exemplo de uso: <c>Rules.Enum(TypeInfo(TMyEnum))</c>
  /// </remarks>
  TRuleEnum = class(TRule)
  strict private
    FEnumTypeInfo: PTypeInfo;
  public
    /// <summary>
    ///   Cria uma nova instância da regra de validação de Enum.
    /// </summary>
    /// <param name="AEnumTypeInfo">As informações de tipo do Enum (ex: TypeInfo(TStatusEnum)).</param>
    constructor Create(const AEnumTypeInfo: PTypeInfo);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleEnum }

constructor TRuleEnum.Create(const AEnumTypeInfo: PTypeInfo);
begin
  inherited Create;
  // Garante que o tipo passado é realmente um enum para evitar erros em tempo de execução.
  if not Assigned(AEnumTypeInfo) or (AEnumTypeInfo^.Kind <> tkEnumeration) then
    raise Exception.Create('Um PTypeInfo de um tipo Enumerado válido deve ser fornecido.');
  FEnumTypeInfo := AEnumTypeInfo;
end;

function TRuleEnum.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LTypeData: PTypeData;
  I: Integer;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação falha por padrão, até que um membro correspondente seja encontrado.
  Result := False;
  LTypeData := GetTypeData(FEnumTypeInfo);

  // Itera por todos os valores ordinais do enum.
  if Assigned(LTypeData) then
  begin
    for I := LTypeData^.MinValue to LTypeData^.MaxValue do
    begin
      // Compara o valor do campo com o nome do membro do enum (case-insensitive).
      if SameText(LValue, GetEnumName(FEnumTypeInfo, I)) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  if not Result then
    SetResultMessage(Format('O valor selecionado para o campo %s não é válido.', [AFieldName]));
end;

end.
