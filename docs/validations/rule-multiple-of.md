# Validation: MultipleOf

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Number`
- Category behavior: Focuses on numeric conversion, numeric bounds, precision, and arithmetic constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.MultipleOf`
- Class: `TRuleMultipleOf`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.MultipleOf.pas`

## Constructors

- `constructor Create(const AValue: Double);`
- `constructor TRuleMultipleOf.Create(const AValue: Double);`

## Builder API

- `TRules.MultipleOf`

## Available Signatures

- `class function MultipleOf(const AValue: Double): IRule;`

## Parameters and Configuration Notes

- `Double`: numeric threshold/range configuration.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.MultipleOf(10.5))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.MultipleOf(10.5))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.MultipleOf(10.5).SetMessage('MultipleOf validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.MultipleOf(10.5))
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
      "The field body.value failed the MultipleOf rule."
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

- `Numeric`, `Integer`, `Min`, `Max`, `Between`, `MultipleOf`
