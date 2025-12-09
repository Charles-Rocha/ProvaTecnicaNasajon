unit untResultado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, REST.JSON;

type
  TfrmResultado = class(TForm)
    mmoResultado: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FResultado: string;

    function FormatarJson(const JsonString: string): string;
  public
    { Public declarations }
    property Resultado: string read FResultado write FResultado;
  end;

var
  frmResultado: TfrmResultado;

implementation

{$R *.dfm}

function TfrmResultado.FormatarJson(const JsonString: string): string;
var
  JsonValue: TJSONValue;
  JsonObject: TJSONObject;
begin
  Result := '';
  JsonValue := TJSONObject.ParseJSONValue(JsonString);
  try
    if JsonValue is TJSONObject then
    begin
      JsonObject := JsonValue as TJSONObject;
      Result := TJson.Format(JsonObject);
    end;
  finally
    JsonValue.Free; // Libera o TJSONValue
  end;
end;

procedure TfrmResultado.FormShow(Sender: TObject);
var
  JsonFormatado: string;
begin
  JsonFormatado := FormatarJson(FResultado);
  mmoResultado.Lines.Text := JsonFormatado;
end;

end.
