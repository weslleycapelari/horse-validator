# Validation: Numeric

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Number`
- Category behavior: Focuses on numeric conversion, numeric bounds, precision, and arithmetic constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Numeric`
- Class: `TRuleNumeric`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Numeric.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Numeric`

## Available Signatures

- `class function Numeric: IRule;`

## Parameters and Configuration Notes


## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.amount')
  .AddRule(TRules.Numeric())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.amount')
  .AddRule(TRules.Numeric())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.amount').AddRule(TRules.Required)
  .Field('body.amount').AddRule(TRules.Numeric().SetMessage('Numeric validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.amount')
  .AddRule(TRules.Numeric())
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.amount`): `123.45`
- Failing sample (`body.amount`): `12a`

### Valid Request Payload

```json
{
  "amount": "123.45"
}
```

### Invalid Request Payload

```json
{
  "amount": "12a"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.amount": [
      "The field body.amount failed the Numeric rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Good baseline for monetary or measured values.

## Related Rules

- `Numeric`, `Integer`, `Min`, `Max`, `Between`, `MultipleOf`
