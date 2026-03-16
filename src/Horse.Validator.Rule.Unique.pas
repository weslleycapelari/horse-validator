unit Horse.Validator.Rule.Unique;

interface

uses
  System.SysUtils,
  Horse.Validator.Interfaces,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o valor do campo é único em uma determinada tabela do banco de dados.
  /// </summary>
  /// <remarks>
  ///   Esta regra permite especificar um ID a ser ignorado, o que é essencial
  ///   para cenários de atualização de registros. Ela é desacoplada da camada de dados
  ///   e requer uma função de callback para executar a consulta real.
  /// </remarks>
  TRuleUnique = class(TRule)
  strict private
    FTableName: string;
    FColumnName: string;
    FCallback: TUniqueCallback;
    FIgnoreId: string;
  public
    /// <summary>
    ///   Cria uma nova instância da regra de validação 'Unique'.
    /// </summary>
    /// <param name="ATableName">O nome da tabela a ser consultada.</param>
    /// <param name="AColumnName">O nome da coluna a ser verificada.</param>
    /// <param name="ACallback">A função que executa a consulta no banco de dados.</param>
    /// <param name="AIgnoreId">Opcional. O ID do registro a ser ignorado na verificação.</param>
    constructor Create(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string = '');

    /// <summary>Executa a validação da regra "Unique".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleUnique }

constructor TRuleUnique.Create(const ATableName, AColumnName: string; const ACallback: TUniqueCallback; const AIgnoreId: string);
begin
  inherited Create;
  if not Assigned(ACallback) then
    raise Exception.Create('Um callback válido deve ser fornecido para a regra Unique.');
  FTableName := ATableName;
  FColumnName := AColumnName;
  FCallback := ACallback;
  FIgnoreId := AIgnoreId;
end;

function TRuleUnique.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
var
  LValue: string;
begin
  LValue := AValue.Trim;

  // Se o campo não é obrigatório e está vazio, a regra não se aplica.
  if not ARequired and LValue.IsEmpty then
    Exit(True);

  // Delega a lógica de consulta para o callback, incluindo o ID a ser ignorado.
  // A validação passa se o callback retornar True (o valor é único).
  Result := FCallback(FTableName, FColumnName, LValue, FIgnoreId);

  if not Result then
    SetResultMessage(Format('O valor do campo %s já está em uso.', [AFieldName]));
end;

end.
