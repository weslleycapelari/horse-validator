# Validation: CurrentPassword

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Database`
- Category behavior: Delegates checks to callback-based integration with persistence/database.

## Internal Reference

- Unit: `Horse.Validator.Rule.CurrentPassword`
- Class: `TRuleCurrentPassword`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.CurrentPassword.pas`

## Constructors

- `constructor Create(const ACallback: TCheckPasswordCallback);`
- `constructor TRuleCurrentPassword.Create(const ACallback: TCheckPasswordCallback);`

## Builder API

- `TRules.CurrentPassword`

## Available Signatures

- `class function CurrentPassword(const ACallback: TCheckPasswordCallback): IRule;`

## Parameters and Configuration Notes

- `TCheckPasswordCallback`: isolate credential comparison in secure domain logic.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.CurrentPassword(CheckPassword))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.CurrentPassword(CheckPassword))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.CurrentPassword(CheckPassword).SetMessage('CurrentPassword validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.CurrentPassword(CheckPassword))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.value`): `valid sample`
- Failing sample (`body.value`): `invalid sample`

### Valid Request Payload

```json
{
  "value": "valid sample"
}
```

### Invalid Request Payload

```json
{
  "value": "invalid sample"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.value": [
      "The field body.value failed the CurrentPassword rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Adjust examples to your domain values and business constraints.

## Related Rules

- `Exists`, `Unique`, `Confirmed`, `CurrentPassword`
