unit cadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons,Vcl.StdCtrls, Vcl.Mask, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfCadClienteComCep = class(TForm)
    pnlTitulo: TPanel;
    pnlRodape: TPanel;
    pnlNavigator: TPanel;
    pnlGrid: TPanel;
    pnlCentral: TPanel;
    splPnlCentral: TSplitter;
    dbgfdCliente: TDBGrid;
    dbnfdCliente: TDBNavigator;
    dsCadCliente: TDataSource;
    pnlBarraButton: TPanel;
    btnIncluir: TSpeedButton;
    fdCliente: TFDMemTable;
    fdClientenome: TStringField;
    fdClienteidentidade: TStringField;
    fdClientecpf: TStringField;
    fdClientetelefone: TStringField;
    fdClienteemail: TStringField;
    fdClientecep: TStringField;
    fdClientelogradouro: TStringField;
    fdClientenumero: TStringField;
    fdClientebairro: TStringField;
    fdClientecidade: TStringField;
    fdClientecomplemento: TStringField;
    fdClienteestado: TStringField;
    fdClientepais: TStringField;
    lblNome: TLabel;
    lblIdentidade: TLabel;
    lblCPF: TLabel;
    lblTelefone: TLabel;
    lblEMail: TLabel;
    lblCEP: TLabel;
    lblLogradouro: TLabel;
    lblCidade: TLabel;
    lblUF: TLabel;
    lblPais: TLabel;
    lblBairro: TLabel;
    edtTelefone: TMaskEdit;
    edtCPF: TMaskEdit;
    edtEmail: TEdit;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtLogradouro: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    edtPais: TEdit;
    edtCEP: TMaskEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    fdClientetransmissao: TStringField;
    lblEmailDestinatario: TLabel;
    edtEmailDestinatario: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtUFExit(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNomeDblClick(Sender: TObject);
    procedure dbgfdClienteDblClick(Sender: TObject);
  private
    procedure limpaEdit;
    function fValidarDados: Boolean;
    function incluiReg: Boolean;
    function transmitirDados: Boolean;
    function criaXML: Boolean;
    function gravaOKEnvio: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCadClienteComCep: TfCadClienteComCep;

implementation

{$R *.dfm}

uses uFuncoes, XMLDoc, XMLIntf;

// incli dados na tabela/memoria
procedure TfCadClienteComCep.edtCEPExit(Sender: TObject);
var
  xobj: TJSONObject;
  mmJson : TMemo;
begin

  try
    mmJson := tmemo.Create(nil);
    mmJson.text:=ufuncoes.fBuscarPorCEP(edtCEP.Text);
//  String vai para Objeto Json ==> capturar os valores
    xobj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmJson.Text),0) as TJSONObject;
    try
//      edtCep.text := ufuncoes.fSoNumeros(xobj.GetValue<string>('cep'));
      edtLogradouro.text := xobj.GetValue<string>('logradouro');
      edtComplemento.text := xobj.GetValue<string>('complemento');
      edtBairro.text := xobj.GetValue<string>('bairro');
      edtCidade.text := xobj.GetValue<string>('localidade');
      edtUF.text := xobj.GetValue<string>('uf');
      edtPais.Text := 'Brasil';
    finally
     xobj.Free;
    end;
  except
    MessageDlg('Verifique o CEP informado! Obrigado.', mtWarning, [mbOK], 0);
  end;

end;

//   validar cpf informado
procedure TfCadClienteComCep.edtCPFExit(Sender: TObject);
begin
  if (ufuncoes.fValidarCPF(edtCPF.Text) = false) then
  begin
    MessageDlg('CPF inválido! Favor verificar.', mtWarning, [mbOK], 0);
    edtCPF.SetFocus;
  end;
end;

//   validar email simples
procedure TfCadClienteComCep.edtEmailExit(Sender: TObject);
begin
  if (ufuncoes.fValidarEmail(edtEmail.Text) = false) then
  begin
    MessageDlg('E-Mail inválido! Favor verificar.', mtWarning, [mbOK], 0);
  end;
end;

//   inclui dados nos campo edit.text (facilitar teste - excluir posteriormente)
procedure TfCadClienteComCep.edtNomeDblClick(Sender: TObject);
begin
// exit;
  edtNome.Text:='Drausio Mendes Germano';
  edtCPF.Text:='14488874886';
  edtEmail.Text:='dmggermano@gmail.com';
  edtTelefone.Text:='15991973712';
  edtIdentidade.Text:='cpf';
  edtCEP.Text:='18057132';
  edtNumero.Text:='148';
  edtCEP.SetFocus;
