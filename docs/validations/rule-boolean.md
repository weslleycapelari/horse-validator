# Validation: Boolean

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Boolean`
- Category behavior: Checks accepted boolean or opt-in/opt-out value representations.

## Internal Reference

- Unit: `Horse.Validator.Rule.Boolean`
- Class: `TRuleBoolean`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Boolean.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Boolean`

## Available Signatures

- `class function Boolean: IRule;`

## Parameters and Configuration Notes

- `Boolean`: toggles behavior mode, often increasing strictness.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.Boolean())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.Boolean())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.Boolean().SetMessage('Boolean validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.Boolean())
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
      "The field body.value failed the Boolean rule."
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
