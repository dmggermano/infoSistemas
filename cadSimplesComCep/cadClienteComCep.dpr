program cadClienteComCep;

uses
  Vcl.Forms,
  cadCliente in 'cadCliente.pas' {fCadClienteComCep},
  uFuncoes in 'uFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfCadClienteComCep, fCadClienteComCep);
  Application.Run;
end.
