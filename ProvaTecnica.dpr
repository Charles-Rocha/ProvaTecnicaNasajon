program ProvaTecnica;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmProvaTecnica},
  untSobre in 'untSobre.pas' {frmSobre},
  untResultado in 'untResultado.pas' {frmResultado},
  NHunspell in 'NHunspell.pas',
  NHunXml in 'NHunXml.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmProvaTecnica, frmProvaTecnica);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.CreateForm(TfrmResultado, frmResultado);
  Application.Run;
end.
