# Validation: DateFormat

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Date`
- Category behavior: Uses date parsing and date comparison semantics (literal or field reference).

## Internal Reference

- Unit: `Horse.Validator.Rule.DateFormat`
- Class: `TRuleDateFormat`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.DateFormat.pas`

## Constructors

- `constructor Create(const AFormat: string);`
- `constructor TRuleDateFormat.Create(const AFormat: string);`

## Builder API

- `TRules.DateFormat`

## Available Signatures

- `class function DateFormat(const AFormat: string): IRule;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.billingDate')
  .AddRule(TRules.DateFormat('referenceField'))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.billingDate')
  .AddRule(TRules.DateFormat('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.billingDate').AddRule(TRules.Required)
  .Field('body.billingDate').AddRule(TRules.DateFormat('referenceField').SetMessage('DateFormat validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.invoices.*.billingDate')
  .AddRule(TRules.DateFormat('referenceField'))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.billingDate`): `16/03/2026`
- Failing sample (`body.billingDate`): `2026-03-16`

### Valid Request Payload

```json
{
  "billingDate": "16/03/2026"
}
```

### Invalid Request Payload

```json
{
  "billingDate": "2026-03-16"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.billingDate": [
      "The field body.billingDate failed the DateFormat rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Use for strict contract-driven date patterns.

## Related Rules

- `Date`, `DateFormat`, `After`, `AfterOrEqual`, `Before`, `BeforeOrEqual`, `DateEquals`
