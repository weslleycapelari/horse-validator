# Validation: CPF

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Localization (Brazil)`
- Category behavior: Applies Brazilian document-specific checksum rules.

## Internal Reference

- Unit: `Horse.Validator.Rule.CPF`
- Class: `TRuleCPF`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.CPF.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.CPF`

## Available Signatures

- `class function CPF: IRule;`

## Parameters and Configuration Notes


## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.CPF())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.CPF())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.CPF().SetMessage('CPF validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.CPF())
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
      "The field body.value failed the CPF rule."
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

- See index in `docs/README.md` for adjacent rules by category.
