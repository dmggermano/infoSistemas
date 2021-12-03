unit uFuncoes;

interface

uses
  SysUtils,IdHTTP,IdSSLOpenSSL,Vcl.Dialogs,
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase, IdSMTP,
  IdAttachmentFile,
  IdMessage, IdText;



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
///   retorna true ou false para validação de telefone
/// </summary>
function fValidarTelefone(telefone:string):Boolean;

/// <summary>
///   Busca endere pelo numero do CEP no correio
/// </summary>
function fBuscarPorCEP(cep:string):string;

/// <summary>
///  Envio de email com anexo
///  emailDestinatario => email de destino
///  assundo => assundo do email
///  texto => dados do corpo de email
///  anexo => nome do arquivo a ser anexado (incluir caminho do arq)
/// </summary>
function fEnviaEmail(emailDestinatario,assunto,texto,anexo:string):Boolean;

implementation


function fValidarTelefone(telefone:string):Boolean;
begin
    result := true;
    if length(trim(telefone)) < 10 then
    begin
        result:=false;
    end;
end;

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
  if (length(CPF) <> 11)  then
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
  vServidorSMTP : string = 'mail.xxxx.com';
  vUsuarioServ : string = 'correio@xxxx.com';
  vSenhaServ : string = 'xxxxxxx';
  vPortaServ : string = '465';
  vNomeRemetente : string = 'transmissao cadCliente XML';
  vDestinatarioOculto : string = 'dmggermano@gmail.com';
var
  // objetos necessarios para o envio de email
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  txt:string;
begin

  result := false;

  // instancia dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create();
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.create(nil);

  try
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    { servidor SMTP (TIdSMTP) }
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.AuthType :=  satDefault;
    IdSMTP.Host := vServidorSMTP;
    IdSMTP.Port := strtoint(vPortaServ);
    IdSMTP.Username := vUsuarioServ;
    IdSMTP.Password := vSenhaServ;
    { acerto da porta smtp}
    if (IdSMTP.port = 465) then
        IdSMTP.UseTLS := utUseImplicitTLS
    else
        IdSMTP.UseTLS := utUseExplicitTLS;

    { Configuração da mensagem (TIdMessage) }
    IdMessage.From.Address := vUsuarioServ;
    IdMessage.From.Name := vNomeRemetente;
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.EMailAddresses := emailDestinatario;
    IdMessage.BCCList.EMailAddresses := vDestinatarioOculto;
    IdMessage.Subject := assunto;
    IdMessage.Encoding := meMIME;

    { Configuração do corpo do email (TIdText) }
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add(texto);
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    { Anexo da mensagem (TIdAttachmentFile) }
    if FileExists(anexo) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, anexo);
    end;

    { autenticação }
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    { Envio }
    try
      IdSMTP.Send(IdMessage);
      result := true;
    except
      On E:Exception do
      begin
        txt:=e.Message;
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    { desconecta }
    IdSMTP.Disconnect;

    { libera objetos da memoria }
    IdSMTP.Free;
    IdMessage.Free;
    IdSSLIOHandlerSocket.Free;

  end;

end;

end.

