unit Horse.Validator.Rule.uString;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo é uma string.
  /// </summary>
  /// <remarks>
  ///   No contexto da biblioteca Horse Validator, onde todos os parâmetros da
  ///   requisição já são lidos como strings, esta regra atua principalmente
  ///   como um marcador de tipo. Ela sempre retornará 'True'.
  /// </remarks>
  TRuleString = class(TRule)
  public
    /// <summary>Executa a validação da regra "String".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleString }

function TRuleString.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // Como todos os valores de entrada no validador são tratados como strings por padrão,
  // esta regra simplesmente confirma esse fato e sempre passa na validação.
  // A verificação de conteúdo (se está vazio ou não) é responsabilidade da regra 'Required'.
  Result := True;
end;

end.
