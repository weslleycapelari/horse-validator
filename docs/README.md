# Horse Validator - Core Documentation

This document explains the validation core architecture and provides a complete index of all validation rules.

## Core Purpose

1. Build a unified request JSON from body, query, params, and headers.
2. Resolve dot-notation paths with wildcard expansion (`*`).
3. Execute rules by field and collect validation errors per resolved path.

## Main Architecture

### Public Layer
- Public aliases and API entry points in `Horse.Validator.pas`.
- Middleware registration through `HandleValidator`.
- Fluent validator contract with `Field`, `AddRule`, `Scope`, `IfVal`, and `Validate`.

### Execution Core
- `THorseValidator` orchestrates the entire validation lifecycle.
- `BuildMasterJSON` merges request sources into one JSON tree.
- `ResolveValues` traverses objects/arrays and expands wildcard paths.
- `Validate` executes mapped rules and raises validation exception when needed.

### Rule Repository
- `TRuleCollection` stores rules by logical field key.
- Context-aware rules receive current field path and value provider.
- Required-awareness controls empty/missing field handling.

### Contracts and Types
- `IRule`, `IRuleContextAware`, and `IValidator` define core contracts.
- `TArgument<T>` supports literal values and dynamic field references.
- Callbacks enable DB checks and custom business integration.

### Error Handling
- `EHorseValidationException` stores summary message, HTTP status, and field errors.
- Built-in JSON serialization through `ToJSONObject` and `ToJSON`.
- Middleware translates validation exceptions into HTTP responses.

### Date Utilities
- `TDateHelper` centralizes parsing and date-time validation support.
- Used by date-oriented rules and argument conversion logic.

## Core Files Reviewed

- `src/Horse.Validator.pas`
- `src/Horse.Validator.Core.pas`
- `src/Horse.Validator.Interfaces.pas`
- `src/Horse.Validator.Collection.pas`
- `src/Horse.Validator.Rule.Base.pas`
- `src/Horse.Validator.Builder.pas`
- `src/Horse.Validator.Types.pas`
- `src/Horse.Validator.Middleware.pas`
- `src/Horse.Validator.Exception.pas`
- `src/Horse.Validator.DateUtils.pas`

## Validation Flow Example

```pascal
THorse
  .Use(HandleValidator)
  .Post('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      THorseValidator.New(Req)
        .Field('body.email').AddRule(TRules.Required)
        .Field('body.email').AddRule(TRules.Email(True))
        .Validate;

      Res.Send('OK');
    end);
```

## How to Read Each Validation Page

Every file in `docs/validations` follows an advanced structure so teams can go from quick lookup to production usage:

- Purpose and category behavior.
- Internal reference (unit, class, validate signature, constructors).
- Builder API and overload signatures.
- Parameter/configuration notes.
- Basic example and advanced overload combinations.
- Wildcard/collection scenario (`*`).
- Passing and failing payload samples.
- Expected error shape.
- Edge cases and related rules.

## Complete Validation Index

### Array
- [Distinct](validations/rule-distinct.md)
- [MaxCount](validations/rule-max-count.md)
- [MinCount](validations/rule-min-count.md)

### Boolean
- [Accepted](validations/rule-accepted.md)
- [Boolean](validations/rule-boolean.md)
- [Declined](validations/rule-declined.md)

### Database
- [Confirmed](validations/rule-confirmed.md)
- [CurrentPassword](validations/rule-current-password.md)
- [Exists](validations/rule-exists.md)
- [Unique](validations/rule-unique.md)

### Date
- [After](validations/rule-after.md)
- [AfterOrEqual](validations/rule-after-or-equal.md)
- [Before](validations/rule-before.md)
- [BeforeOrEqual](validations/rule-before-or-equal.md)
- [Date](validations/rule-date.md)
- [DateEquals](validations/rule-date-equals.md)
- [DateFormat](validations/rule-date-format.md)
- [Timezone](validations/rule-timezone.md)

### File
- [Extensions](validations/rule-extensions.md)
- [File](validations/rule-file.md)
- [MimeTypes](validations/rule-mime-types.md)

### JSON Structure
- [IsArray](validations/rule-is-array.md)
- [IsObject](validations/rule-is-object.md)

### Localization (Brazil)
- [CNPJ](validations/rule-cnpj.md)
- [CPF](validations/rule-cpf.md)

### Number
- [Between](validations/rule-between.md)
- [Decimal](validations/rule-decimal.md)
- [Digits](validations/rule-digits.md)
- [DigitsBetween](validations/rule-digits-between.md)
- [GreaterThan](validations/rule-greater-than.md)
- [GreaterThanOrEqual](validations/rule-greater-than-or-equal.md)
- [Integer](validations/rule-integer.md)
- [LessThan](validations/rule-less-than.md)
- [LessThanOrEqual](validations/rule-less-than-or-equal.md)
- [MaxDigits](validations/rule-max-digits.md)
- [MinDigits](validations/rule-min-digits.md)
- [MultipleOf](validations/rule-multiple-of.md)
- [Numeric](validations/rule-numeric.md)

### String
- [ActiveUrl](validations/rule-active-url.md)
- [Alpha](validations/rule-alpha.md)
- [AlphaDash](validations/rule-alpha-dash.md)
- [AlphaNumeric](validations/rule-alpha-numeric.md)
- [Ascii](validations/rule-ascii.md)
- [Different](validations/rule-different.md)
- [DoesntEndWith](validations/rule-doesnt-end-with.md)
- [DoesntStartWith](validations/rule-doesnt-start-with.md)
- [Email](validations/rule-email.md)
- [EndsWith](validations/rule-ends-with.md)
- [Enum](validations/rule-enum.md)
- [HexColor](validations/rule-hex-color.md)
- [In](validations/rule-in.md)
- [IpAddress](validations/rule-ip-address.md)
- [JSON](validations/rule-json.md)
- [Lowercase](validations/rule-lowercase.md)
- [MACAddress](validations/rule-macaddress.md)
- [Max](validations/rule-max.md)
- [Min](validations/rule-min.md)
- [NotIn](validations/rule-not-in.md)
- [NotRegularExpression](validations/rule-not-regular-expression.md)
- [RegularExpression](validations/rule-regular-expression.md)
- [Same](validations/rule-same.md)
- [Size](validations/rule-size.md)
- [StartsWith](validations/rule-starts-with.md)
- [String](validations/rule-string.md)
- [ULID](validations/rule-ulid.md)
- [Uppercase](validations/rule-uppercase.md)
- [URL](validations/rule-url.md)
- [UUID](validations/rule-uuid.md)

### Utility
- [IfVal](validations/rule-if-val.md)
- [Prohibited](validations/rule-prohibited.md)
- [Required](validations/rule-required.md)
- [RequiredIf](validations/rule-required-if.md)

