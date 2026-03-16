unit Horse.Validator.Builder;

interface

uses
  System.TypInfo,
  System.SysUtils,
  System.Variants,
  Horse.Validator.Interfaces,
  Horse.Validator.Types;

type
  /// <summary>Factory para instanciar regras de validação de forma fluente e expressiva.</summary>
  TValidationBuilder = class
  public
    {$REGION 'Boolean'}
    /// <summary>Valida se o valor é "verdadeiro" ('yes', 'on', '1', 'true').</summary>
    class function Accepted: IRule;
    /// <summary>Valida se o valor representa um booleano ('true', 'false', '1', '0').</summary>
    class function Boolean: IRule;
    /// <summary>Valida se o valor é "falso" ('no', 'off', '0', 'false').</summary>
    class function Declined: IRule;
    {$ENDREGION}

    {$REGION 'String'}
    /// <summary>Valida se é uma URL ativa e com DNS válido.</summary>
    class function ActiveUrl: IRule;
    /// <summary>Valida se contém apenas letras.</summary>
    class function Alpha: IRule;
    /// <summary>Valida se contém letras, números, hifens e underscores.</summary>
    class function AlphaDash: IRule;
    /// <summary>Valida se contém apenas letras e números.</summary>
    class function AlphaNumeric: IRule;
    /// <summary>Valida se contém apenas caracteres ASCII.</summary>
    class function Ascii: IRule;
    /// <summary>Valida se o valor é diferente de outro campo.</summary>
    class function Different(const AOtherFieldName: string): IRule; overload;
    /// <summary>Valida se o valor é diferente de um valor literal específico.</summary>
    class function Different(const ALiteralValue: Variant): IRule; overload;
    /// <summary>Valida se não começa com as substrings fornecidas.</summary>
    class function DoesntStartWith(const ASubstrings: array of string): IRule;
    /// <summary>Valida se não termina com as substrings fornecidas.</summary>
    class function DoesntEndWith(const ASubstrings: array of string): IRule;
    /// <summary>Valida formato de e-mail e opcionalmente checa DNS.</summary>
    class function Email(const ACheckDNS: Boolean = False): IRule;
    /// <summary>Valida se termina com uma das substrings fornecidas.</summary>
    class function EndsWith(const ASubstrings: array of string): IRule;
    /// <summary>Valida se o valor corresponde a um membro do Enum fornecido.</summary>
    class function Enum(const AEnumTypeInfo: PTypeInfo): IRule;
    /// <summary>Valida formato de cor Hexadecimal.</summary>
    class function HexColor: IRule;
    /// <summary>Valida se o valor está contido na lista fornecida.</summary>
    class function &In(const AValues: array of Variant): IRule;
    /// <summary>Valida formato de IP (v4 ou v6).</summary>
    class function IpAddress: IRule;
    /// <summary>Valida se é uma string JSON válida.</summary>
    class function JSON: IRule;
    /// <summary>Valida se todos os caracteres são minúsculos.</summary>
    class function Lowercase: IRule;
    /// <summary>Valida formato de endereço MAC.</summary>
    class function MACAddress: IRule;
    /// <summary>Valida comprimento máximo (string) ou valor máximo (número).</summary>
    class function Max(const AValue: Double): IRule; overload;
    class function Max(const AFieldName: string): IRule; overload;
    /// <summary>Valida comprimento mínimo (string) ou valor mínimo (número).</summary>
    class function Min(const AValue: Double): IRule; overload;
    class function Min(const AFieldName: string): IRule; overload;
    /// <summary>Valida se o valor NÃO está na lista fornecida.</summary>
    class function NotIn(const AValues: array of Variant): IRule;
    /// <summary>Valida via Regex.</summary>
    class function RegularExpression(const APattern: string): IRule;
    /// <summary>Valida que NÃO corresponde ao Regex.</summary>
    class function NotRegularExpression(const APattern: string): IRule;
    /// <summary>Valida se é igual a outro campo.</summary>
    class function Same(const AOtherFieldName: string): IRule; overload;
    /// <summary>Valida se é igual a um valor literal.</summary>
    class function Same(const ALiteralValue: Variant): IRule; overload;
    /// <summary>Valida tamanho exato (comprimento string ou valor numérico).</summary>
    class function Size(const AValue: Double): IRule; overload;
    class function Size(const AFieldName: string): IRule; overload;
    /// <summary>Valida se começa com uma das substrings.</summary>
    class function StartsWith(const ASubstrings: array of string): IRule;
    /// <summary>Valida se é uma string (implícito, usado para Required).</summary>
    class function &String: IRule;
    /// <summary>Valida se todos os caracteres são maiúsculos.</summary>
    class function Uppercase: IRule;
    /// <summary>Valida formato de URL.</summary>
    class function URL: IRule;
    /// <summary>Valida formato ULID.</summary>
    class function ULID: IRule;
    /// <summary>Valida formato UUID.</summary>
    class function UUID: IRule;
    {$ENDREGION}

    {$REGION 'Number'}
    /// <summary>Valida intervalo inclusivo.</summary>
    class function Between(const AMin, AMax: Double): IRule; overload;
    class function Between(const AFieldMin, AFieldMax: string): IRule; overload;
    /// <summary>Valida casas decimais exatas.</summary>
    class function Decimal(const ADecimalPlaces: Integer): IRule;
    /// <summary>Valida quantidade exata de dígitos.</summary>
    class function Digits(const ALength: Integer): IRule;
    /// <summary>Valida quantidade de dígitos entre min e max.</summary>
    class function DigitsBetween(const AMinLength, AMaxLength: Integer): IRule;
    /// <summary>Valida se é maior que valor ou campo.</summary>
    class function GreaterThan(const AValue: Double): IRule; overload;
    class function GreaterThan(const AFieldName: string): IRule; overload;
    /// <summary>Valida se é maior ou igual a valor ou campo.</summary>
    class function GreaterThanOrEqual(const AValue: Double): IRule; overload;
    class function GreaterThanOrEqual(const AFieldName: string): IRule; overload;
    /// <summary>Valida se é inteiro.</summary>
    class function Integer: IRule;
    /// <summary>Valida se é menor que valor ou campo.</summary>
    class function LessThan(const AValue: Double): IRule; overload;
    class function LessThan(const AFieldName: string): IRule; overload;
    /// <summary>Valida se é menor ou igual a valor ou campo.</summary>
    class function LessThanOrEqual(const AValue: Double): IRule; overload;
    class function LessThanOrEqual(const AFieldName: string): IRule; overload;
    /// <summary>Valida máximo de dígitos.</summary>
    class function MaxDigits(const AMaxLength: Integer): IRule;
    /// <summary>Valida mínimo de dígitos.</summary>
    class function MinDigits(const AMinLength: Integer): IRule;
    /// <summary>Valida se é múltiplo de.</summary>
    class function MultipleOf(const AValue: Double): IRule;
    /// <summary>Valida se é numérico.</summary>
    class function Numeric: IRule;
    {$ENDREGION}

    {$REGION 'Date'}
    /// <summary>Valida se data é posterior a valor ou campo.</summary>
    class function After(const ADateTime: TDateTime): IRule; overload;
    class function After(const AFieldName: string): IRule; overload;
    /// <summary>Valida se data é posterior ou igual a valor ou campo.</summary>
    class function AfterOrEqual(const ADateTime: TDateTime): IRule; overload;
    class function AfterOrEqual(const AFieldName: string): IRule; overload;
    /// <summary>Valida se data é anterior a valor ou campo.</summary>
    class function Before(const ADateTime: TDateTime): IRule; overload;
    class function Before(const AFieldName: string): IRule; overload;
    /// <summary>Valida se data é anterior ou igual a valor ou campo.</summary>
    class function BeforeOrEqual(const ADateTime: TDateTime): IRule; overload;
    class function BeforeOrEqual(const AFieldName: string): IRule; overload;
    /// <summary>Valida formato de data.</summary>
    class function Date: IRule;
    /// <summary>Valida igualdade de datas.</summary>
    class function DateEquals(const ADateTime: TDateTime): IRule; overload;
    class function DateEquals(const AFieldName: string): IRule; overload;
    /// <summary>Valida formato específico de data.</summary>
    class function DateFormat(const AFormat: string): IRule;
    /// <summary>Valida fuso horário IANA.</summary>
    class function Timezone: IRule;
    {$ENDREGION}

    {$REGION 'Database'}
    /// <summary>Valida existência em tabela.</summary>
    class function Exists(const ATableName, AColumnName: string; const ACallback: TExistsCallback): IRule;
    /// <summary>Valida unicidade em tabela.</summary>
    class function Unique(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string = ''): IRule;
    /// <summary>Valida confirmação de campo (ex: senha).</summary>
    class function Confirmed: IRule;
    /// <summary>Valida senha atual via callback.</summary>
    class function CurrentPassword(const ACallback: TCheckPasswordCallback): IRule;
    {$ENDREGION}

    {$REGION 'JSON Structure'}
    /// <summary>Valida se o valor do campo é um objeto JSON válido (iniciando com '{').</summary>
    class function IsObject: IRule;
    /// <summary>Valida se o valor do campo é um array JSON válido (iniciando com '[').</summary>
    class function IsArray: IRule;
    {$ENDREGION}

    {$REGION 'Array'}
    /// <summary>Valida se todos os valores dentro de um array são únicos.</summary>
    class function Distinct: IRule;
    /// <summary>Valida se um array contém no mínimo um número especificado de itens.</summary>
    class function MinCount(const ACount: Integer): IRule;
    /// <summary>Valida se um array contém no máximo um número especificado de itens.</summary>
    class function MaxCount(const ACount: Integer): IRule;
    {$ENDREGION}

    {$REGION 'File'}
    /// <summary>Valida se o campo corresponde a um arquivo enviado na requisição.</summary>
    class function &File: IRule;
    /// <summary>Valida o MIME Type de um arquivo enviado.</summary>
    class function MimeTypes(const ATypes: array of string): IRule;
    /// <summary>Valida a extensão de um arquivo enviado.</summary>
    class function Extensions(const AExtensions: array of string): IRule;
    {$ENDREGION}

    {$REGION 'Localization (Brazil)'}
    /// <summary>Valida se o campo contém um CPF brasileiro válido.</summary>
    class function CPF: IRule;
    /// <summary>Valida se o campo contém um CNPJ brasileiro válido.</summary>
    class function CNPJ: IRule;
    {$ENDREGION}

    {$REGION 'Utility'}
    /// <summary>Valida que o campo é obrigatório.</summary>
    class function Required: IRule;

    /// <summary>Valida que o campo é obrigatório caso a regra tenha sido satisfeita.</summary>
    class function RequiredIf(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule): IRule;

    /// <summary>Valida que o campo não deve estar presente na requisição.</summary>
    class function Prohibited: IRule;

    /// <summary>
    ///   Aplica um conjunto de regras apenas se a condição for verdadeira.
    ///   Permite validação condicional ("Meta Regra").
    /// </summary>
    class function When(const ACondition: TFunc<Boolean>; const ARules: array of IRule): IRule;
    {$ENDREGION}
  end;

