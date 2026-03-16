# Validation: RegularExpression

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.RegularExpression`
- Class: `TRuleRegularExpression`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.RegularExpression.pas`

## Constructors

- `constructor Create(const APattern: string);`
- `constructor TRuleRegularExpression.Create(const APattern: string);`

## Builder API

- `TRules.RegularExpression`

## Available Signatures

- `class function RegularExpression(const APattern: string): IRule;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.code')
  .AddRule(TRules.RegularExpression('referenceField'))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.code')
  .AddRule(TRules.RegularExpression('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.code').AddRule(TRules.Required)
  .Field('body.code').AddRule(TRules.RegularExpression('referenceField').SetMessage('RegularExpression validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.code')
  .AddRule(TRules.RegularExpression('referenceField'))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.code`): `PRD-001`
- Failing sample (`body.code`): `P1`

### Valid Request Payload

```json
{
  "code": "PRD-001"
}
```

### Invalid Request Payload

```json
{
  "code": "P1"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.code": [
      "The field body.code failed the RegularExpression rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Best for custom formatting that built-in rules do not cover.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
