# Validation: Unique

[Back to Core Documentation](../README.md)

## Purpose

- Validates that a value is unique using a callback (typically database-backed).
- Category: `Database`
- Category behavior: Delegates checks to callback-based integration with persistence/database.

## Internal Reference

- Unit: `Horse.Validator.Rule.Unique`
- Class: `TRuleUnique`
- Inherits: `TRule`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.Unique.pas`

## Constructors

- `constructor Create(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string = '');`
- `constructor TRuleUnique.Create(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string);`

## Builder API

- `TRules.Unique`

## Available Signatures

- `class function Unique(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string = ''): IRule;`

## Parameters and Configuration Notes

- `TUniqueCallback`: callback should reflect unique index semantics used in persistence.
- `string`: can represent field references, operators, table/column names, or patterns depending on rule.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.email')
  .AddRule(TRules.Unique('users', 'email', UniqueCallback))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.email')
  .AddRule(TRules.Unique('users', 'email', UniqueCallback))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.email')
  .AddRule(TRules.Unique('users', 'email', UniqueCallback, '42'))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.email').AddRule(TRules.Required)
  .Field('body.email').AddRule(TRules.Unique('users', 'email', UniqueCallback).SetMessage('Unique validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.users.*.email')
  .AddRule(TRules.Unique('users', 'email', UniqueCallback))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.email`): `not found in DB`
- Failing sample (`body.email`): `already in DB`

### Valid Request Payload

```json
{
  "email": "not found in DB"
}
```

### Invalid Request Payload

```json
{
  "email": "already in DB"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.email": [
      "The field body.email failed the Unique rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Uses callback, so quality depends on query/index strategy.

## Related Rules

- `Exists`, `Unique`, `Confirmed`, `CurrentPassword`