implementation

uses
  Horse.Validator.Rule.Accepted,
  Horse.Validator.Rule.Boolean,
  Horse.Validator.Rule.Declined,
  Horse.Validator.Rule.ActiveUrl,
  Horse.Validator.Rule.Alpha,
  Horse.Validator.Rule.AlphaDash,
  Horse.Validator.Rule.AlphaNumeric,
  Horse.Validator.Rule.Ascii,
  Horse.Validator.Rule.Confirmed,
  Horse.Validator.Rule.CurrentPassword,
  Horse.Validator.Rule.Different,
  Horse.Validator.Rule.DoesntStartWith,
  Horse.Validator.Rule.DoesntEndWith,
  Horse.Validator.Rule.Email,
  Horse.Validator.Rule.EndsWith,
  Horse.Validator.Rule.Enum,
  Horse.Validator.Rule.HexColor,
  Horse.Validator.Rule.uIn,
  Horse.Validator.Rule.IpAddress,
  Horse.Validator.Rule.JSON,
  Horse.Validator.Rule.Lowercase,
  Horse.Validator.Rule.MACAddress,
  Horse.Validator.Rule.Max,
  Horse.Validator.Rule.Min,
  Horse.Validator.Rule.NotIn,
  Horse.Validator.Rule.RegularExpression,
  Horse.Validator.Rule.NotRegularExpression,
  Horse.Validator.Rule.Same,
  Horse.Validator.Rule.Size,
  Horse.Validator.Rule.StartsWith,
  Horse.Validator.Rule.uString,
  Horse.Validator.Rule.Uppercase,
  Horse.Validator.Rule.URL,
  Horse.Validator.Rule.ULID,
  Horse.Validator.Rule.UUID,
  Horse.Validator.Rule.Between,
  Horse.Validator.Rule.Decimal,
  Horse.Validator.Rule.Digits,
  Horse.Validator.Rule.DigitsBetween,
  Horse.Validator.Rule.GreaterThan,
  Horse.Validator.Rule.GreaterThanOrEqual,
  Horse.Validator.Rule.Integer,
  Horse.Validator.Rule.LessThan,
  Horse.Validator.Rule.LessThanOrEqual,
  Horse.Validator.Rule.MaxDigits,
  Horse.Validator.Rule.MinDigits,
  Horse.Validator.Rule.MultipleOf,
  Horse.Validator.Rule.Numeric,
  Horse.Validator.Rule.After,
  Horse.Validator.Rule.AfterOrEqual,
  Horse.Validator.Rule.Before,
  Horse.Validator.Rule.BeforeOrEqual,
  Horse.Validator.Rule.Date,
  Horse.Validator.Rule.DateEquals,
  Horse.Validator.Rule.DateFormat,
  Horse.Validator.Rule.Timezone,
  Horse.Validator.Rule.Exists,
  Horse.Validator.Rule.Unique,
  Horse.Validator.Rule.Required,
  Horse.Validator.Rule.IfVal,
  Horse.Validator.Rule.IsObject,
  Horse.Validator.Rule.IsArray,
  Horse.Validator.Rule.CPF,
  Horse.Validator.Rule.CNPJ,
  Horse.Validator.Rule.Distinct,
  Horse.Validator.Rule.MinCount,
  Horse.Validator.Rule.MaxCount,
  Horse.Validator.Rule.Prohibited,
  Horse.Validator.Rule.uFile,
  Horse.Validator.Rule.MimeTypes,
  Horse.Validator.Rule.Extensions,
  Horse.Validator.Rule.RequiredIf;

