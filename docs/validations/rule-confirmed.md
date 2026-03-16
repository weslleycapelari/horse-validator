# Validation: Confirmed

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Database`
- Category behavior: Delegates checks to callback-based integration with persistence/database.

## Internal Reference

- Unit: `Horse.Validator.Rule.Confirmed`
- Class: `TRuleConfirmed`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Confirmed.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Confirmed`

## Available Signatures

- `class function Confirmed: IRule;`

## Parameters and Configuration Notes


## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.password')
  .AddRule(TRules.Confirmed())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.password')
  .AddRule(TRules.Confirmed())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.password').AddRule(TRules.Required)
  .Field('body.password').AddRule(TRules.Confirmed().SetMessage('Confirmed validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.account.password')
  .AddRule(TRules.Confirmed())
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.password`): `Strong#123`
- Failing sample (`body.password`): `Mismatch with password_confirmation`

### Valid Request Payload

```json
{
  "password": "Strong#123"
}
```

### Invalid Request Payload

```json
{
  "password": "Mismatch with password_confirmation"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.password": [
      "The field body.password failed the Confirmed rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Requires `<field>_confirmation` with same value.

## Related Rules

- `Exists`, `Unique`, `Confirmed`, `CurrentPassword`
