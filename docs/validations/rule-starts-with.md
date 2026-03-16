# Validation: StartsWith

[Back to Core Documentation](../README.md)

## Purpose

- Validates the field according to this rule contract.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.StartsWith`
- Class: `TRuleStartsWith`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.StartsWith.pas`

## Constructors

- `constructor Create(const ASubstrings: array of string);`
- `constructor TRuleStartsWith.Create(const ASubstrings: array of string);`

## Builder API

- `TRules.StartsWith`

## Available Signatures

- `class function StartsWith(const ASubstrings: array of string): IRule;`

## Parameters and Configuration Notes

- `array of string`: provide a whitelist/blacklist list (prefixes, suffixes, extensions, MIME types).
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.StartsWith(['PRD-', 'SKU-']))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.value')
  .AddRule(TRules.StartsWith(['PRD-', 'SKU-']))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.value').AddRule(TRules.Required)
  .Field('body.value').AddRule(TRules.StartsWith(['PRD-', 'SKU-']).SetMessage('StartsWith validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.items.*.value')
  .AddRule(TRules.StartsWith(['PRD-', 'SKU-']))
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
      "The field body.value failed the StartsWith rule."
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