{ TValidationBuilder }

class function TValidationBuilder.&File: IRule;
begin
  Result := TRuleFile.Create;
end;

class function TValidationBuilder.Accepted: IRule;
begin
  Result := TRuleAccepted.Create;
end;

class function TValidationBuilder.ActiveUrl: IRule;
begin
  Result := TRuleActiveUrl.Create;
end;

class function TValidationBuilder.After(const ADateTime: TDateTime): IRule;
begin
  Result := TRuleAfter.Create(TArgument<TDateTime>.Literal(ADateTime));
end;

class function TValidationBuilder.After(const AFieldName: string): IRule;
begin
  Result := TRuleAfter.Create(TArgument<TDateTime>.Reference(AFieldName));
end;

class function TValidationBuilder.AfterOrEqual(const ADateTime: TDateTime): IRule;
begin
  Result := TRuleAfterOrEqual.Create(TArgument<TDateTime>.Literal(ADateTime));
end;

class function TValidationBuilder.AfterOrEqual(const AFieldName: string): IRule;
begin
  Result := TRuleAfterOrEqual.Create(TArgument<TDateTime>.Reference(AFieldName));
end;

class function TValidationBuilder.Alpha: IRule;
begin
  Result := TRuleAlpha.Create;
end;

class function TValidationBuilder.AlphaDash: IRule;
begin
  Result := TRuleAlphaDash.Create;
