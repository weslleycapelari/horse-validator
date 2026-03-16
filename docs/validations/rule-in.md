# Validation: In

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.uIn`
- Class: `TRuleIn`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.uIn.pas`

## Constructors

- `constructor Create(const AValues: array of Variant);`
- `constructor TRuleIn.Create(const AValues: array of Variant);`

## Builder API

- `TRules.In`

## Available Signatures

- `class function &In(const AValues: array of Variant): IRule;`

## Parameters and Configuration Notes

- `array of Variant`: useful for flexible in/not-in lists with mixed scalar values.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.status')
  .AddRule(TRules.In(['admin', 'user', 'guest']))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.status')
  .AddRule(TRules.In(['admin', 'user', 'guest']))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.status').AddRule(TRules.Required)
  .Field('body.status').AddRule(TRules.In(['admin', 'user', 'guest']).SetMessage('In validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.orders.*.status')
  .AddRule(TRules.In(['admin', 'user', 'guest']))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.status`): `approved`
- Failing sample (`body.status`): `archived`

### Valid Request Payload

```json
{
  "status": "approved"
}
```

### Invalid Request Payload

```json
{
  "status": "archived"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.status": [
      "The field body.status failed the In rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Whitelist behavior; pair with enum-style contracts.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
