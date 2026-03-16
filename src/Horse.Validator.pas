unit Horse.Validator;

interface

uses
  Horse,
  Horse.Validator.Core,
  Horse.Validator.Builder,
  Horse.Validator.Middleware,
  Horse.Validator.Exception,
  Horse.Validator.Interfaces,
  Horse.Validator.Types,
  Horse.Validator.Rule.Base;

type
  /// <summary>Interface principal do validador, utilizada para encadeamento de regras (Fluent Interface).</summary>
  IValidator = Horse.Validator.Interfaces.IValidator;

  /// <summary>Classe concreta do validador, responsável pela orquestração.</summary>
  THorseValidator = Horse.Validator.Core.THorseValidator;

  /// <summary>Factory (Builder) contendo as regras de validação disponíveis.</summary>
  TRules = Horse.Validator.Builder.TValidationBuilder;

  /// <summary>Exceção lançada quando ocorre falha na validação.</summary>
  EHorseValidationException = Horse.Validator.Exception.EHorseValidationException;

  /// <summary>Contrato para implementação de regras customizadas.</summary>
  IRule = Horse.Validator.Interfaces.IRule;

  /// <summary>Classe base para criação de novas regras de validação.</summary>
  TRule = Horse.Validator.Rule.Base.TRule;

  /// <summary>Tipo de callback para interceptação avançada de exceções no middleware.</summary>
  TInterceptExceptionCallback = Horse.Validator.Middleware.TInterceptExceptionCallback;

  /// <summary>Tipo de callback para validação de escopo (arrays ou objetos).</summary>
  TValidationScopeCallback = Horse.Validator.Interfaces.TValidationScopeCallback;

/// <summary>Registra o middleware de validação no Horse.</summary>
function HandleValidator: THorseCallback; overload;

/// <summary>Registra o middleware de validação no Horse com callback de interceptação de erros.</summary>
function HandleValidator(const ACallback: TInterceptExceptionCallback): THorseCallback; overload;

implementation

function HandleValidator: THorseCallback;
begin
  Result := Horse.Validator.Middleware.HandleValidator();
end;

function HandleValidator(const ACallback: TInterceptExceptionCallback): THorseCallback;
begin
  Result := Horse.Validator.Middleware.HandleValidator(ACallback);
end;

end.