end;

class function TValidationBuilder.AlphaNumeric: IRule;
begin
  Result := TRuleAlphaNumeric.Create;
end;

class function TValidationBuilder.Ascii: IRule;
begin
  Result := TRuleAscii.Create;
end;

class function TValidationBuilder.Before(const ADateTime: TDateTime): IRule;
begin
  Result := TRuleBefore.Create(TArgument<TDateTime>.Literal(ADateTime));
end;

class function TValidationBuilder.Before(const AFieldName: string): IRule;
begin
  Result := TRuleBefore.Create(TArgument<TDateTime>.Reference(AFieldName));
end;

class function TValidationBuilder.BeforeOrEqual(const ADateTime: TDateTime): IRule;
begin
  Result := TRuleBeforeOrEqual.Create(TArgument<TDateTime>.Literal(ADateTime));
end;

class function TValidationBuilder.BeforeOrEqual(const AFieldName: string): IRule;
begin
  Result := TRuleBeforeOrEqual.Create(TArgument<TDateTime>.Reference(AFieldName));
end;

class function TValidationBuilder.Between(const AMin, AMax: Double): IRule;
begin
  Result := TRuleBetween.Create(TArgument<Double>.Literal(AMin), TArgument<Double>.Literal(AMax));
end;

class function TValidationBuilder.Between(const AFieldMin, AFieldMax: string): IRule;
begin
  Result := TRuleBetween.Create(TArgument<Double>.Reference(AFieldMin), TArgument<Double>.Reference(AFieldMax));
