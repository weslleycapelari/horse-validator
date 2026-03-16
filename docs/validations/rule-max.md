# Validation: Max

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Max`
- Class: `TRuleMax`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Max.pas`

## Constructors

- `constructor Create(const AMax: TArgument<Double>);`
- `constructor TRuleMax.Create(const AMax: TArgument<Double>);`

## Builder API

- `TRules.Max`

## Available Signatures

- `class function Max(const AValue: Double): IRule; overload;`
- `class function Max(const AFieldName: string): IRule; overload;`

## Parameters and Configuration Notes

- `Double`: numeric threshold/range configuration.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.title')
  .AddRule(TRules.Max(10.5))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.title')
  .AddRule(TRules.Max(10.5))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.title')
  .AddRule(TRules.Max('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.title').AddRule(TRules.Required)
  .Field('body.title').AddRule(TRules.Max(10.5).SetMessage('Max validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.posts.*.title')
  .AddRule(TRules.Max(10.5))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.title`): `Short title`
- Failing sample (`body.title`): `Very long title exceeding max`

### Valid Request Payload

```json
{
  "title": "Short title"
}
```

### Invalid Request Payload

```json
{
  "title": "Very long title exceeding max"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.title": [
      "The field body.title failed the Max rule."
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
