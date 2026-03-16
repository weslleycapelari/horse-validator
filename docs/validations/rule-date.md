# Validation: Date

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Date`
- Category behavior: Uses date parsing and date comparison semantics (literal or field reference).

## Internal Reference

- Unit: `Horse.Validator.Rule.Date`
- Class: `TRuleDate`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Date.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Date`

## Available Signatures

- `class function Date: IRule;`

## Parameters and Configuration Notes


## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.birthDate')
  .AddRule(TRules.Date())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.birthDate')
  .AddRule(TRules.Date())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.birthDate').AddRule(TRules.Required)
  .Field('body.birthDate').AddRule(TRules.Date().SetMessage('Date validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.events.*.date')
  .AddRule(TRules.Date())
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.birthDate`): `1991-08-15`
- Failing sample (`body.birthDate`): `1991-15-40`

### Valid Request Payload

```json
{
  "birthDate": "1991-08-15"
}
```

### Invalid Request Payload

```json
{
  "birthDate": "1991-15-40"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.birthDate": [
      "The field body.birthDate failed the Date rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Leverages date utils and supports multiple parse strategies.

## Related Rules

- `Date`, `DateFormat`, `After`, `AfterOrEqual`, `Before`, `BeforeOrEqual`, `DateEquals`
