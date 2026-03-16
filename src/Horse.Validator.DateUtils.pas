unit Horse.Validator.DateUtils;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Classes;

type
  TDateTimeFormat = (
    dtfISO8601,
    dtfLocale,
    dtfCustomDate,
    dtfTimeOnly,
    dtfUnknown
  );

  TDateTimeParseResult = record
    Success: Boolean;
    Value: TDateTime;
    DetectedFormat: TDateTimeFormat;
    ErrorMessage: string;
    class function CreateSuccess(const AValue: TDateTime; const AFormat: TDateTimeFormat): TDateTimeParseResult; static;
    class function CreateFailure(const AError: string): TDateTimeParseResult; static;
  end;

  /// <summary>
  /// Utilitário de alta performance para parsing e validação de datas e horas.
  /// Thread-safe, otimizado para APIs, logs e sistemas distribuídos.
  /// </summary>
  TDateHelper = class sealed
  private
    class var FBaseFormatSettings: TFormatSettings;
    class var FInitialized: Boolean;

    class constructor Create;

    type
      TStringContent = record
        CleanText: string;
        HasDateSep: Boolean;
        HasTimeSep: Boolean;
        HasISOHint: Boolean;
        HasAlpha: Boolean;
        Length: Integer;
        IsEmpty: Boolean;
        
        class function Empty: TStringContent; static;
      end;

    // Análise + Sanitização (single-pass otimizado)
    class function AnalyzeAndSanitize(const AText: string): TStringContent; static;

    // Heurísticas rápidas
    class function LooksLikeISO8601(const S: string): Boolean; static; inline;
    class function IsValidRange(const AValue: TDateTime): Boolean; static; inline;
    class function QuickReject(const AInfo: TStringContent): Boolean; static; inline;

    // Parsers especializados
    class function TryParseISO8601(const AText: string; out AValue: TDateTime): Boolean; static;
    class function TryParseLocale(const AText: string; out AValue: TDateTime): Boolean; static;
    class function TryParseCustom(const AInfo: TStringContent; out AValue: TDateTime): Boolean; static;
    class function TryParseTimeOnly(const AText: string; out AValue: TDateTime): Boolean; static;
    class function TryParseNumericDate(const AText: string; out AValue: TDateTime): Boolean; static;

  public
    class var MinDate: TDateTime;
    class var MaxDate: TDateTime;

    /// <summary>
    /// Verifica se o texto representa uma data/hora válida
    /// </summary>
    class function IsDateTime(const AText: string): Boolean; overload; static;
    
    /// <summary>
    /// Verifica e retorna o valor parseado se válido
    /// </summary>
    class function IsDateTime(const AText: string; out AParsedValue: TDateTime): Boolean; overload; static;
    
    /// <summary>
    /// Parse com informações detalhadas sobre o resultado
    /// </summary>
    class function TryParse(const AText: string; out AResult: TDateTimeParseResult): Boolean; static;

    /// <summary>
    /// Formata data/hora para ISO8601 (formato universal para APIs)
    /// </summary>
    class function ToISO8601(const AValue: TDateTime; AIncludeMilliseconds: Boolean = False): string; static;
    
    /// <summary>
    /// Parse ou retorna valor padrão em caso de falha
    /// </summary>
    class function ParseOrDefault(const AText: string; const ADefault: TDateTime = 0): TDateTime; static; inline;
  end;

  // Wrappers de compatibilidade
  function IsDateTime(const AText: string): Boolean; overload; inline;
  function IsDateTime(const AText: string; out AParsedValue: TDateTime): Boolean; overload; inline;

implementation

uses
  System.Character;

const
  // Formatos customizados organizados por separador (menor overhead)
  DATE_FMT_SLASH: TArray<string> = ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy/MM/dd'];
  DATE_FMT_DASH : TArray<string> = ['yyyy-MM-dd', 'dd-MM-yyyy', 'MM-dd-yyyy'];
  DATE_FMT_DOT  : TArray<string> = ['dd.MM.yyyy', 'yyyy.MM.dd'];

  TIME_FORMATS: array[0..3] of string = (
    'HH:mm:ss',
    'HH:mm',
    'HH:mm:ss.zzz',
    'hh:mm:ss tt'
  );

{ Wrappers globais }

function IsDateTime(const AText: string): Boolean;
begin
  Result := TDateHelper.IsDateTime(AText);
end;

function IsDateTime(const AText: string; out AParsedValue: TDateTime): Boolean;
begin
  Result := TDateHelper.IsDateTime(AText, AParsedValue);
