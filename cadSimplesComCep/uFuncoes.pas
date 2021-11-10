unit uFuncoes;

interface

uses
  SysUtils,IdHTTP,IdSSLOpenSSL,Vcl.Dialogs,
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase, IdSMTP,
  IdAttachmentFile,

  // IdSSLOpenSSL,
  IdMessage, IdText;
//  IdExplicitTLSClientServerBase



/// <summary>
///   retorna true ou false para validação de CPF
/// </summary>
function fValidarCPF(cpf:string):Boolean;

/// <summary>
///   executa tentativa de criacao de Diretorio/pasta
/// </summary>
function fCriaDiretorio(diretorio:string):Boolean;

/// <summary>
///   retorna string com apenas numeros de string
/// </summary>
function fSoNumeros(soNumeros:string):string;

/// <summary>
///   retorna true ou false para validação de EMAIL
/// </summary>
function fValidarEmail(email:string):Boolean;

/// <summary>
///   Busca endere pelo numero do CEP no correio
/// </summary>
function fBuscarPorCEP(cep:string):string;

/// <summary>
// - Rotina do botao abaixo testa a conexao com o servidor SMTP
// - Se a configuração do servidor SMTP estiver correta é imediatamente exibida
// uma mensagem de conexao com exito
// - Caso contrário quando a conexão é testada demora-se muito para obter um
// retorno de resposta e é exibida uma mensagem de erro ao conectar no servidor SMTP procedure
/// </summary>
function fEnviaEmail(emailDestinatario,assunto,texto,anexo:string):Boolean;



implementation

function fSoNumeros(soNumeros:string):string;
var
  i:integer;
begin
    result:='';
    for i := 1 to length(soNumeros) do
    begin
      if ((soNumeros[i] in ['0'..'9']) = true) then
          result := result + copy(soNumeros,i,1);
    end;
end;

function fValidarCPF(cpf:string):Boolean;
var
  soma,peso,i,digito1,digito2:integer;
begin
try
  if ((CPF = '00000000000') or (CPF = '11111111111') or
      (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or
      (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or
      (length(CPF) <> 11))  then
            result := false;

{ *--  1º. Digito Verificador --* }
    soma := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
      soma := soma + (strtoint(CPF[i]) * peso);
      peso := peso - 1;
    end;
    digito1 := 11 - (soma mod 11);
    if ((digito1 = 10) or (digito1 = 11)) then
       digito1 := 0;

{ *--  2º. Digito Verificador --* }
    soma := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      soma := soma + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;
    digito2 := 11 - (soma mod 11);
    if ((digito2 = 10) or (digito2 = 11)) then
       digito2 := 0;

{ Verifica os digitos }
    if ((inttostr(digito1) = CPF[10]) and (inttostr(digito2) = CPF[11])) then
       result := true
    else
      result := false;
except
  result := false;
end;

end;

function fValidarEmail(email:string):Boolean;
begin

  if (pos('@',email) <= 0) then
    result:=false
  else
    result:=true;

end;

function fBuscarPorCEP(cep:string):string;
const
  _url = 'https://viacep.com.br/ws/';
  _urlCompl = '/json/';
var
  txt:string;
  xidhttp1: TIdHTTP;
  xidSSL: TIdSSLIOHandlerSocketOpenSSL;
  xjson: string;
begin
  txt:=_url+cep+_urlCompl;
  xidHTTP1 := TIdHTTP.Create;
  try
    try
      xidSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      xidSSL.SSLOptions.Method := sslvSSLv23;
      xidSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
      //criação do request para a API (necessário para atribuir  UserAgent)
      xidHTTP1.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
      xidHTTP1.IOHandler := xidSSL;
      //popula o xjson com os dados da API
      xjson := xIdHTTP1.Get(txt);
    finally
      xidSSL.Free;
    end;
  finally
    xIdHTTP1.Free;
  end;
  result:=xjson;
end;

function fCriaDiretorio(diretorio:string):Boolean;
begin
  result:=true;
  try
    if not DirectoryExists(diretorio) then
       ForceDirectories(diretorio);
  except
    result := false;
  end;
end;


function fEnviaEmail(emailDestinatario,assunto,texto,anexo:string):Boolean;
const
  vServidorSMTP : string = 'smtp.gmail.com';
  vUsuarioServ : string = 'dmggermanoteste@gmail.com';
  vSenhaServ : string = 'Teste@148';
  vPortaServ : string = '587';
var
  vIdSMTP : TIdSMTP;
  vIdMessage : TIdMessage;
  vIdAttachment : TIdAttachmentFile;
begin
    if (length(trim(anexo)) > 0) then
    begin
      if FileExists(anexo) = false then
      begin
        showmessage('Arquivo anexo não localizado.'+#13+'E-Mail cancelado.');
        result := false;
        exit;
      end;
    end;
    try
        try
          vIdSMTP := TIdSMTP.create();
          vIdSMTP.Host  := vServidorSMTP;
          vIdSMTP.Username := vUsuarioServ;
          vIdSMTP.Password := vSenhaServ;
          vIdSMTP.Port  := strtoint(vPortaServ);
          vIdSMTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL(nil);

          { autenticacao }
    //      if chkServerRequerAut.Checked then
    //          vIdSMTP.AuthenticationType:= atLogin
    //      else
    //          vIdSMTP.AuthenticationType:= atNone;

          //-- conexao segura SSL
    //      if chkSSL.Checked then
    //          vIdSMTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL;
    //      else
    //          IdSMTP1.IOHandler := nil;
          vIdMessage := tIdMessage.Create();
    //      vIdMessage.MessageParts.Clear;
          vIdAttachment := TIdAttachmentFile.Create(nil);
          vIdAttachment.Create(vIdMessage.MessageParts, anexo); // myFileXML);

          //-- ORIGEM
          vIdMessage.From.Address := vUsuarioServ;
          vIdMessage.Subject  := Trim(assunto);
          vIdMessage.Body.Text  := Trim(texto);

          //-- DESTINO
          vIdMessage.Recipients.EMailAddresses := Trim(emailDestinatario);
          vIdMessage.BccList.EMailAddresses  := '';
          vIdMessage.CCList.EMailAddresses  := 'dmggermano@gmail.com';

          if NOT vIdSMTP.Connected then
              vIdSMTP.Connect; // .Connect(2000);

          if vIdSMTP.Connected then
          begin
              vIdSMTP.Authenticate;
              vIdSMTP.Send(vIdMessage);

    //      Application.ProcessMessages;

              vIdSMTP.Disconnect;
          end;

        finally
          vIdSMTP.Free;
          vIdMessage.Free;
        end;
    except
        begin
            result := false;
            exit;
        end;
    end;
    result := true;
end;

end.
