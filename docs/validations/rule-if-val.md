# Validation: IfVal

[Back to Core Documentation](../README.md)

## Purpose

- Conditionally executes nested rules when a predicate evaluates to true.
- Category: `Utility`
- Category behavior: Supports presence, conditional, or orchestration-level validation semantics.

## Internal Reference

- Unit: `Horse.Validator.Rule.IfVal`
- Class: `TRuleIfVal`
- Inherits: `TRuleContextAware`
- Validation method: `function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;`
- Source file: `src/Horse.Validator.Rule.IfVal.pas`

## Constructors

- `constructor Create(const ACondition: TFunc<Boolean>; const ARules: array of IRule);`
- `constructor TRuleIfVal.Create(const ACondition: TFunc<Boolean>; const ARules: array of IRule);`

## Builder API

- `TRules.When`

## Available Signatures

- `class function When(const ACondition: TFunc<Boolean>; const ARules: array of IRule): IRule;`

## Parameters and Configuration Notes

- `Boolean`: toggles behavior mode, often increasing strictness.

## Basic Example

```pascal
THorseValidator.New(Req)
  .Field('body.discountCode')
  .AddRule(TRules.When(function: Boolean begin Result := True; end, [TRules.Required, TRules.String]))
  .Validate;
```

## Advanced Examples (Overloads and Combinations)

```pascal
THorseValidator.New(Req)
  .Field('body.discountCode')
  .AddRule(TRules.When(function: Boolean begin Result := True; end, [TRules.Required, TRules.String]))
  .Validate;
```

```pascal
THorseValidator.New(Req)
  .Field('body.discountCode').AddRule(TRules.Required)
  .Field('body.discountCode').AddRule(TRules.When(function: Boolean begin Result := True; end, [TRules.Required, TRules.String]).SetMessage('IfVal validation failed for this field.'))
  .Validate;
```

## Wildcard / Collection Scenario

```pascal
THorseValidator.New(Req)
  .Field('body.order.discountCode')
  .AddRule(TRules.When(function: Boolean begin Result := True; end, [TRules.Required, TRules.String]))
  .Validate;
```

## Passing vs Failing Samples

- Passing sample (`body.discountCode`): `PROMO10`
- Failing sample (`body.discountCode`): `INVALID`

### Valid Request Payload

```json
{
  "discountCode": "PROMO10"
}
```

### Invalid Request Payload

```json
{
  "discountCode": "INVALID"
}
```

### Expected Error Shape (Example)

```json
{
  "error": "Validation failed.",
  "validations": {
    "body.discountCode": [
      "The field body.discountCode failed the IfVal rule."
    ]
  }
}
```

## Edge Cases and Pitfalls

- Missing field behavior may depend on whether `TRules.Required` is also in the rule chain.
- For callback-based rules, make sure callback logic is deterministic and handles null/empty values safely.
- For wildcard fields, ensure payload structure is consistent (`array` vs `object`) before applying this rule.
- Meta-rule; nested rules run only when predicate returns true.

## Related Rules

- `Required`, `RequiredIf`, `IfVal`, `Prohibited`