end;

{ TDateTimeParseResult }

class function TDateTimeParseResult.CreateSuccess(
  const AValue: TDateTime;
  const AFormat: TDateTimeFormat): TDateTimeParseResult;
begin
  Result.Success := True;
  Result.Value := AValue;
  Result.DetectedFormat := AFormat;
  Result.ErrorMessage := '';
end;

class function TDateTimeParseResult.CreateFailure(
  const AError: string): TDateTimeParseResult;
begin
  Result.Success := False;
  Result.Value := 0;
  Result.DetectedFormat := dtfUnknown;
  Result.ErrorMessage := AError;
end;

{ TDateHelper.TStringContent }

class function TDateHelper.TStringContent.Empty: TStringContent;
begin
  Result.CleanText := '';
  Result.HasDateSep := False;
  Result.HasTimeSep := False;
  Result.HasISOHint := False;
  Result.HasAlpha := False;
  Result.Length := 0;
  Result.IsEmpty := True;
end;

{ TDateHelper }

class constructor TDateHelper.Create;
begin
  FBaseFormatSettings := TFormatSettings.Invariant;
  FBaseFormatSettings.DateSeparator := '-';
  FBaseFormatSettings.TimeSeparator := ':';
  FBaseFormatSettings.DecimalSeparator := '.';

  MinDate := EncodeDate(1900, 1, 1);
  MaxDate := EncodeDate(2099, 12, 31);
  
  FInitialized := True;
end;

class function TDateHelper.AnalyzeAndSanitize(const AText: string): TStringContent;
var
  I, StartPos, EndPos, Len: Integer;
  C: Char;
  InQuote: Boolean;
  SB: TStringBuilder;