end;

//  valida o campo telefone no exit do campo
procedure TfCadClienteComCep.edtTelefoneExit(Sender: TObject);
begin
  if uFuncoes.fValidarTelefone(edtTelefone.Text) = false then
  begin
      MessageDlg('Campo obrigatório. Favor verificar.', mtWarning, [mbOK], 0);
  end;
end;

//  valida o campo uf no exit do campo
procedure TfCadClienteComCep.edtUFExit(Sender: TObject);
begin
    edtUF.Text:=UpperCase(edtUF.Text);
end;

// fecha tabela/memoria ao sair do sistema
procedure TfCadClienteComCep.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    fdCliente.Active:=false;
end;

// ativa tabela/memoria ao entrar do sistema
procedure TfCadClienteComCep.FormCreate(Sender: TObject);
begin
  fdCliente.Active:=true;
end;

//   validar dados para insert
function TfCadClienteComCep.fValidarDados():Boolean;
var
  i : integer;
begin
    result := true;
    for I := 0 to ComponentCount-1 do
    begin
        if (Components[i] is TMaskEdit) and (TMaskEdit(Components[i]).tag > 0)
           and (length(trim(TMaskEdit(Components[i]).Text)) <= 0) then
        begin
            MessageDlg('Campo é obrigatorio.', mtWarning, [mbOK], 0);
            result := false;
            TMaskEdit(Components[i]).setfocus;
            result := false;
            exit;
        end;

        if (Components[i] is TEdit) and (TEdit(Components[i]).tag > 0)
           and (length(trim(TEdit(Components[i]).Text)) <= 0) then
        begin
            MessageDlg('Campo é obrigatorio.', mtWarning, [mbOK], 0);
            result := false;
            TEdit(Components[i]).setfocus;
            TEdit(Components[i]).Brush.Color:=clYellow;
            result := false;
            exit;
        end;
    end;
end;

//   validar/inclui/transmite os dados
procedure TfCadClienteComCep.btnIncluirClick(Sender: TObject);
begin
  { validar dados se false retorna }
  if fValidarDados = false then
  begin
     MessageDlg('Favor verificar os dados!', mtWarning, [mbOK], 0);
     exit;
  end;
  { validar dados se false retorna }
  if incluiReg = false then
  begin
     MessageDlg('Favor verificar, erro na conecção com a tabela/memória!', mtWarning, [mbOK], 0);
     exit;
  end;
  { envia email  se false retorna  }
  if transmitirDados = false then
  begin
     MessageDlg('Favor verificar, erro na transmissão dos dados!', mtWarning, [mbOK], 0);
     exit;
  end;
  { grava na tabela/memoria OK do envio do registro }
  if (gravaOKEnvio = false) then
  begin
        MessageDlg('Erro na confirmação do envio. ', mtWarning, [mbOK], 0);
        exit;
  end;
  limpaEdit;
end;


//   limpa os campos apos incluir e transmitir
procedure TfCadClienteComCep.limpaEdit;
var
  i:integer;
begin
    for I := 0 to ComponentCount-1 do
    begin
        if (Components[i] is TMaskEdit) then
        begin
            TMaskEdit(Components[i]).Clear;
        end;
        if (Components[i] is TEdit) then
        begin
            TEdit(Components[i]).Clear;
        end;
    end;
    edtNome.setfocus;
end;

//   transmite dados da registro da tabela/memória por email
function TfCadClienteComCep.transmitirDados():Boolean;
begin
  { verifica a existencia do anexo XML }
  if (criaXML() = false) then
  begin
    result := false;
    exit;
  end;

  { Envia o email com o anexo }
  if (uFuncoes.fEnviaEmail(edtEmail.Text,'cadCadastro','cadCadastro.XML - Germano (15) 991.973712.','c:\temp\cadCliente.xml') = false) then
  begin
    result := false;
    exit;
  end;
  result := true;
end;

// cria e salva arquivo XML em disco
function TfCadClienteComCep.criaXML():Boolean;
var
  xarq:string;
  tXMLDoc : IXMLDocument;
  cadCliente,cabecalho,cliente,endereco : IXMLNode;
