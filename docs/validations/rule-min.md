# Validation: Min

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Min`
- Class: `TRuleMin`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Min.pas`

## Constructors

- `constructor Create(const AMin: TArgument<Double>);`
- `constructor TRuleMin.Create(const AMin: TArgument<Double>);`

## Builder API

- `TRules.Min`

## Available Signatures

- `class function Min(const AValue: Double): IRule; overload;`
- `class function Min(const AFieldName: string): IRule; overload;`

## Parameters and Configuration Notes

- `Double`: numeric threshold/range configuration.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.age')
  .AddRule(TRules.Min(10.5))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.age')
  .AddRule(TRules.Min(10.5))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.age')
  .AddRule(TRules.Min('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.age').AddRule(TRules.Required)
  .Field('body.age').AddRule(TRules.Min(10.5).SetMessage('Min validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.users.*.age')
  .AddRule(TRules.Min(10.5))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.age`): `18`
- Failing sample (`body.age`): `17`

### Valid Request Payload

```json
{
  "age": "18"
}
```

### Invalid Request Payload

```json
{
  "age": "17"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.age": [
      "The field body.age failed the Min rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Handles numeric value and length semantics depending on context.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
