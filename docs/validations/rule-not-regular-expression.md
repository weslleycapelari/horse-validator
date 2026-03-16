# Validation: NotRegularExpression

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.NotRegularExpression`
- Class: `TRuleNotRegularExpression`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.NotRegularExpression.pas`

## Constructors

- `constructor Create(const APattern: string);`
- `constructor TRuleNotRegularExpression.Create(const APattern: string);`

## Builder API

- `TRules.NotRegularExpression`

## Available Signatures

- `class function NotRegularExpression(const APattern: string): IRule;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.comment')
  .AddRule(TRules.NotRegularExpression('referenceField'))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.comment')
  .AddRule(TRules.NotRegularExpression('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.comment').AddRule(TRules.Required)
  .Field('body.comment').AddRule(TRules.NotRegularExpression('referenceField').SetMessage('NotRegularExpression validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.comments.*.text')
  .AddRule(TRules.NotRegularExpression('referenceField'))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.comment`): `normal text`
- Failing sample (`body.comment`): `contains blocked pattern`

### Valid Request Payload

```json
{
  "comment": "normal text"
}
```

### Invalid Request Payload

```json
{
  "comment": "contains blocked pattern"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.comment": [
      "The field body.comment failed the NotRegularExpression rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Useful for deny-list constraints or policy bans.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
