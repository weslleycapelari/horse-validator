unit Horse.Validator.Rule.Email;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um endereço de e-mail formatado corretamente.
  /// </summary>
  /// <remarks>
  ///   A validação primária é feita usando uma expressão regular. Opcionalmente, pode-se
  ///   habilitar a verificação de registros DNS (MX) para o domínio do e-mail.
  /// </remarks>
  TRuleEmail = class(TRule)
  strict private
    FCheckDNS: Boolean;
  public
    /// <summary>
    ///   Cria uma nova instância da regra de validação de e-mail.
    /// </summary>
    /// <param name="ACheckDNS">Se True, tentará verificar a existência de um registro MX para o domínio.</param>
    constructor Create(const ACheckDNS: Boolean = False);

    /// <summary>Executa a validação.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.Classes,
  System.RegularExpressions,
  IdDNSResolver;

{ TRuleEmail }

constructor TRuleEmail.Create(const ACheckDNS: Boolean = False);
begin
  inherited Create;
  FCheckDNS := ACheckDNS;
end;

function TRuleEmail.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
const
  // Regex amplamente utilizado para validação de formato de e-mail.
  C_EMAIL_REGEX = '\A[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z';
var
  LValue: string;
  LDomain: string;
  LDNS: TIdDNSResolver;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // --- Passo 1: Validação do formato via Expressão Regular ---
  if not TRegEx.IsMatch(LValue, C_EMAIL_REGEX) then
  begin
    SetResultMessage(Format('O campo %s não é um endereço de e-mail válido.', [AFieldName]));
    Exit(False);
  end;

  // Se a verificação de DNS não for solicitada, a validação termina com sucesso aqui.
  if not FCheckDNS then
    Exit(True);

  // --- Passo 2: Verificação de DNS (MX Record) ---
  // Extrai o domínio da parte do e-mail após o '@'.
  LDomain := Copy(LValue, Pos('@', LValue) + 1, Length(LValue));

  LDNS := TIdDNSResolver.Create(nil);
  try
    try
      LDNS.Host := '8.8.8.8'; // DNS público para consistência.
      LDNS.QueryType := [qtMX];
      LDNS.Resolve(LDomain);

      // A validação passa se pelo menos um registro MX for encontrado.
      Result := LDNS.QueryResult.Count > 0;

      if not Result then
        SetResultMessage(Format('O domínio do e-mail no campo %s parece não ser válido.', [AFieldName]));
    except
      // Qualquer exceção de rede (sem internet, timeout, host não encontrado) resulta em falha.
      Result := False;
      SetResultMessage(Format('Não foi possível verificar o domínio do e-mail no campo %s.', [AFieldName]));
    end;
  finally
    LDNS.Free;
  end;
end;

end.
