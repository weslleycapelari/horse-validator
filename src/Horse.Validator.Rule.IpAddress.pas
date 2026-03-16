unit Horse.Validator.Rule.IpAddress;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é um endereço de IP válido (IPv4 ou IPv6).
  /// </summary>
  TRuleIpAddress = class(TRule)
  public
    /// <summary>Executa a validação da regra "IpAddress".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

uses
  System.Net.Socket; // Para TIPAddress

{ TRuleIpAddress }

function TRuleIpAddress.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
  LIPAddress: TIPAddress; // Variável de saída para a função TryParse
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // A função TIPAddress.TryParse é a forma canônica de validar um endereço IP.
  // Ela retorna True se a string for um endereço IPv4 ou IPv6 válido.
  try
    LIPAddress := TIPAddress.Create(LValue);
    Result := True;
  except
    Result := False;
  end;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um endereço de IP válido.', [AFieldName]));
end;

end.
