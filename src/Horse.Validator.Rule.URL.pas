unit Horse.Validator.Rule.URL;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é uma string de URL bem formatada.
  /// </summary>
  /// <remarks>
  ///   Esta regra valida apenas o formato da URL (presença de scheme, host, etc.).
  ///   Ela não verifica se o domínio da URL está ativo. Para isso, use a regra <c>ActiveUrl</c>.
  /// </remarks>
  TRuleURL = class(TRule)
  public
    /// <summary>Executa a validação da regra "URL".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.Net.URLClient; // Para TURI

{ TRuleURL }

function TRuleURL.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LURI: TURI;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A validação é feita tentando-se analisar a string com a classe TURI.
  try
    LURI := TURI.Create(LValue);
    // Uma URL bem formada deve, no mínimo, ter um scheme e um host.
    Result := (not LURI.Scheme.IsEmpty) and (not LURI.Host.IsEmpty);
  except
    // Se TURI.Create levantar uma exceção, a string é mal formada.
    Result := False;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s não possui um formato de URL válido.', [AFieldName]));
end;

end.
