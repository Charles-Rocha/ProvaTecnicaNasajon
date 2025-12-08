program ProvaTecnica;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmProvaTecnica};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmProvaTecnica, frmProvaTecnica);
  Application.Run;
end.
