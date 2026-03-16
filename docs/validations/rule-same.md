# Validation: Same

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Same`
- Class: `TRuleSame`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Same.pas`

## Constructors

- `constructor Create(const ATarget: TArgument<Variant>);`
- `constructor TRuleSame.Create(const ATarget: TArgument<Variant>);`

## Builder API

- `TRules.Same`

## Available Signatures

- `class function Same(const AOtherFieldName: string): IRule; overload;`
- `class function Same(const ALiteralValue: Variant): IRule; overload;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.confirmEmail')
  .AddRule(TRules.Same('referenceField'))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.confirmEmail')
  .AddRule(TRules.Same('referenceField'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.confirmEmail')
  .AddRule(TRules.Same())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.confirmEmail').AddRule(TRules.Required)
  .Field('body.confirmEmail').AddRule(TRules.Same('referenceField').SetMessage('Same validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.profile.confirmEmail')
  .AddRule(TRules.Same('referenceField'))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.confirmEmail`): `same as email`
- Failing sample (`body.confirmEmail`): `different from email`

### Valid Request Payload

```json
{
  "confirmEmail": "same as email"
}
```

### Invalid Request Payload

```json
{
  "confirmEmail": "different from email"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.confirmEmail": [
      "The field body.confirmEmail failed the Same rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Useful for confirmation fields and strict equality checks.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
