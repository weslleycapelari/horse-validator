# Validation: Integer

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `Number`
- Category behavior: Focuses on numeric conversion, numeric bounds, precision, and arithmetic constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Integer`
- Class: `TRuleInteger`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Integer.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Integer`

## Available Signatures

- `class function Integer: IRule;`

## Parameters and Configuration Notes

- `Integer`: fixed length/count/precision style configuration.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.quantity')
  .AddRule(TRules.Integer())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.quantity')
  .AddRule(TRules.Integer())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.quantity').AddRule(TRules.Required)
  .Field('body.quantity').AddRule(TRules.Integer().SetMessage('Integer validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.quantity')
  .AddRule(TRules.Integer())
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.quantity`): `10`
- Failing sample (`body.quantity`): `10.5`

### Valid Request Payload

```json
{
  "quantity": "10"
}
```

### Invalid Request Payload

```json
{
  "quantity": "10.5"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.quantity": [
      "The field body.quantity failed the Integer rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Use before arithmetic rules that require integer semantics.

## Related Rules

- `Numeric`, `Integer`, `Min`, `Max`, `Between`, `MultipleOf`
