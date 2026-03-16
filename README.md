# Horse Validator

[![License](https://img.shields.io/github/license/weslleycapelari/horse-validator)](LICENSE)
[![Release](https://img.shields.io/github/v/release/weslleycapelari/horse-validator)](https://github.com/weslleycapelari/horse-validator/releases)

A powerful validation middleware for the [Horse](https://github.com/HashLoad/horse) framework, with fluent rules, nested scope validation, wildcard support for arrays, and callback-based integrations for database/business checks.

## Overview

Horse Validator was built to make request validation predictable, expressive, and easy to maintain in Delphi APIs.

It centralizes data from body, query, params, and headers into a unified validation context, then executes fluent rules against field paths (including wildcard paths such as `body.users.*.email`).

The project includes:

- A fluent builder API (`TRules`) with dozens of built-in validation rules.
- A validation core (`THorseValidator`) with path resolution and wildcard expansion.
- Middleware integration for automatic HTTP validation error responses.
- Exception and error payload handling focused on API scenarios.
- Context-aware rules that can compare values across fields.

## Documentation

Detailed rule-by-rule documentation is available here:

- Core + full validation index: [docs/README.md](docs/README.md)
- Detailed validations folder: [docs/validations](docs/validations)

## ? Main Features

- Fluent validation API with `Field`, `AddRule`, `Scope`, `IfVal`, and `Validate`.
- 70+ built-in rules for strings, numbers, dates, arrays, files, database checks, and utility behaviors.
- Wildcard validation support (`*`) for nested arrays/objects.
- Conditional validation (group and field-level) for dynamic business rules.
- Context-aware comparisons (`Same`, `Different`, `GreaterThan`, `Before`, etc.).
- Extensible architecture via custom rules implementing `IRule`.
- Built-in middleware exception handling with structured JSON response output.
- Delphi-friendly design with zero runtime reflection overhead in route definitions.

## ?? Installation

Install with [Boss](https://github.com/HashLoad/boss):

```sh
boss install github.com/weslleycapelari/horse-validator
```

Or clone the repository and add the `src` folder to your Delphi Library Path.

## ?? Quick Start

```delphi
program Project1;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.Jhonson,
  Horse.Validator;

begin
  THorse.Use(Jhonson);
  THorse.Use(HandleValidator);

  THorse.Post('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      THorseValidator.New(Req)
        .Field('body.name').AddRule(TRules.Required)
        .Field('body.email').AddRule(TRules.Required)
        .Field('body.email').AddRule(TRules.Email(True))
        .Field('body.age').AddRule(TRules.Integer)
        .Field('body.age').AddRule(TRules.Min(18))
        .Validate;

      Res.Status(201).Send('User is valid');
    end);

  THorse.Listen(9000);
end.
```

## ??? Advanced Usage

### 1. Validating Arrays with Wildcards

```delphi
THorseValidator.New(Req)
  .Field('body.users.*.name').AddRule(TRules.Required)
  .Field('body.users.*.email').AddRule(TRules.Required)
  .Field('body.users.*.email').AddRule(TRules.Email)
  .Field('body.users.*.age').AddRule(TRules.Integer)
  .Field('body.users.*.age').AddRule(TRules.Min(18))
  .Validate;
```

### 2. Conditional Validation

```delphi
THorseValidator.New(Req)
  .Field('body.documentType').AddRule(TRules.Required)
  .Field('body.document')
    .AddRule(TRules.RequiredIf('body.documentType', '=', 'CPF', [TRules.CPF]))
  .Validate;
```

### 3. Scope-Based Validation

```delphi
THorseValidator.New(Req)
  .Field('body.items')
  .Scope(
    procedure(const V: IValidator)
    begin
      V.Field('productId').AddRule(TRules.Required);
      V.Field('quantity').AddRule(TRules.Integer);
      V.Field('quantity').AddRule(TRules.Min(1));
    end
  )
  .Validate;
```

### 4. Database-Backed Rules (Callbacks)

```delphi
THorseValidator.New(Req)
  .Field('body.roleId')
    .AddRule(TRules.Exists('roles', 'id',
      function(const ATableName, AColumnName, AValue: string): Boolean
      begin
        Result := True; // Replace with your real lookup
      end))
  .Field('body.email')
    .AddRule(TRules.Unique('users', 'email',
      function(const ATableName, AColumnName, AValue: string; const AIgnoreId: string): Boolean
      begin
        Result := True; // Replace with your real uniqueness check
      end))
  .Validate;
```

## Validation Error Response

When validation fails, Horse Validator raises `EHorseValidationException`, and middleware returns a JSON response similar to this:

```json
{
  "error": "A validação dos dados falhou.",
  "validations": {
    "body.email": [
      "O campo body.email deve ser um e-mail válido."
    ],
    "body.age": [
      "O campo body.age deve ser maior ou igual a 18."
    ]
  }
}
```

## Project Structure

```text
src/
  Horse.Validator.pas
  Horse.Validator.Core.pas
  Horse.Validator.Builder.pas
  Horse.Validator.Interfaces.pas
  Horse.Validator.Collection.pas
  Horse.Validator.Types.pas
  Horse.Validator.Exception.pas
  Horse.Validator.Middleware.pas
  Horse.Validator.Rule.*.pas

docs/
  README.md
  validations/
```

## ?? Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m "Add your feature"`).
4. Push the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

If possible, open an issue first for larger changes.

## ?? License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
