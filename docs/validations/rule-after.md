# Validation: After

[Back to Core Documentation](../README.md)

## Purpose

- Validates date/time strictly after a literal date or referenced field.
- Category: `Date`
- Category behavior: Uses date parsing and date comparison semantics (literal or field reference).

## Internal Reference

- Unit: `Horse.Validator.Rule.After`
- Class: `TRuleAfter`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.After.pas`

## Constructors

- `constructor Create(const ARefDate: TArgument<TDateTime>);`
- `constructor TRuleAfter.Create(const ARefDate: TArgument<TDateTime>);`

## Builder API

- `TRules.After`

## Available Signatures

- `class function After(const ADateTime: TDateTime): IRule; overload;`
- `class function After(const AFieldName: string): IRule; overload;`

## Parameters and Configuration Notes

- `TDateTime`: fixed date reference for comparison rules.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.startDate')
  .AddRule(TRules.After(EncodeDate(2026, 3, 16)))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.startDate')
  .AddRule(TRules.After(EncodeDate(2026, 3, 16)))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.startDate')
  .AddRule(TRules.After('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.startDate').AddRule(TRules.Required)
  .Field('body.startDate').AddRule(TRules.After(EncodeDate(2026, 3, 16)).SetMessage('After validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.period.startDate')
  .AddRule(TRules.After(EncodeDate(2026, 3, 16)))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.startDate`): `2026-03-17`
- Failing sample (`body.startDate`): `2026-03-10`

### Valid Request Payload

```json
{
  "startDate": "2026-03-17"
}
```

### Invalid Request Payload

```json
{
  "startDate": "2026-03-10"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.startDate": [
      "The field body.startDate failed the After rule."
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
