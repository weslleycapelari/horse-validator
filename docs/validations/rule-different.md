# Validation: Different

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Different`
- Class: `TRuleDifferent`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Different.pas`

## Constructors

- `constructor Create(const ATarget: TArgument<Variant>);`
- `constructor TRuleDifferent.Create(const ATarget: TArgument<Variant>);`

## Builder API

- `TRules.Different`

## Available Signatures

- `class function Different(const AOtherFieldName: string): IRule; overload;`
- `class function Different(const ALiteralValue: Variant): IRule; overload;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.newPassword')
  .AddRule(TRules.Different('referenceField'))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.newPassword')
  .AddRule(TRules.Different('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.newPassword')
  .AddRule(TRules.Different())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.newPassword').AddRule(TRules.Required)
  .Field('body.newPassword').AddRule(TRules.Different('referenceField').SetMessage('Different validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.account.newPassword')
  .AddRule(TRules.Different('referenceField'))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.newPassword`): `New#123`
- Failing sample (`body.newPassword`): `Same as oldPassword`

### Valid Request Payload

```json
{
  "newPassword": "New#123"
}
```

### Invalid Request Payload

```json
{
  "newPassword": "Same as oldPassword"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.newPassword": [
      "The field body.newPassword failed the Different rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Can compare with literal value or sibling field reference.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
