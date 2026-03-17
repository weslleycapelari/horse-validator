unit Horse.Validator.Interfaces;

interface

uses
  System.SysUtils, System.JSON;

type
  // Declaração antecipada para uso nos callbacks
  IValidator = interface;

  /// <summary>Define a função responsável por prover o valor de um campo baseado em sua chave (dot notation).</summary>
  TValueProvider = reference to function(const AKey: string): string;

  /// <summary>Define o callback para validação de senhas, desacoplando a lógica de negócio da regra.</summary>
  TCheckPasswordCallback = reference to function(const APasswordToCheck: string): Boolean;

  /// <summary>Define o callback para verificação de unicidade no banco de dados.</summary>
  TUniqueCallback = reference to function(const ATableName, AColumnName, AValue: string; const AIgnoreId: string): Boolean;

  /// <summary>Define o callback para verificação de existência de registro no banco de dados.</summary>
  TExistsCallback = reference to function(const ATableName, AColumnName, AValue: string): Boolean;

  /// <summary>Define o callback para aplicar um escopo de validação (usado em Arrays e Condicionais).</summary>
  TValidationScopeCallback = reference to procedure(const AValidator: IValidator);

  /// <summary>Define o contrato fundamental que toda regra de validação deve seguir.</summary>
  IRule = interface
    ['{E1CC8D57-6F26-4F10-A8AA-6DBEB78EA05E}']
    /// <summary>Executa a lógica de validação da regra.</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;

    /// <summary>Retorna a mensagem de erro associada à regra.</summary>
    function GetMessage: string;

    /// <summary>Permite customizar a mensagem de erro da instância da regra (Fluent Interface).</summary>
    function SetMessage(const AMessage: string): IRule;

    /// <summary>Propriedade para leitura da mensagem de erro formatada.</summary>
    property Message: string read GetMessage;
  end;

  /// <summary>Define o contrato para regras que necessitam acessar outros dados da requisição.</summary>
  IRuleContextAware = interface
    ['{5ACD9922-5B0A-4E76-AE0D-915E3DD2041A}']
    /// <summary>Injeta o provedor de valores na regra.</summary>
    procedure SetValueProvider(const AProvider: TValueProvider);
    /// <summary>Injeta o caminho completo do campo que está sendo validado no momento.</summary>
    procedure SetCurrentFieldPath(const APath: string);
  end;

  /// <summary>Define a interface pública do validador para permitir composição e aninhamento.</summary>
  IValidator = interface
    ['{887705C1-3221-460B-A57E-70C71647413F}']
    /// <summary>Define o campo atual (contexto) para a aplicação das regras subsequentes.</summary>
    function Field(const AFieldName: string): IValidator;

    /// <summary>Adiciona uma regra ao campo atualmente selecionado.</summary>
    function AddRule(const ARule: IRule): IValidator; overload;

    /// <summary>Adiciona múltiplas regras ao campo atualmente selecionado.</summary>
    function AddRule(const ARules: array of IRule): IValidator; overload;

    /// <summary>Define um bloco de validação condicional.</summary>
    function IfVal(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator; overload;
    function IfVal(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator; overload;

    /// <summary>Define um escopo de validação para itens de um array ou objeto aninhado.</summary>
    function Scope(const ACallback: TValidationScopeCallback): IValidator;

    function GroupWhen(const ACondition: Boolean; const ACallback: TValidationScopeCallback): IValidator; overload;
    function GroupWhen(const ACondition: TFunc<Boolean>; const ACallback: TValidationScopeCallback): IValidator; overload;

    /// <summary>
    ///   Executa todo o processo de validação.
    ///   Levanta EHorseValidationException em caso de falha.
    /// </summary>
    procedure Validate;

    /// <summary>JSON mestre de validação. Contém todos os valores e chaves da requisição, usados para validação.</summary>
    function GetMasterJSON: TJSONObject;
  end;

implementation

end.