end;

class function TValidationBuilder.Boolean: IRule;
begin
  Result := TRuleBoolean.Create;
end;

class function TValidationBuilder.CNPJ: IRule;
begin
  Result := TRuleCNPJ.Create;
end;

class function TValidationBuilder.Confirmed: IRule;
begin
  Result := TRuleConfirmed.Create;
end;

class function TValidationBuilder.CPF: IRule;
begin
  Result := TRuleCPF.Create;
end;

class function TValidationBuilder.CurrentPassword(const ACallback: TCheckPasswordCallback): IRule;
begin
  Result := TRuleCurrentPassword.Create(ACallback);
end;

class function TValidationBuilder.Date: IRule;
begin
  Result := TRuleDate.Create;
end;

class function TValidationBuilder.DateEquals(const ADateTime: TDateTime): IRule;
begin
  Result := TRuleDateEquals.Create(TArgument<TDateTime>.Literal(ADateTime));
end;

class function TValidationBuilder.DateEquals(const AFieldName: string): IRule;
begin
  Result := TRuleDateEquals.Create(TArgument<TDateTime>.Reference(AFieldName));
end;

class function TValidationBuilder.DateFormat(const AFormat: string): IRule;
begin
  Result := TRuleDateFormat.Create(AFormat);
end;

class function TValidationBuilder.Decimal(const ADecimalPlaces: Integer): IRule;
begin
  Result := TRuleDecimal.Create(ADecimalPlaces);
end;

class function TValidationBuilder.Declined: IRule;
begin
  Result := TRuleDeclined.Create;
end;

class function TValidationBuilder.Different(const AOtherFieldName: string): IRule;
begin
  Result := TRuleDifferent.Create(TArgument<Variant>.Reference(AOtherFieldName));
end;

class function TValidationBuilder.Different(const ALiteralValue: Variant): IRule;
begin
  Result := TRuleDifferent.Create(TArgument<Variant>.Literal(ALiteralValue));
end;

class function TValidationBuilder.Digits(const ALength: Integer): IRule;
begin
  Result := TRuleDigits.Create(ALength);
end;

class function TValidationBuilder.DigitsBetween(const AMinLength, AMaxLength: Integer): IRule;
begin
  Result := TRuleDigitsBetween.Create(AMinLength, AMaxLength);
end;

class function TValidationBuilder.Distinct: IRule;
begin
  Result := TRuleDistinct.Create;
end;

class function TValidationBuilder.DoesntEndWith(const ASubstrings: array of string): IRule;
begin
  Result := TRuleDoesntEndWith.Create(ASubstrings);
end;

