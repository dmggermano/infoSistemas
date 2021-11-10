unit cadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons,Vcl.StdCtrls, Vcl.Mask, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client




  ;

type
  TfCadClienteComCep = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsCadCliente: TDataSource;
    Panel6: TPanel;
    SpeedButton2: TSpeedButton;
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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
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
    Label12: TLabel;
    edtComplemento: TEdit;
    Label13: TLabel;
    edtNumero: TEdit;
    fdClientetransmissao: TStringField;
    Label14: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edtUFExit(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNomeDblClick(Sender: TObject);
  private
    procedure limpaEdit;
    function fValidarDados: Boolean;
    function incluiReg: Boolean;
    function transmitirDados: Boolean;
    function criaXML: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCadClienteComCep: TfCadClienteComCep;

implementation

{$R *.dfm}

uses uFuncoes, XMLDoc, XMLIntf ;

// incli dados na tabela/memoria
procedure TfCadClienteComCep.edtCEPExit(Sender: TObject);
var
  xobj: TJSONObject;
  mmJson : TMemo;
begin

  try
    mmJson := tmemo.Create(nil);
    mmJson.text:=ufuncoes.fBuscarPorCEP(edtCEP.Text);
{
    Strin vai para Objeto Json ==> capturar os valores
}
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
    showmessage('Verifique o CEP informado! Obrigado.');
  end;

end;

//   validar cpf informado
procedure TfCadClienteComCep.edtCPFExit(Sender: TObject);
begin
  if (ufuncoes.fValidarCPF(edtCPF.Text) = false) then
  begin
    showmessage('CPF inválido! Favor verificar.');
    edtCPF.SetFocus;
  end;
end;

//   validar email simples
procedure TfCadClienteComCep.edtEmailExit(Sender: TObject);
begin
  if (ufuncoes.fValidarEmail(edtEmail.Text) = false) then
  begin
    showmessage('E-Mail inválido! Favor verificar.');
  end;
end;

// inclui dados nos campo edit.text
procedure TfCadClienteComCep.edtNomeDblClick(Sender: TObject);
begin
  edtNome.Text:='Drausio Mendes Germano';
  edtCPF.Text:='14488874886';
  edtEmail.Text:='dmggermano@gmail.com';
  edtTelefone.Text:='15991973712';
  edtIdentidade.Text:='cpf';
  edtCEP.Text:='18057132';
  edtNumero.Text:='148';
end;


//   validar maskEdit
procedure TfCadClienteComCep.edtTelefoneExit(Sender: TObject);
begin
  try

  except

  end;
end;

procedure TfCadClienteComCep.edtUFExit(Sender: TObject);
begin
  edtUF.Text:=UpperCase(edtUF.Text);
end;

procedure TfCadClienteComCep.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    fdCliente.Active:=false;
    fdCliente.Free;        ////////////////////////////////////
end;

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
            showmessage('Campo é obrigatorio.');
            result := false;
            TMaskEdit(Components[i]).setfocus;
            result := false;
            exit;
        end;

        if (Components[i] is TEdit) and (TEdit(Components[i]).tag > 0)
           and (length(trim(TEdit(Components[i]).Text)) <= 0) then
        begin
            showmessage('Campo é obrigatorio.');
            result := false;
            TEdit(Components[i]).setfocus;
            TEdit(Components[i]).Brush.Color:=clYellow;
            result := false;
            exit;
        end;
    end;
end;

//   validar/inclui/transmite os dados
procedure TfCadClienteComCep.SpeedButton2Click(Sender: TObject);
begin
  if fValidarDados = false then
  begin
     showmessage('Favor verificar os dados!');
     exit;
  end;
  if incluiReg = false then
  begin
     showmessage('Favor verificar, erro na conecção com a tabela/memória!');
     exit;
  end;
  if transmitirDados = false then
  begin
     showmessage('Favor verificar, erro na transmissão dos dados!');
     exit;
  end;
  limpaEdit;
end;


///   limpa os campos apos incluir e transmitir
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

/// <summary>
///   transmite dados da tabela/memória por email
/// </summary>
function TfCadClienteComCep.transmitirDados():Boolean;
begin
  if (criaXML() = false) then
  begin
    result := false;
    exit;
  end;
  if (uFuncoes.fEnviaEmail(edtEmail.Text,'cadCadastro','cadCadastro.XML','c:\temp\cadCliente.xml') = false) then
  begin
    result := false;
    exit;
  end;
  result := true;
end;

function TfCadClienteComCep.criaXML():Boolean;
var
  xarq:string;
  tXMLDoc : IXMLDocument;
  cadCliente,cabecalho,cliente,endereco : IXMLNode;
begin
    try
        { xarq ==> nome arquivo XML a ser salvo. }
        xarq := 'c:\temp';
        if uFuncoes.fCriaDiretorio(xarq) = false then
        begin
          showmessage('Não localizada a pasta c:\temp para salvar o arquivo XML.');
          result := false;
          exit;
        end;
        xarq := xarq+'\cadCliente.xml';

        { criando dados XML. }
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


/// <summary>
///   inclui dados na memória
/// </summary>
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

end.