begin
  Len := Length(AText);
  
  if Len = 0 then
    Exit(TStringContent.Empty);

  // Quick scan para encontrar início e fim úteis
  StartPos := 1;
  EndPos := Len;
  
  // Skip leading whitespace/quotes
  while (StartPos <= Len) and CharInSet(AText[StartPos], [' ', #9, #13, #10, '"', '''']) do
    Inc(StartPos);
    
  // Skip trailing whitespace/quotes
  while (EndPos >= StartPos) and CharInSet(AText[EndPos], [' ', #9, #13, #10, '"', '''']) do
    Dec(EndPos);
  
  Len := EndPos - StartPos + 1;
  
  if Len <= 0 then
    Exit(TStringContent.Empty);

  // Inicializa resultado
  Result.IsEmpty := False;
  Result.Length := Len;
  Result.HasDateSep := False;
  Result.HasTimeSep := False;
  Result.HasISOHint := False;
  Result.HasAlpha := False;

  // Single-pass analysis
  SB := TStringBuilder.Create(Len);
  try
    InQuote := False;
    
    for I := StartPos to EndPos do
    begin
      C := AText[I];
      
      // Detecta quotes internas
      if CharInSet(C, ['"', '''']) then
      begin
        InQuote := not InQuote;
        Continue;
      end;
      
      if not InQuote then
      begin
        case C of
          '/', '.':
            Result.HasDateSep := True;
            
          '-':
            begin
              Result.HasDateSep := True;
              // Detecta padrão ISO: "yyyy-MM-dd"
              if (I > StartPos) and (I < EndPos) then
                if CharInSet(AText[I-1], ['0'..'9']) and CharInSet(AText[I+1], ['0'..'9']) then
                  Result.HasISOHint := True;
            end;
            
          ':':
            Result.HasTimeSep := True;
            
          'A'..'Z', 'a'..'z':
            if CharInSet(C, ['T', 'Z']) then
              Result.HasISOHint := True
            else if not CharInSet(C, ['A', 'M', 'P']) then // Exceções ISO/AM/PM
              Result.HasAlpha := True;
        end;
      end;
      
      SB.Append(C);
    end;
    
    Result.CleanText := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TDateHelper.LooksLikeISO8601(const S: string): Boolean;
var
  Len: Integer;
begin
  Len := Length(S);
  
  // Quick pattern check: mínimo "yyyy-MM-dd" = 10 chars
  // ou "yyyy-MM-ddTHH:mm:ss" = 19 chars
  if (Len < 10) or (Len > 35) then
    Exit(False);
  
  // Verifica padrão inicial: "dddd-dd"
  Result := (Len >= 10) and
            CharInSet(S[1], ['1', '2']) and  // Anos 1xxx ou 2xxx
            CharInSet(S[5], ['-', '/']) and
            CharInSet(S[8], ['-', '/']);
end;

class function TDateHelper.IsValidRange(const AValue: TDateTime): Boolean;
begin
  Result := (AValue >= MinDate) and (AValue <= MaxDate);
end;

class function TDateHelper.QuickReject(const AInfo: TStringContent): Boolean;
begin
  // Rejeita rapidamente casos óbvios
  Result := AInfo.IsEmpty or 
            (AInfo.Length < 5) or  // Mínimo "hh:mm"
            (AInfo.Length > 40) or // Máximo razoável
            (AInfo.HasAlpha and not AInfo.HasISOHint); // Letras estranhas
end;

class function TDateHelper.IsDateTime(const AText: string): Boolean;
var
  LDummy: TDateTime;
begin
  Result := IsDateTime(AText, LDummy);
end;

class function TDateHelper.IsDateTime(const AText: string; out AParsedValue: TDateTime): Boolean;
var
  LInfo: TStringContent;
begin
  AParsedValue := 0;
  LInfo := AnalyzeAndSanitize(AText);

  if QuickReject(LInfo) then
    Exit(False);

  // 1. ISO8601 - prioridade máxima (APIs, JSON, logs modernos)
  if (LInfo.HasISOHint or LooksLikeISO8601(LInfo.CleanText)) and 
     TryParseISO8601(LInfo.CleanText, AParsedValue) then
    Exit(IsValidRange(AParsedValue));

  // 2. Time-only - comum em logs e horários
  if LInfo.HasTimeSep and not LInfo.HasDateSep then
    Exit(TryParseTimeOnly(LInfo.CleanText, AParsedValue));

  // 3. Numérico puro (yyyyMMdd, yyyyMMddHHmmss)
  if not (LInfo.HasDateSep or LInfo.HasTimeSep or LInfo.HasAlpha) then
    if TryParseNumericDate(LInfo.CleanText, AParsedValue) then
      Exit(IsValidRange(AParsedValue));

  // 4. Locale do sistema
  if TryParseLocale(LInfo.CleanText, AParsedValue) then
    Exit(IsValidRange(AParsedValue));

  // 5. Formatos customizados (fallback)
  Result := TryParseCustom(LInfo, AParsedValue) and IsValidRange(AParsedValue);
end;

class function TDateHelper.TryParse(const AText: string; out AResult: TDateTimeParseResult): Boolean;
var
  LInfo: TStringContent;
  LValue: TDateTime;
begin
  LInfo := AnalyzeAndSanitize(AText);

  if QuickReject(LInfo) then
  begin
    AResult := TDateTimeParseResult.CreateFailure('Input inválido ou vazio');
    Exit(False);
  end;

  // ISO8601
  if (LInfo.HasISOHint or LooksLikeISO8601(LInfo.CleanText)) and 
     TryParseISO8601(LInfo.CleanText, LValue) and IsValidRange(LValue) then
  begin
    AResult := TDateTimeParseResult.CreateSuccess(LValue, dtfISO8601);
    Exit(True);
  end;

  // Time-only
  if LInfo.HasTimeSep and not LInfo.HasDateSep then
  begin
    if TryParseTimeOnly(LInfo.CleanText, LValue) then
    begin
      AResult := TDateTimeParseResult.CreateSuccess(LValue, dtfTimeOnly);
      Exit(True);
    end;
  end;

  // Numérico
  if not (LInfo.HasDateSep or LInfo.HasTimeSep or LInfo.HasAlpha) then
  begin
    if TryParseNumericDate(LInfo.CleanText, LValue) and IsValidRange(LValue) then
    begin
      AResult := TDateTimeParseResult.CreateSuccess(LValue, dtfCustomDate);
      Exit(True);
    end;
  end;

  // Locale
  if TryParseLocale(LInfo.CleanText, LValue) and IsValidRange(LValue) then
  begin
    AResult := TDateTimeParseResult.CreateSuccess(LValue, dtfLocale);
    Exit(True);
  end;

  // Custom
  if TryParseCustom(LInfo, LValue) and IsValidRange(LValue) then
  begin
    AResult := TDateTimeParseResult.CreateSuccess(LValue, dtfCustomDate);
    Exit(True);
  end;

  AResult := TDateTimeParseResult.CreateFailure('Formato não reconhecido: ' + LInfo.CleanText);
  Result := False;
end;

class function TDateHelper.ParseOrDefault(const AText: string; const ADefault: TDateTime): TDateTime;
var
  LValue: TDateTime;
begin
  if IsDateTime(AText, LValue) then
    Result := LValue
  else
    Result := ADefault;
end;

class function TDateHelper.TryParseISO8601(const AText: string; out AValue: TDateTime): Boolean;
begin
  try
    {$IF CompilerVersion >= 33.0} // Delphi 10.3 Rio+
    Result := System.DateUtils.TryISO8601ToDate(AText, AValue, True);
    {$ELSE}
    AValue := System.DateUtils.ISO8601ToDate(AText, True);
    Result := True;
    {$ENDIF}
  except
    AValue := 0;
    Result := False;
  end;
end;

class function TDateHelper.TryParseLocale(const AText: string; out AValue: TDateTime): Boolean;
begin
  // Multi-tentativa: DateTime > Date > Time
  Result := TryStrToDateTime(AText, AValue);
  if not Result then
  begin
    Result := TryStrToDate(AText, AValue);
    if not Result then
      Result := TryStrToTime(AText, AValue);
  end;
end;

class function TDateHelper.TryParseTimeOnly(const AText: string; out AValue: TDateTime): Boolean;
var
  LFS: TFormatSettings;
  LFormat: string;
begin
  LFS := FBaseFormatSettings;
  
  for LFormat in TIME_FORMATS do
  begin
    LFS.ShortTimeFormat := LFormat;
    LFS.LongTimeFormat := LFormat;
    
    if TryStrToTime(AText, AValue, LFS) then
      Exit(True);
  end;

  Result := False;
end;

class function TDateHelper.TryParseNumericDate(const AText: string; out AValue: TDateTime): Boolean;
var
  Len: Integer;
  Y, M, D, H, Mi, S: Integer;
begin
  Result := False;
  Len := Length(AText);
  
  try
    case Len of
      8: // yyyyMMdd
        begin
          Y := StrToInt(Copy(AText, 1, 4));
          M := StrToInt(Copy(AText, 5, 2));
          D := StrToInt(Copy(AText, 7, 2));
          if TryEncodeDate(Y, M, D, AValue) then
            Result := True;
        end;
        
      14: // yyyyMMddHHmmss
        begin
          Y := StrToInt(Copy(AText, 1, 4));
          M := StrToInt(Copy(AText, 5, 2));
          D := StrToInt(Copy(AText, 7, 2));
          H := StrToInt(Copy(AText, 9, 2));
          Mi := StrToInt(Copy(AText, 11, 2));
          S := StrToInt(Copy(AText, 13, 2));
          if TryEncodeDateTime(Y, M, D, H, Mi, S, 0, AValue) then
            Result := True;
        end;
    end;
  except
    AValue := 0;
    Result := False;
  end;
end;

class function TDateHelper.TryParseCustom(const AInfo: TStringContent; out AValue: TDateTime): Boolean;
var
  LFS: TFormatSettings;
  LDateFormat, LTimeFormat: string;
  LFormats: TArray<string>;
  I: Integer;
begin
  LFS := FBaseFormatSettings;

  // Seleciona array de formatos baseado no separador
  if Pos('/', AInfo.CleanText) > 0 then
  begin
    LFS.DateSeparator := '/';
    LFormats := DATE_FMT_SLASH;
  end
  else if Pos('.', AInfo.CleanText) > 0 then
  begin
    LFS.DateSeparator := '.';
    LFormats := DATE_FMT_DOT;
  end
  else
  begin
    LFS.DateSeparator := '-';
    LFormats := DATE_FMT_DASH;
  end;

  // Tenta cada formato de data
  for I := Low(LFormats) to High(LFormats) do
  begin
    LDateFormat := LFormats[I];
    LFS.ShortDateFormat := LDateFormat;
    LFS.LongDateFormat := LDateFormat;

    // Se não tem hora, tenta só data
    if not AInfo.HasTimeSep then
    begin
      if TryStrToDate(AInfo.CleanText, AValue, LFS) then
        Exit(True);
    end
    else
    begin
      // Se tem hora, tenta cada combinação data+hora
      for LTimeFormat in TIME_FORMATS do
      begin
        LFS.ShortTimeFormat := LTimeFormat;
        LFS.LongTimeFormat := LTimeFormat;
        
        if TryStrToDateTime(AInfo.CleanText, AValue, LFS) then
          Exit(True);
      end;
    end;
  end;

  Result := False;
end;

class function TDateHelper.ToISO8601(const AValue: TDateTime; AIncludeMilliseconds: Boolean): string;
begin
  Result := DateToISO8601(AValue, AIncludeMilliseconds);
end;

end.