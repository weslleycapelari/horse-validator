# Validation: Decimal

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Number`
- Category behavior: Focuses on numeric conversion, numeric bounds, precision, and arithmetic constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Decimal`
- Class: `TRuleDecimal`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Decimal.pas`

## Constructors

- `constructor Create(const ADecimalPlaces: Integer);`
- `constructor TRuleDecimal.Create(const ADecimalPlaces: Integer);`

## Builder API

- `TRules.Decimal`

## Available Signatures

- `class function Decimal(const ADecimalPlaces: Integer): IRule;`

## Parameters and Configuration Notes

- `Integer`: fixed length/count/precision style configuration.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.amount')
  .AddRule(TRules.Decimal(3))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.amount')
  .AddRule(TRules.Decimal(3))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.amount').AddRule(TRules.Required)
  .Field('body.amount').AddRule(TRules.Decimal(3).SetMessage('Decimal validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.amount')
  .AddRule(TRules.Decimal(3))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.amount`): `10.50`
- Failing sample (`body.amount`): `10.5`

### Valid Request Payload

```json
{
  "amount": "10.50"
}
```

### Invalid Request Payload

```json
{
  "amount": "10.5"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.amount": [
      "The field body.amount failed the Decimal rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Use for exact decimal precision control.

## Related Rules

- `Numeric`, `Integer`, `Min`, `Max`, `Between`, `MultipleOf`
