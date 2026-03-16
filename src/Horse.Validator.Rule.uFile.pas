unit Horse.Validator.Rule.uFile;

interface

uses
  System.SysUtils,
  Horse.Validator.Rule.Base;

type
  /// <summary>
  ///   Valida se o campo corresponde a um arquivo enviado na requisição (multipart/form-data).
  /// </summary>
  /// <remarks>
  ///   Esta regra verifica apenas a presença do arquivo no upload. Regras subsequentes
  ///   como MimeTypes e Extensions devem ser usadas para validar as propriedades do arquivo.
  /// </remarks>
  TRuleFile = class(TRule)
  public
    /// <summary>Executa a validação da regra "File".</summary>
    function Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean; override;
  end;

implementation

{ TRuleFile }

function TRuleFile.Validate(const AFieldName, AValue: string; const ARequired: Boolean): Boolean;
begin
  // Esta regra opera sob a premissa de que o THorseValidator Core irá popular
  // o valor do campo com dados (em formato JSON string) se o arquivo for encontrado
  // na requisição, ou com uma string vazia caso contrário.
  //
  // Portanto, a validação de 'File' é análoga a uma validação de 'Required',
  // mas com uma mensagem de erro mais específica para o contexto de uploads.

  Result := not AValue.Trim.IsEmpty;

  if not Result then
    SetResultMessage(Format('O campo %s deve ser um arquivo.', [AFieldName]));
end;

end.
