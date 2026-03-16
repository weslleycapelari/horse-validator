# Validation: Required

[Back to Core Documentation](../README.md)

## Purpose

- Ensures the field is present and not empty.
- Category: `Utility`
- Category behavior: Supports presence, conditional, or orchestration-level validation semantics.

## Internal Reference

- Unit: `Horse.Validator.Rule.Required`
- Class: `TRuleRequired`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Required.pas`

## Constructors

- `constructor Create;`

## Builder API

- `TRules.Required`

## Available Signatures

- `class function Required: IRule;`

## Parameters and Configuration Notes


## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.name')
  .AddRule(TRules.Required())
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.name')
  .AddRule(TRules.Required())
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.name').AddRule(TRules.Required)
  .Field('body.name').AddRule(TRules.Required().SetMessage('Required validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.users.*.name')
  .AddRule(TRules.Required())
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.name`): `Jane Doe`
- Failing sample (`body.name`): ``

### Valid Request Payload

```json
{
  "name": "Jane Doe"
}
```

### Invalid Request Payload

```json
{
  "name": ""
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.name": [
      "The field body.name failed the Required rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Usually the first rule in a chain for mandatory fields.

## Related Rules

- `Required`, `RequiredIf`, `IfVal`, `Prohibited`
