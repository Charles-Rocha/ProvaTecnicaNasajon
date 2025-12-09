unit untSobre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TfrmSobre = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    lblProcessoSelecao: TLabel;
    lblDesenvolvedor: TLabel;
    Panel2: TPanel;
    btnOk: TButton;
    lblDataCriacao: TLabel;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.dfm}

procedure TfrmSobre.btnOkClick(Sender: TObject);
begin
  Close;
end;

end.
