# Validation: Between

[Back to Core Documentation](../README.md)

## Purpose

- Validates numeric value inside an inclusive min/max range.
- Category: `Number`
- Category behavior: Focuses on numeric conversion, numeric bounds, precision, and arithmetic constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Between`
- Class: `TRuleBetween`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Between.pas`

## Constructors

- `constructor Create(const AMin, AMax: TArgument<Double>);`
- `constructor TRuleBetween.Create(const AMin, AMax: TArgument<Double>);`

## Builder API

- `TRules.Between`

## Available Signatures

- `class function Between(const AMin, AMax: Double): IRule; overload;`
- `class function Between(const AFieldMin, AFieldMax: string): IRule; overload;`

## Parameters and Configuration Notes

- `Double`: numeric threshold/range configuration.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.price')
  .AddRule(TRules.Between(10.5))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.price')
  .AddRule(TRules.Between(10.5))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.price')
  .AddRule(TRules.Between('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.price').AddRule(TRules.Required)
  .Field('body.price').AddRule(TRules.Between(10.5).SetMessage('Between validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.products.*.price')
  .AddRule(TRules.Between(10.5))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.price`): `59.90`
- Failing sample (`body.price`): `120.00`

### Valid Request Payload

```json
{
  "price": "59.90"
}
```

### Invalid Request Payload

```json
{
  "price": "120.00"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.price": [
      "The field body.price failed the Between rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Can compare against literals or two referenced fields.

## Related Rules

- `Numeric`, `Integer`, `Min`, `Max`, `Between`, `MultipleOf`