begin
    try
        { verifica se há registro para enviar }
        if (fdCliente.FieldByName('nome').Value = null) then
        begin
            MessageDlg('Não há dados para transmitir!', mtWarning, [mbOK], 0);
            exit;
        end;

        { xarq ==> nome arquivo XML a ser salvo. }
        xarq := 'c:\temp';
        if uFuncoes.fCriaDiretorio(xarq) = false then
        begin
          MessageDlg('Não localizada a pasta c:\temp para salvar o arquivo XML.', mtWarning, [mbOK], 0);
          result := false;
          exit;
        end;
        xarq := xarq+'\cadCliente.xml';

        { criando dados XML }
        tXMLDoc  := TXMLDocument.Create(nil);
        tXMLDoc.Active := true;
        tXMLDoc.Version := '1.0';
        tXMLDoc.Encoding := 'UTF-8';

        { cria cadCliente }
        cadCliente := tXMLDoc.AddChild('cadCliente');
        cadCliente.AddChild('Nome').Text := fdCliente.FieldByName('nome').Value;
        cadCliente.AddChild('Identidade').Text := fdCliente.FieldByName('identidade').Value;
        cadCliente.AddChild('CPF').Text := fdCliente.FieldByName('cpf').Value;
        cadCliente.AddChild('Telefone').Text := fdCliente.FieldByName('telefone').Value;
        cadCliente.AddChild('Email').Text := fdCliente.FieldByName('email').Value;
        { cria endereco dentro da primeira(cadCliente)}
        endereco := cadCliente.AddChild('Endereco');
        endereco.AddChild('Cep').Text := fdCliente.FieldByName('cep').Value;
        endereco.AddChild('Logradouro').Text := fdCliente.FieldByName('logradouro').Value;
        endereco.AddChild('Numero').Text := fdCliente.FieldByName('numero').Value;
        endereco.AddChild('Complemento').Text := fdCliente.FieldByName('complemento').Value;
        endereco.AddChild('Bairro').Text := fdCliente.FieldByName('bairro').Value;
        endereco.AddChild('Cidade').Text := fdCliente.FieldByName('cidade').Value;
        endereco.AddChild('Estado').Text := fdCliente.FieldByName('estado').Value;
        endereco.AddChild('Pais').Text := fdCliente.FieldByName('pais').Value;

        { Salvando arquivo xml}
        tXMLDoc.SaveToFile(xarq);
        result := true;
    except
      begin
          result := false;
      end;
    end;
end;


// transmite registro da dbgfdCliente/dbGrid novamente
procedure TfCadClienteComCep.dbgfdClienteDblClick(Sender: TObject);
begin
    try
      if transmitirDados = true then
          gravaOKEnvio;
    except

    end;
end;

//   inclui dados na tabela/memória
function TfCadClienteComCep.incluiReg():Boolean;
begin
    try
         fdCliente.Append;
         fdCliente.FieldByName('nome').Value:=edtNome.Text;
         fdCliente.FieldByName('identidade').Value:=edtidentidade.Text;
         fdCliente.FieldByName('cpf').Value:=edtcpf.Text;
         fdCliente.FieldByName('telefone').Value:=edttelefone.Text;
         fdCliente.FieldByName('email').Value:=edtemail.Text;
         fdCliente.FieldByName('cep').Value:=edtcep.Text;
         fdCliente.FieldByName('logradouro').Value:=edtlogradouro.Text;
         fdCliente.FieldByName('numero').Value:=edtnumero.Text;
         fdCliente.FieldByName('complemento').Value:=edtcomplemento.Text;
         fdCliente.FieldByName('bairro').Value:=edtbairro.Text;
         fdCliente.FieldByName('cidade').Value:=edtcidade.Text;
         fdCliente.FieldByName('estado').Value:=edtuf.Text;
         fdCliente.FieldByName('pais').Value:=edtpais.Text;
         fdCliente.Post;
    except
          result:=false;
    end;
    result:=true;
end;

//   edita dados na tabela/memória para ok apos transmissão
function TfCadClienteComCep.gravaOKEnvio():Boolean;
begin
    try
         fdCliente.Edit;
         fdCliente.FieldByName('transmissao').Value:='OK';
         fdCliente.Post;
         MessageDlg('Operação realizada com sucesso! Obrigado. ', mtinformation, [mbOK], 0);
    except
         result := false;
         exit;
    end;
    result := true;
end;

end.
