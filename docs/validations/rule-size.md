# Validation: Size

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Size`
- Class: `TRuleSize`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Size.pas`

## Constructors

- `constructor Create(const ASize: TArgument<Double>);`
- `constructor TRuleSize.Create(const ASize: TArgument<Double>);`

## Builder API

- `TRules.Size`

## Available Signatures

- `class function Size(const AValue: Double): IRule; overload;`
- `class function Size(const AFieldName: string): IRule; overload;`

## Parameters and Configuration Notes

- `Double`: numeric threshold/range configuration.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.Size(10.5))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.Size(10.5))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.Size('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.Size(10.5).SetMessage('Size validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.Size(10.5))
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
      "The field body.value failed the Size rule."
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

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
