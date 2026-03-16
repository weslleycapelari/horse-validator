unit Horse.Validator.Rule.Exists;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo existe em uma determinada tabela do banco de dados.
  /// </summary>
  /// <remarks>
  ///   Esta regra é desacoplada da sua camada de dados. Ela requer uma função
  ///   de callback que implemente a lógica real da consulta SQL.
  /// </remarks>
  TRuleExists = class(TRule)
  strict private
    FTableName: string;
    FColumnName: string;
    FCallback: TExistsCallback;
  public
    /// <summary>
    ///   Cria uma nova instância da regra de validação 'Exists'.
    /// </summary>
    /// <param name="ATableName">O nome da tabela a ser consultada.</param>
    /// <param name="AColumnName">O nome da coluna a ser verificada.</param>
    /// <param name="ACallback">A função que executa a consulta no banco de dados.</param>
    constructor Create(const ATableName, AColumnName: string; const ACallback: TExistsCallback);

    /// <summary>Executa a validação da regra "Exists".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleExists }

constructor TRuleExists.Create(const ATableName, AColumnName: string; const ACallback: TExistsCallback);
begin
  inherited Create;
  if not Assigned(ACallback) then
    raise Exception.Create('Um callback válido deve ser fornecido para a regra Exists.');
  FTableName := ATableName;
  FColumnName := AColumnName;
  FCallback := ACallback;
end;

function TRuleExists.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Delega a lógica de consulta para o callback fornecido pelo usuário.
  // A validação passa se o callback retornar True (o registro existe).
  Result := FCallback(FTableName, FColumnName, LValue);

  if not Result then
    SetResultMessage(Format('O valor selecionado para o campo %s é inválido.', [AFieldName]));
end;

end.
