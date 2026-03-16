# Validation: Email

[Back to Core Documentation](../README.md)

## Purpose

- Validates email syntax and can optionally enforce DNS-level checks.
- Category: `String`
- Category behavior: Focuses on textual format, allowed character set, and lexical constraints.

## Internal Reference

- Unit: `Horse.Validator.Rule.Email`
- Class: `TRuleEmail`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Email.pas`

## Constructors

- `constructor Create(const ACheckDNS: Boolean = False);`
- `constructor TRuleEmail.Create(const ACheckDNS: Boolean = False);`

## Builder API

- `TRules.Email`

## Available Signatures

- `class function Email(const ACheckDNS: Boolean = False): IRule;`

## Parameters and Configuration Notes

- `Boolean`: toggles behavior mode, often increasing strictness.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.email')
  .AddRule(TRules.Email(True))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.email')
  .AddRule(TRules.Email(True))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.email').AddRule(TRules.Required)
  .Field('body.email').AddRule(TRules.Email(True).SetMessage('Email validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('contacts.*.email')
  .AddRule(TRules.Email(True))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.email`): `john@example.com`
- Failing sample (`body.email`): `john@`

### Valid Request Payload

```json
{
  "email": "john@example.com"
}
```

### Invalid Request Payload

```json
{
  "email": "john@"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.email": [
      "The field body.email failed the Email rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Use `TRules.Email(True)` when DNS verification is required and acceptable for your performance budget.

## Related Rules

- `Required`, `RegularExpression`, `NotRegularExpression`, `Size`, `Min`, `Max`
