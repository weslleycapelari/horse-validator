# Validation: NotIn

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.NotIn`
- Class: `TRuleNotIn`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.NotIn.pas`

## Constructors

- `constructor Create(const AValues: array of Variant);`
- `constructor TRuleNotIn.Create(const AValues: array of Variant);`

## Builder API

- `TRules.NotIn`

## Available Signatures

- `class function NotIn(const AValues: array of Variant): IRule;`

## Parameters and Configuration Notes

- `array of Variant`: useful for flexible in/not-in lists with mixed scalar values.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.username')
  .AddRule(TRules.NotIn(['root', 'system']))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.username')
  .AddRule(TRules.NotIn(['root', 'system']))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.username').AddRule(TRules.Required)
  .Field('body.username').AddRule(TRules.NotIn(['root', 'system']).SetMessage('NotIn validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.users.*.username')
  .AddRule(TRules.NotIn(['root', 'system']))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.username`): `john`
- Failing sample (`body.username`): `admin`

### Valid Request Payload

```json
{
  "username": "john"
}
```

### Invalid Request Payload

```json
{
  "username": "admin"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.username": [
      "The field body.username failed the NotIn rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Blacklist behavior; use carefully with reserved words.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
