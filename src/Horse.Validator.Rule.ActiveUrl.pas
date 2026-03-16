unit Horse.Validator.Rule.ActiveUrl;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é uma URL ativa, verificando seu formato e a existência de registro DNS.
  /// </summary>
  /// <remarks>
  ///   Verifica se o esquema é 'http' ou 'https' e realiza uma consulta DNS (A ou AAAA)
  ///   para confirmar se o domínio é resolvível.
  /// </remarks>
  TRuleActiveUrl = class(TRule)
  public
    /// <summary>Executa a validação da regra "ActiveUrl".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.Classes,
  System.Net.URLClient, // Para TURI
  IdDNSResolver;        // Para consulta DNS (Indy)

{ TRuleActiveUrl }

function TRuleActiveUrl.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LURI: TURI;
  LDNS: TIdDNSResolver;
  LHost: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // --- Passo 1: Validação de Sintaxe da URL ---
  try
    LURI := TURI.Create(LValue);

    // Verifica se o protocolo é seguro ou padrão web.
    if (not SameText(LURI.Scheme, 'http')) and (not SameText(LURI.Scheme, 'https')) then
    begin
      SetResultMessage(Format('O campo %s deve ser uma URL válida com protocolo http ou https.', [AFieldName]));
      Exit(False);
    end;

    // Verifica se existe um host (domínio/IP).
    if LURI.Host.IsEmpty then
    begin
      SetResultMessage(Format('O campo %s deve ser uma URL válida com um host definido.', [AFieldName]));
      Exit(False);
    end;

    LHost := LURI.Host;
  except
    // Se TURI.Create falhar, a string não é uma URL válida.
    SetResultMessage(Format('O campo %s não possui um formato de URL válido.', [AFieldName]));
    Exit(False);
  end;

  // --- Passo 2: Verificação de DNS (Atividade) ---
  LDNS := TIdDNSResolver.Create(nil);
  try
    try
      // Utiliza o Google Public DNS para a resolução.
      LDNS.Host := '8.8.8.8';
      LDNS.QueryType := [qtA, qtAAAA]; // Procura registros IPv4 ou IPv6.
      LDNS.Resolve(LHost);

      // Se obteve resposta com registros, o domínio está ativo.
      Result := LDNS.QueryResult.Count > 0;

      if not Result then
        SetResultMessage(Format('O domínio "%s" no campo %s não possui registros DNS ativos.', [LHost, AFieldName]));
    except
      // Erros de timeout ou host não encontrado geram exceção no Indy.
      Result := False;
      SetResultMessage(Format('Não foi possível conectar ao domínio "%s" no campo %s.', [LHost, AFieldName]));
    end;
  finally
    LDNS.Free;
  end;
end;

end.