class function TValidationBuilder.DoesntStartWith(const ASubstrings: array of string): IRule;
begin
  Result := TRuleDoesntStartWith.Create(ASubstrings);
end;

class function TValidationBuilder.Email(const ACheckDNS: Boolean): IRule;
begin
  Result := TRuleEmail.Create(ACheckDNS);
end;

class function TValidationBuilder.EndsWith(const ASubstrings: array of string): IRule;
begin
  Result := TRuleEndsWith.Create(ASubstrings);
end;

class function TValidationBuilder.Enum(const AEnumTypeInfo: PTypeInfo): IRule;
begin
  Result := TRuleEnum.Create(AEnumTypeInfo);
end;

class function TValidationBuilder.Exists(const ATableName, AColumnName: string; const ACallback: TExistsCallback): IRule;
begin
  Result := TRuleExists.Create(ATableName, AColumnName, ACallback);
end;

class function TValidationBuilder.Extensions(const AExtensions: array of string): IRule;
begin
  Result := TRuleExtensions.Create(AExtensions);
end;

class function TValidationBuilder.GreaterThan(const AValue: Double): IRule;
begin
  Result := TRuleGreaterThan.Create(TArgument<Variant>.Literal(AValue));
end;

class function TValidationBuilder.GreaterThan(const AFieldName: string): IRule;
begin
  Result := TRuleGreaterThan.Create(TArgument<Variant>.Reference(AFieldName));
end;

class function TValidationBuilder.GreaterThanOrEqual(const AValue: Double): IRule;
begin
  Result := TRuleGreaterThanOrEqual.Create(TArgument<Variant>.Literal(AValue));
end;

class function TValidationBuilder.GreaterThanOrEqual(const AFieldName: string): IRule;
begin
  Result := TRuleGreaterThanOrEqual.Create(TArgument<Variant>.Reference(AFieldName));
end;

class function TValidationBuilder.HexColor: IRule;
begin
  Result := TRuleHexColor.Create;
end;

class function TValidationBuilder.&In(const AValues: array of Variant): IRule;
begin
  Result := TRuleIn.Create(AValues);
end;

class function TValidationBuilder.Integer: IRule;
begin
  Result := TRuleInteger.Create;
end;

class function TValidationBuilder.IpAddress: IRule;
begin
  Result := TRuleIpAddress.Create;
end;

class function TValidationBuilder.IsArray: IRule;
begin
  Result := TRuleIsArray.Create;
end;

class function TValidationBuilder.IsObject: IRule;
begin
  Result := TRuleIsObject.Create;
end;

class function TValidationBuilder.JSON: IRule;
begin
  Result := TRuleJSON.Create;
end;

class function TValidationBuilder.LessThan(const AValue: Double): IRule;
begin
  Result := TRuleLessThan.Create(TArgument<Variant>.Literal(AValue));
end;

class function TValidationBuilder.LessThan(const AFieldName: string): IRule;
begin
  Result := TRuleLessThan.Create(TArgument<Variant>.Reference(AFieldName));
end;

class function TValidationBuilder.LessThanOrEqual(const AValue: Double): IRule;
begin
  Result := TRuleLessThanOrEqual.Create(TArgument<Variant>.Literal(AValue));
end;

class function TValidationBuilder.LessThanOrEqual(const AFieldName: string): IRule;
begin
  Result := TRuleLessThanOrEqual.Create(TArgument<Variant>.Reference(AFieldName));
end;

class function TValidationBuilder.Lowercase: IRule;
begin
  Result := TRuleLowercase.Create;
end;

class function TValidationBuilder.MACAddress: IRule;
begin
  Result := TRuleMACAddress.Create;
end;

class function TValidationBuilder.Max(const AValue: Double): IRule;
begin
  Result := TRuleMax.Create(TArgument<Double>.Literal(AValue));
end;

class function TValidationBuilder.Max(const AFieldName: string): IRule;
begin
  Result := TRuleMax.Create(TArgument<Double>.Reference(AFieldName));
end;

class function TValidationBuilder.MaxCount(const ACount: Integer): IRule;
begin
  Result := TRuleMaxCount.Create(ACount);
end;

