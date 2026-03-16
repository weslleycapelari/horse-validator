# Validation: RequiredIf

[Back to Core Documentation](../README.md)

## Purpose

- Makes the field required when a conditional expression and nested rules are satisfied.
- Category: `Utility`
- Category behavior: Supports presence, conditional, or orchestration-level validation semantics.

## Internal Reference

- Unit: `Horse.Validator.Rule.RequiredIf`
- Class: `TRuleRequiredIf`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.RequiredIf.pas`

## Constructors

- `constructor Create(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule);`
- `constructor TRuleRequiredIf.Create(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule);`

## Builder API

- `TRules.RequiredIf`

## Available Signatures

- `class function RequiredIf(const AOtherFieldName, AOperator, AExpectedValue: string; const ARules: array of IRule): IRule;`

## Parameters and Configuration Notes

- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.stateRegistration')
  .AddRule(TRules.RequiredIf('body.personType', '=', 'LEGAL', [TRules.Required]))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.stateRegistration')
  .AddRule(TRules.RequiredIf('body.personType', '=', 'LEGAL', [TRules.Required]))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.stateRegistration').AddRule(TRules.Required)
  .Field('body.stateRegistration').AddRule(TRules.RequiredIf('body.personType', '=', 'LEGAL', [TRules.Required]).SetMessage('RequiredIf validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.company.stateRegistration')
  .AddRule(TRules.RequiredIf('body.personType', '=', 'LEGAL', [TRules.Required]))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.stateRegistration`): `12345`
- Failing sample (`body.stateRegistration`): ``

### Valid Request Payload

```json
{
  "stateRegistration": "12345"
}
```

### Invalid Request Payload

```json
{
  "stateRegistration": ""
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.stateRegistration": [
      "The field body.stateRegistration failed the RequiredIf rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Use when field presence depends on another field and operator expression.

## Related Rules

- `Required`, `RequiredIf`, `IfVal`, `Prohibited`
