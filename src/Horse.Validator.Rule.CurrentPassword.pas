unit Horse.Validator.Rule.CurrentPassword;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se a senha fornecida corresponde à senha atual do usuário autenticado.
  /// </summary>
  /// <remarks>
  ///   Esta regra é desacoplada da sua lógica de negócio. Ela requer que você
  ///   forneça uma função de callback no construtor. Esta função é responsável
  ///   por pegar a senha da requisição e compará-la com a senha (geralmente um hash)
  ///   do usuário logado, retornando verdadeiro ou falso.
  /// </remarks>
  TRuleCurrentPassword = class(TRule)
  strict private
    FCallback: TCheckPasswordCallback;
  public
    /// <summary>
    ///   Cria uma nova instância da regra de validação.
    /// </summary>
    /// <param name="ACallback">A função que implementa a lógica de verificação da senha.</param>
    constructor Create(const ACallback: TCheckPasswordCallback);

    /// <summary>Executa a validação da regra "CurrentPassword".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleCurrentPassword }

constructor TRuleCurrentPassword.Create(const ACallback: TCheckPasswordCallback);
begin
  inherited Create;
  if not Assigned(ACallback) then
    raise Exception.Create('Um callback válido deve ser fornecido para a regra CurrentPassword.');
  FCallback := ACallback;
end;

function TRuleCurrentPassword.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // Se o campo não for obrigatório e estiver vazio, a regra não se aplica.
  if not ARequired and AValue.IsEmpty then
    Exit(True);

  // Delega a lógica de validação para a função de callback fornecida pelo usuário.
  Result := FCallback(AValue);

  if not Result then
    SetResultMessage('A senha informada não corresponde à sua senha atual.');
end;

end.