class function TValidationBuilder.MaxDigits(const AMaxLength: Integer): IRule;
begin
  Result := TRuleMaxDigits.Create(AMaxLength);
end;

class function TValidationBuilder.Min(const AValue: Double): IRule;
begin
  Result := TRuleMin.Create(TArgument<Double>.Literal(AValue));
end;

class function TValidationBuilder.MimeTypes(const ATypes: array of string): IRule;
begin
  Result := TRuleMimeTypes.Create(ATypes);
end;

class function TValidationBuilder.Min(const AFieldName: string): IRule;
begin
  Result := TRuleMin.Create(TArgument<Double>.Reference(AFieldName));
end;

class function TValidationBuilder.MinCount(const ACount: Integer): IRule;
begin
  Result := TRuleMinCount.Create(ACount);
end;

class function TValidationBuilder.MinDigits(const AMinLength: Integer): IRule;
begin
  Result := TRuleMinDigits.Create(AMinLength);
end;

class function TValidationBuilder.MultipleOf(const AValue: Double): IRule;
begin
  Result := TRuleMultipleOf.Create(AValue);
end;

class function TValidationBuilder.NotIn(const AValues: array of Variant): IRule;
begin
  Result := TRuleNotIn.Create(AValues);
end;

class function TValidationBuilder.NotRegularExpression(const APattern: string): IRule;
begin
  Result := TRuleNotRegularExpression.Create(APattern);
end;

class function TValidationBuilder.Numeric: IRule;
begin
  Result := TRuleNumeric.Create;
end;

class function TValidationBuilder.Prohibited: IRule;
begin
  Result := TRuleProhibited.Create;
end;

class function TValidationBuilder.RegularExpression(const APattern: string): IRule;
begin
  Result := TRuleRegularExpression.Create(APattern);
end;

class function TValidationBuilder.Required: IRule;
begin
  Result := TRuleRequired.Create;
end;

class function TValidationBuilder.RequiredIf(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule): IRule;
begin
  Result := TRuleRequiredIf.Create(AOtherFieldName, AOperator, AExpectedValue, ARules);
end;

class function TValidationBuilder.Same(const AOtherFieldName: string): IRule;
begin
  Result := TRuleSame.Create(TArgument<Variant>.Reference(AOtherFieldName));
end;

class function TValidationBuilder.Same(const ALiteralValue: Variant): IRule;
begin
  Result := TRuleSame.Create(TArgument<Variant>.Literal(ALiteralValue));
end;

class function TValidationBuilder.Size(const AValue: Double): IRule;
begin
  Result := TRuleSize.Create(TArgument<Double>.Literal(AValue));
end;

class function TValidationBuilder.Size(const AFieldName: string): IRule;
begin
  Result := TRuleSize.Create(TArgument<Double>.Reference(AFieldName));
end;

class function TValidationBuilder.StartsWith(const ASubstrings: array of string): IRule;
begin
  Result := TRuleStartsWith.Create(ASubstrings);
end;

class function TValidationBuilder.&String: IRule;
begin
  Result := TRuleString.Create;
end;

class function TValidationBuilder.Timezone: IRule;
begin
  Result := TRuleTimezone.Create;
end;

class function TValidationBuilder.ULID: IRule;
begin
  Result := TRuleULID.Create;
end;

class function TValidationBuilder.Unique(const ATableName, AColumnName: string; const ACallback: TUniqueCallback;
  const AIgnoreId: string): IRule;
begin
  Result := TRuleUnique.Create(ATableName, AColumnName, ACallback, AIgnoreId);
end;

class function TValidationBuilder.Uppercase: IRule;
begin
  Result := TRuleUppercase.Create;
end;

class function TValidationBuilder.URL: IRule;
begin
  Result := TRuleURL.Create;
end;

class function TValidationBuilder.UUID: IRule;
begin
  Result := TRuleUUID.Create;
end;

class function TValidationBuilder.When(const ACondition: TFunc<Boolean>; const ARules: array of IRule): IRule;
begin
  Result := TRuleIfVal.Create(ACondition, ARules);
end;

end.
