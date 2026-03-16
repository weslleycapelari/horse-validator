unit Horse.Validator.Middleware;

interface

uses
  System.SysUtils,
  Horse;

type
  /// <summary>Define o callback para interceptação customizada de exceções no middleware.</summary>
  /// <param name="E">A exceção capturada.</param>
  /// <param name="Req">O objeto da requisição.</param>
  /// <param name="Res">O objeto da resposta.</param>
  /// <param name="ASendDefaultResponse">Define se o middleware deve enviar a resposta padrão (JSON de erro).</param>
  TInterceptExceptionCallback = reference to procedure(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendDefaultResponse: Boolean);

  /// <summary>Registra o middleware de validação na aplicação Horse.</summary>
  function HandleValidator: THorseCallback; overload;

  /// <summary>Registra o middleware de validação com um callback de interceptação.</summary>
  function HandleValidator(const ACallback: TInterceptExceptionCallback): THorseCallback; overload;

implementation

uses
  System.JSON,
  Horse.Exception,
  Horse.Validator.Exception;

var
  GInterceptExceptionCallback: TInterceptExceptionCallback = nil;

procedure MiddlewareCallback(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LSendDefaultResponse: Boolean;
  LJSON: TJSONObject;
begin
  try
    Next();
  except
    on E: EHorseCallbackInterrupted do
      raise;

    on E: EHorseValidationException do
    begin
      LSendDefaultResponse := True;

      // Permite que o desenvolvedor intercepte o erro antes do envio.
      if Assigned(GInterceptExceptionCallback) then
        GInterceptExceptionCallback(E, Req, Res, LSendDefaultResponse);

      if LSendDefaultResponse then
      begin
        LJSON := E.ToJSONObject;
        // O Horse geralmente assume a propriedade do objeto JSON passado no Send<T>.
        Res.Send<TJSONObject>(LJSON).Status(Integer(E.Status));
      end;
    end;

//    on E: Exception do
//    begin
//      LSendDefaultResponse := True;
//
//      if Assigned(GInterceptExceptionCallback) then
//        GInterceptExceptionCallback(E, Req, Res, LSendDefaultResponse);
//
//      if LSendDefaultResponse then
//      begin
//        LJSON := TJSONObject.Create;
//        LJSON.AddPair('error', E.Message);
//        // Retorna 500 para erros não tratados explicitamente.
//        Res.Send<TJSONObject>(LJSON).Status(THTTPStatus.InternalServerError);
//      end;
//    end;
  end;
end;

function HandleValidator: THorseCallback;
begin
  Result := HandleValidator(nil);
end;

function HandleValidator(const ACallback: TInterceptExceptionCallback): THorseCallback;
begin
  GInterceptExceptionCallback := ACallback;
  Result := MiddlewareCallback;
end;

end.
