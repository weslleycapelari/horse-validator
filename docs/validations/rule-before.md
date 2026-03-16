# Validation: Before

[Back to Core Documentation](../README.md)

## Purpose

- Validates date/time strictly before a literal date or referenced field.
- Category: `Date`
- Category behavior: Uses date parsing and date comparison semantics (literal or field reference).

## Internal Reference

- Unit: `Horse.Validator.Rule.Before`
- Class: `TRuleBefore`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Before.pas`

## Constructors

- `constructor Create(const ARefDate: TArgument<TDateTime>);`
- `constructor TRuleBefore.Create(const ARefDate: TArgument<TDateTime>);`

## Builder API

- `TRules.Before`

## Available Signatures

- `class function Before(const ADateTime: TDateTime): IRule; overload;`
- `class function Before(const AFieldName: string): IRule; overload;`

## Parameters and Configuration Notes

- `TDateTime`: fixed date reference for comparison rules.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.endDate')
  .AddRule(TRules.Before(EncodeDate(2026, 3, 16)))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.endDate')
  .AddRule(TRules.Before(EncodeDate(2026, 3, 16)))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.endDate')
  .AddRule(TRules.Before('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.endDate').AddRule(TRules.Required)
  .Field('body.endDate').AddRule(TRules.Before(EncodeDate(2026, 3, 16)).SetMessage('Before validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.period.endDate')
  .AddRule(TRules.Before(EncodeDate(2026, 3, 16)))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.endDate`): `2026-03-10`
- Failing sample (`body.endDate`): `2026-03-20`

### Valid Request Payload

```json
{
  "endDate": "2026-03-10"
}
```

### Invalid Request Payload

```json
{
  "endDate": "2026-03-20"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.endDate": [
      "The field body.endDate failed the Before rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Supports fixed literal and field-reference comparison.

## Related Rules

- `Date`, `DateFormat`, `After`, `AfterOrEqual`, `Before`, `BeforeOrEqual`, `DateEquals`
