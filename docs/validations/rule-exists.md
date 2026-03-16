# Validation: Exists

[Back to Core Documentation](../README.md)

## Purpose

- Validates that a referenced value exists using a callback (typically database-backed).
- Category: `Database`
- Category behavior: Delegates checks to callback-based integration with persistence/database.

## Internal Reference

- Unit: `Horse.Validator.Rule.Exists`
- Class: `TRuleExists`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Exists.pas`

## Constructors

- `constructor Create(const ATableName, AColumnName: string; const ACallback: TExistsCallback);`
- `constructor TRuleExists.Create(const ATableName, AColumnName: string; const ACallback: TExistsCallback);`

## Builder API

- `TRules.Exists`

## Available Signatures

- `class function Exists(const ATableName, AColumnName: string; const ACallback: TExistsCallback): IRule;`

## Parameters and Configuration Notes

- `TExistsCallback`: callback should be idempotent and fast; avoid expensive queries.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.roleId')
  .AddRule(TRules.Exists('roles', 'id', ExistsCallback))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.roleId')
  .AddRule(TRules.Exists('roles', 'id', ExistsCallback))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.roleId').AddRule(TRules.Required)
  .Field('body.roleId').AddRule(TRules.Exists('roles', 'id', ExistsCallback).SetMessage('Exists validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.users.*.roleId')
  .AddRule(TRules.Exists('roles', 'id', ExistsCallback))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.roleId`): `existing key`
- Failing sample (`body.roleId`): `missing key`

### Valid Request Payload

```json
{
  "roleId": "existing key"
}
```

### Invalid Request Payload

```json
{
  "roleId": "missing key"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.roleId": [
      "The field body.roleId failed the Exists rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Useful for foreign-key-like integrity checks in requests.

## Related Rules

- `Exists`, `Unique`, `Confirmed`, `CurrentPassword`
