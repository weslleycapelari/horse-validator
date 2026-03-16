unit Horse.Validator.Rule.DateFormat;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo corresponde estritamente a um formato de data/hora específico.
  /// </summary>
  /// <remarks>
  ///   Esta validação garante que a string de entrada corresponda ao padrão visual definido.
  ///   Exemplo: Se o formato for 'YYYY-MM-DD', '2025-05-01' é válido, mas '2025-5-1' ou '01/05/2025' falham.
  /// </remarks>
  TRuleDateFormat = class(TRule)
  strict private
    FFormat: string;
  public
    /// <summary>
    ///   Cria uma nova instância da regra 'DateFormat'.
    /// </summary>
    /// <param name="AFormat">O formato de data/hora esperado (ex: 'dd/mm/yyyy', 'yyyy-mm-dd hh:nn:ss').</param>
    constructor Create(const AFormat: string);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleDateFormat }

constructor TRuleDateFormat.Create(const AFormat: string);
begin
  inherited Create;
  FFormat := AFormat;
end;

function TRuleDateFormat.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LInputDateTime: TDateTime;
  LFormatSettings: TFormatSettings;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Cria configurações de formato locais para isolar a validação das configurações globais do sistema.
  LFormatSettings := TFormatSettings.Create;
  LFormatSettings.ShortDateFormat := FFormat;
  // Define LongDateFormat também para garantir consistência se a função interna usar um ou outro.
  LFormatSettings.LongDateFormat := FFormat;

  // Normaliza separadores para evitar falsos positivos se o sistema tiver defaults diferentes.
  // O Delphi geralmente é flexível com separadores '/', '-', '.', mas definimos defaults sensatos.
  LFormatSettings.DateSeparator := '/';
  LFormatSettings.TimeSeparator := ':';

  // Passo 1: Verifica se a string pode ser convertida logicamente em uma data válida usando o formato.
  if not TryStrToDateTime(LValue, LInputDateTime, LFormatSettings) then
  begin
    SetResultMessage(Format('O campo %s não corresponde ao formato %s.', [AFieldName, FFormat]));
    Exit(False);
  end;

  // Passo 2: Validação Estrita (Round-trip).
  // Formata a data obtida de volta para string usando o formato exigido e compara com a entrada original.
  // Isso previne formatos ambíguos ou incompletos (ex: ano com 2 dígitos quando se espera 4).
  // Usamos SameText para ignorar diferenças de caixa em nomes de meses (se houver).
  Result := SameText(FormatDateTime(FFormat, LInputDateTime, LFormatSettings), LValue);

  if not Result then
    SetResultMessage(Format('O campo %s não corresponde estritamente ao formato %s.', [AFieldName, FFormat]));
end;

end.
