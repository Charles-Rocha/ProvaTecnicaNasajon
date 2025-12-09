unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Menus, System.JSON,
  REST.Client, REST.Types, System.Generics.Collections, NHunspell, Vcl.StdCtrls;

type
  TTipoRegiao = (eNorte, eNordeste, eCentroOeste, eSudeste, eSul);

type
  TfrmProvaTecnica = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    ProcessarArquivoCSV1: TMenuItem;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Ajuda1: TMenuItem;
    Sobre1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure ProcessarArquivoCSV1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FlstArquivoCSV: TStringList;
    FlstResultadoCSV: TStringList;
    FlstMediasPorRegiao: TStringList;
    FlstDicionario: TStringList;

    procedure CarregarArquivoCSV;
    procedure CarregarDicionario;
    procedure CarregarMunicipiosIBGE;
    procedure EnvioEstatisticasParaCorrecao(JObject: TJSONObject);
    function CalcularMediasPorRegiao(pRegiao: string): double;
    procedure MontarJsonDeCorrecao(pTotalMunicipios, pTotalOk,
      pTotalNaoEncontrados, pTotalErroApi, pPopTotalOk: integer);
    function RetirarAcentos(const Texto: string): string;
    function VerificarDigitacaoMunicipio(pMunicipioInput: string): string;
  public
    { Public declarations }
  end;

var
  frmProvaTecnica: TfrmProvaTecnica;

implementation

{$R *.dfm}

uses untSobre, untResultado;

{ TfrmProvaTecnica }

function TfrmProvaTecnica.RetirarAcentos(const Texto: string): string;
const
  Acentos = 'áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜãõÃÕâêîôûÂÊÎÔÛçÇñÑ';
  Normais = 'aeiouAEIOUaeiouAEIOUaeiouAEIOUaoAOaeiouAEIOUcCnN';
var
  a: Integer;
begin
  Result := '';
  for a := 1 to Length(Texto) do
    if Pos(Texto[a], Acentos) > 0 then
      Result := Result + Normais[Pos(Texto[a], Acentos)]
    else
      Result := Result + Texto[a];
end;

function TfrmProvaTecnica.CalcularMediasPorRegiao(pRegiao: string): double;
var
  sLinha, sRegiao, sPopulacaoInput: string;
  i, iPopulacaoInputTotal, contador: integer;
  dTotal: double;
begin
  dTotal := 0;

  if pRegiao = 'Norte' then
    begin
      contador := 0;
      iPopulacaoInputTotal := 0;
      for i := 0 to FlstMediasPorRegiao.Count-1 do
        begin
          sLinha := FlstMediasPorRegiao.Strings[i];
          sRegiao := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
          sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));

          if sRegiao = 'Norte' then
            begin
              contador := contador + 1;
              iPopulacaoInputTotal := iPopulacaoInputTotal + StrToInt(sPopulacaoInput);
            end;
        end;
      if iPopulacaoInputTotal > 0 then
        dTotal := iPopulacaoInputTotal / contador;
    end;

  if pRegiao = 'Nordeste' then
    begin
      contador := 0;
      iPopulacaoInputTotal := 0;
      for i := 0 to FlstMediasPorRegiao.Count-1 do
        begin
          sLinha := FlstMediasPorRegiao.Strings[i];
          sRegiao := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
          sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));

          if sRegiao = 'Nordeste' then
            begin
              contador := contador + 1;
              iPopulacaoInputTotal := iPopulacaoInputTotal + StrToInt(sPopulacaoInput);
            end;
        end;
      if iPopulacaoInputTotal > 0 then
        dTotal := iPopulacaoInputTotal / contador;
    end;

  if pRegiao = 'Centro-Oeste' then
    begin
      contador := 0;
      iPopulacaoInputTotal := 0;
      for i := 0 to FlstMediasPorRegiao.Count-1 do
        begin
          sLinha := FlstMediasPorRegiao.Strings[i];
          sRegiao := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
          sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));

          if sRegiao = 'Centro-Oeste' then
            begin
              contador := contador + 1;
              iPopulacaoInputTotal := iPopulacaoInputTotal + StrToInt(sPopulacaoInput);
            end;
        end;
      if iPopulacaoInputTotal > 0 then
        dTotal := iPopulacaoInputTotal / contador;
    end;

  if pRegiao = 'Sudeste' then
    begin
      contador := 0;
      iPopulacaoInputTotal := 0;
      for i := 0 to FlstMediasPorRegiao.Count-1 do
        begin
          sLinha := FlstMediasPorRegiao.Strings[i];
          sRegiao := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
          sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));

          if sRegiao = 'Sudeste' then
            begin
              contador := contador + 1;
              iPopulacaoInputTotal := iPopulacaoInputTotal + StrToInt(sPopulacaoInput);
            end;
        end;
      if iPopulacaoInputTotal > 0 then
        dTotal := iPopulacaoInputTotal / contador;
    end;

  if pRegiao = 'Sul' then
    begin
      contador := 0;
      iPopulacaoInputTotal := 0;
      for i := 0 to FlstMediasPorRegiao.Count-1 do
        begin
          sLinha := FlstMediasPorRegiao.Strings[i];
          sRegiao := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
          sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));

          if sRegiao = 'Sul' then
            begin
              contador := contador + 1;
              iPopulacaoInputTotal := iPopulacaoInputTotal + StrToInt(sPopulacaoInput);
            end;
        end;
      if iPopulacaoInputTotal > 0 then
        dTotal := iPopulacaoInputTotal / contador;
    end;
  result := dTotal;
end;

procedure TfrmProvaTecnica.CarregarArquivoCSV;
var
  sCaminhoArquivo: string;
begin
  sCaminhoArquivo := ExtractfilePath(Application.ExeName) + 'Arquivos\input.csv';
  FlstArquivoCSV.LoadFromFile(sCaminhoArquivo);
end;

procedure TfrmProvaTecnica.CarregarDicionario;
var
  sCaminhoArquivo: string;
  i: integer;
begin
  sCaminhoArquivo := ExtractFilePath(application.Exename) + 'Dicionarios\pt-BR.oxt';
  Hunspell.ReadOXT(sCaminhoArquivo);
  FlstDicionario.BeginUpdate;

  for i := 0 to Hunspell.SpellDictionaryCount-1 do
    begin
      FlstDicionario.AddObject(Format('%s - %s Version: %s', [Hunspell.SpellDictionaries[i].LanguageName,
                                                 Hunspell.SpellDictionaries[i].DisplayName,
                                                 Hunspell.SpellDictionaries[i].Version]),
                                                 Hunspell.SpellDictionaries[i]);
    end;

  Hunspell.SpellDictionaries[0].Active := true;
  Hunspell.UpdateAndLoadDictionaries;
  FlstDicionario.EndUpdate;
end;

procedure TfrmProvaTecnica.CarregarMunicipiosIBGE;
var
  sResultado, sLinha, sLinhaTemp, sMunicipioInput, sMunicipioIBGE, sPopulacaoInput, sPopulacaoIBGE: string;
  sIdIBGE, sUF, sRegiao, sRegiaoAnterior, sMunicipioTemp: string;
  RESTClientMunicipiosIBGEGet: TRestClient;
  ReqMunicipiosIBGEGet: TRestRequest;
  RESTResponseMunicipiosIBGEGet: TRestResponse;
  jSubObj1, jSubObj2, jSubObj3, jSubObj4, jSubObj5: TJSONObject;
  jv1, jv2, jv3, jv4: TJSONValue;
  JSArray: TJSONArray;
  i, j, k, iTotalMunicipios, iTotalOk, iTotalNaoEncontrados, iTotalErroApi, iPopTotalOk: Integer;
  dMediasPorRegiao: double;
  bEncontrado, bDuplicado: boolean;
  lstTemp: TStringList;
begin
  RESTClientMunicipiosIBGEGet := TRestClient.Create(Self);
  ReqMunicipiosIBGEGet := TRestRequest.Create(Self);
  RESTResponseMunicipiosIBGEGet := TRestResponse.Create(Self);
  iTotalMunicipios := 0;
  iTotalOk := 0;
  iTotalNaoEncontrados := 0;
  iTotalErroApi := 0;
  iPopTotalOk := 0;  
  lstTemp := TStringList.Create;
  lstTemp.Sorted := true;
  lstTemp.Duplicates := dupIgnore;

  try
    sResultado := EmptyStr;
    try
      RESTClientMunicipiosIBGEGet.BaseURL := 'https://servicodados.ibge.gov.br';
      ReqMunicipiosIBGEGet.Resource := '/api/v1/localidades/municipios';
      RESTResponseMunicipiosIBGEGet.ContentType := 'application/json';
      ReqMunicipiosIBGEGet.Client := RESTClientMunicipiosIBGEGet;
      ReqMunicipiosIBGEGet.Response := RESTResponseMunicipiosIBGEGet;
      ReqMunicipiosIBGEGet.Method := rmGET;
      ReqMunicipiosIBGEGet.Execute;

      sResultado := RESTResponseMunicipiosIBGEGet.Content;
      JSArray := TJSONObject.ParseJSONValue(sResultado) as TJSONArray;

      //municipio_input, populacao_input, municipio_ibge, uf, regiao, id_ibge, status
      FlstResultadoCSV.Add('municipio_input,populacao_input,municipio_ibge,uf,regiao,id_ibge,status');

      for i := 0 to FlstArquivoCSV.Count-1 do
        begin
          if i > 0 then
            begin
              bEncontrado := false;
              bDuplicado := false;
              sLinha := FlstArquivoCSV.Strings[i];
              sMunicipioInput := Trim(copy(sLinha, 1, pos(',', sLinha)-1));
              sMunicipioInput := VerificarDigitacaoMunicipio(sMunicipioInput);
              sMunicipioInput := RetirarAcentos(sMunicipioInput);
              sPopulacaoInput := Trim(copy(sLinha, pos(',', sLinha)+1, length(sLinha)));
              iTotalMunicipios := iTotalMunicipios + 1;
              sMunicipioIBGE := EmptyStr;
              sUF := EmptyStr;
              sRegiao := EmptyStr;

              lstTemp.Add(sMunicipioInput + ',' + sPopulacaoInput);

              for j := 0 to JSArray.Count - 1 do
                begin
                  jSubObj1 := (JSArray.Items[j] as TJSONObject);
                  sIdIBGE := StringReplace(jSubObj1.Get('id').JsonValue.ToString, '"', EmptyStr, [rfReplaceAll]);
                  sMunicipioIBGE := StringReplace(jSubObj1.Get('nome').JsonValue.ToString, '"', EmptyStr, [rfReplaceAll]);
                  sMunicipioIBGE := RetirarAcentos(sMunicipioIBGE);

                  if sMunicipioIBGE = sMunicipioInput then
                    begin
                      jv1 := jSubObj1.Get('microrregiao').JsonValue;
                      jSubObj2 := jv1 as TJSONObject;
                      jv2 := jSubObj2.Get('mesorregiao').JsonValue;
                      jSubObj3 := jv2 as TJSONObject;
                      jv3 := jSubObj3.Get('UF').JsonValue;
                      jSubObj4 := jv3 as TJSONObject;
                      sUF := StringReplace(jSubObj4.Get('sigla').JsonValue.ToString, '"', EmptyStr, [rfReplaceAll]);

                      jv4 := jSubObj4.Get('regiao').JsonValue;
                      jSubObj5 := jv4 as TJSONObject;
                      sRegiao := StringReplace(jSubObj5.Get('nome').JsonValue.ToString, '"', EmptyStr, [rfReplaceAll]);

                      if FlstResultadoCSV.Count = 1 then
                        begin
                          FlstResultadoCSV.Add(sMunicipioInput + ',' + sPopulacaoInput + ',' + sMunicipioIBGE + ',' +
                            sUF + ',' + sRegiao + ',' + sIdIBGE + ',' + 'OK');
                          FlstMediasPorRegiao.Add(sRegiao + ',' + sPopulacaoInput);
                          bEncontrado := true;
                          iTotalOk := iTotalOk + 1;
                          iPopTotalOk := iPopTotalOk + StrToInt(sPopulacaoInput);
                        end
                      else
                        begin  
                          for k := 0 to FlstResultadoCSV.Count-1 do
                            begin
                              if k > 0 then
                                begin
                                  sLinhaTemp := FlstResultadoCSV.Strings[k];
                                  sMunicipioTemp := copy(sLinhaTemp, 1, pos(',', sLinhaTemp)-1);
                                  if sMunicipioTemp = sMunicipioInput then
                                    bDuplicado := true;                                                        
                                end;
                            end;

                          if not bDuplicado then
                            begin
                              FlstResultadoCSV.Add(sMunicipioInput + ',' + sPopulacaoInput + ',' + sMunicipioIBGE + ',' +
                                sUF + ',' + sRegiao + ',' + sIdIBGE + ',' + 'OK');
                              FlstMediasPorRegiao.Add(sRegiao + ',' + sPopulacaoInput);
                              bEncontrado := true;
                              iTotalOk := iTotalOk + 1;
                              iPopTotalOk := iPopTotalOk + StrToInt(sPopulacaoInput);                              
                            end
                          else
                            begin    
                              FlstResultadoCSV.Add(sMunicipioInput + ',' + sPopulacaoInput + ',' + sMunicipioIBGE + ',' +
                                sUF + ',' + sRegiao + ',' + sIdIBGE + ',' + 'AMBIGUO');
                              FlstMediasPorRegiao.Add(sRegiao + ',' + sPopulacaoInput);
                            end;
                        end;                      
                    end;
                end;

                if not bEncontrado then
                  begin
                    sMunicipioIBGE := EmptyStr;
                    FlstResultadoCSV.Add(sMunicipioInput + ',' + sPopulacaoInput + ',' + sMunicipioIBGE + ',' +
                                           sUF + ',' + sRegiao + ',' + sIdIBGE + ',' + 'NAO_ENCONTRADO');
                    iTotalNaoEncontrados := iTotalNaoEncontrados + 1;
                  end;
            end;
        end;

       FlstResultadoCSV.SaveToFile(ExtractfilePath(Application.ExeName) + 'Arquivos\resultado.csv');
    except on e: exception do
      begin
        iTotalErroApi := iTotalErroApi + 1;
      end;
    end;
  finally
    RESTClientMunicipiosIBGEGet.Free;
    ReqMunicipiosIBGEGet.Free;
    RESTResponseMunicipiosIBGEGet.Free;
    MontarJsonDeCorrecao(iTotalMunicipios, iTotalOk, iTotalNaoEncontrados, iTotalErroApi, iPopTotalOk);
    lstTemp.Free;
  end;
end;

procedure TfrmProvaTecnica.EnvioEstatisticasParaCorrecao(JObject: TJSONObject);
var
  sResultado, sToken: string;
  RESTClientEstatisticasParaCorrecaoPost: TRESTClient;
  ReqEstatisticasParaCorrecaoPost: TRESTRequest;
  RESTResponseEstatisticasParaCorrecaoPost: TRESTResponse;
begin
  sToken := 'eyJhbGciOiJIUzI1NiIsImtpZCI6ImR0TG03UVh1SkZPVDJwZEciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL215bnhsdWJ5a3lsbmNpbnR0Z2d1LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiI5MTY4OTc0YS1kZTFlLTQwMWMtOWRhMS0wYTZiZDhkYmE2NzAiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzY1MjI5NDMxLCJpYXQiOjE3NjUyMjU4MzEsImVtYWlsIjoiY2hhcmxlcy5yb2NoYUBvdXRsb29rLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnsiZW1haWwiOiJjaGFybGVzLnJvY2hhQG91dGxvb2suY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbWUiOiJDaGFybGVzIGRhIFNpbHZhIFJvY2hhIiwicGhvbmVfdmVyaWZpZWQiOmZhbHNlLCJzdWIiOiI5MTY4OTc0YS1kZTFlLTQwMWMtOWRhMS0wYTZiZDhkYmE2NzAifSwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc2NTIyNTgzMX1dLCJzZXNzaW9uX2lkIjoiNTViZDY4NGUtZjA5Ni00NzZkLWFmNDktNTI2M2EyNDU3OWVmIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.TDhJ82fjLQc_RqAoxTxFxjoetZXEBeSFxbU6GRSJCrw';

  RESTClientEstatisticasParaCorrecaoPost := TRESTClient.Create(nil);
  ReqEstatisticasParaCorrecaoPost := TRESTRequest.Create(nil);
  RESTResponseEstatisticasParaCorrecaoPost := TRESTResponse.Create(nil);

  try
    RESTClientEstatisticasParaCorrecaoPost.BaseURL := 'https://mynxlubykylncinttggu.functions.supabase.co';
    ReqEstatisticasParaCorrecaoPost.Resource := '/ibge-submit';
    ReqEstatisticasParaCorrecaoPost.Client := RESTClientEstatisticasParaCorrecaoPost;
    ReqEstatisticasParaCorrecaoPost.Response := RESTResponseEstatisticasParaCorrecaoPost;
    ReqEstatisticasParaCorrecaoPost.Method := rmPOST;

    ReqEstatisticasParaCorrecaoPost.Params.AddItem('Authorization', 'Bearer ' + sToken, pkHTTPHEADER, [TRESTRequestParameterOption.poDoNotEncode]);
    ReqEstatisticasParaCorrecaoPost.AddBody(JObject);
    ReqEstatisticasParaCorrecaoPost.Execute;

    sResultado := RESTResponseEstatisticasParaCorrecaoPost.Content;
    frmResultado.Resultado := sResultado;
    frmResultado.ShowModal;

  finally
    RESTClientEstatisticasParaCorrecaoPost.Free;
    ReqEstatisticasParaCorrecaoPost.Free;
    RESTResponseEstatisticasParaCorrecaoPost.Free;
  end;
end;

procedure TfrmProvaTecnica.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FlstArquivoCSV.Free;
  FlstResultadoCSV.Free;
  FlstMediasPorRegiao.Free;
  FlstDicionario.Free;
end;

procedure TfrmProvaTecnica.FormCreate(Sender: TObject);
begin
  FlstArquivoCSV := TStringList.Create;
  FlstResultadoCSV := TStringList.Create;
  FlstResultadoCSV.Sorted := false;
  FlstResultadoCSV.Duplicates := dupIgnore;
  FlstMediasPorRegiao := TStringList.Create;
  FlstDicionario := TStringList.Create;
  CarregarDicionario;
end;

procedure TfrmProvaTecnica.MontarJsonDeCorrecao(pTotalMunicipios, pTotalOk,
  pTotalNaoEncontrados, pTotalErroApi, pPopTotalOk: integer);
var
  LJsonObject, LJsonObjectMedias, LJsonRoot: TJSONObject;
  LJsonString: string;
  dPopNorteTotal, dPopNordesteTotal, dPopCentroOesteTotal, dPopSudesteTotal, dPopSulTotal: double;
begin
  LJsonObject := TJSONObject.Create;
  LJsonObject.AddPair('total_municipios', TJSONNumber.Create(pTotalMunicipios));
  LJsonObject.AddPair('total_ok', TJSONNumber.Create(pTotalOk));
  LJsonObject.AddPair('total_nao_encontrado', TJSONNumber.Create(pTotalNaoEncontrados));
  LJsonObject.AddPair('total_erro_api', TJSONNumber.Create(pTotalErroApi));
  LJsonObject.AddPair('pop_total_ok', TJSONNumber.Create(pPopTotalOk));

  LJsonObjectMedias := TJSONObject.Create;
  dPopNorteTotal := CalcularMediasPorRegiao('Norte');
  if dPopNorteTotal > 0 then
    LJsonObjectMedias.AddPair('Norte', TJSONNumber.Create(dPopNorteTotal));

  dPopNordesteTotal := CalcularMediasPorRegiao('Nordeste');
  if dPopNordesteTotal > 0 then
    LJsonObjectMedias.AddPair('Nordeste', TJSONNumber.Create(dPopNordesteTotal));

  dPopCentroOesteTotal := CalcularMediasPorRegiao('Centro-Oeste');
  if dPopCentroOesteTotal > 0 then
    LJsonObjectMedias.AddPair('Centro-Oeste', TJSONNumber.Create(dPopCentroOesteTotal));

  dPopSudesteTotal := CalcularMediasPorRegiao('Sudeste');
  if dPopSudesteTotal > 0 then
    LJsonObjectMedias.AddPair('Sudeste', TJSONNumber.Create(dPopSudesteTotal));

  dPopSulTotal := CalcularMediasPorRegiao('Sul');
  if dPopSulTotal > 0 then
    LJsonObjectMedias.AddPair('Sul', TJSONNumber.Create(dPopSulTotal));

  LJsonObject.AddPair('medias_por_regiao', LJsonObjectMedias);

  LJsonRoot := TJSONObject.Create;
  LJsonRoot.AddPair('stats', LJsonObject);
  LJsonString := LJsonRoot.ToString;
  EnvioEstatisticasParaCorrecao(LJsonRoot);
end;

procedure TfrmProvaTecnica.ProcessarArquivoCSV1Click(Sender: TObject);
begin
  CarregarArquivoCSV;
  CarregarMunicipiosIBGE;
end;

procedure TfrmProvaTecnica.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmProvaTecnica.Sobre1Click(Sender: TObject);
begin
  frmSobre.ShowModal;
end;

function TfrmProvaTecnica.VerificarDigitacaoMunicipio(pMunicipioInput: string): string;
var
  tmpStr: TUnicodeStringList;
  sPalavra, sNovaPalavra: string;
  lstPalavras: TStringList;
  i: integer;
begin  
  lstPalavras := TStringList.Create;
  lstPalavras.Delimiter := ' ';
  lstPalavras.DelimitedText := pMunicipioInput;
  tmpStr := TUnicodeStringList.create;
  sNovaPalavra := EmptyStr;

  try
    for i := 0 to lstPalavras.Count-1 do
      begin
        tmpStr.Clear;
        sPalavra := lstPalavras.Strings[i];
        TNHSpellDictionary(FlstDicionario.Objects[0]).Suggest(sPalavra, tmpStr);        

        if (tmpStr.count <= 2) or (lstPalavras.Count = 1) then
          sNovaPalavra := sNovaPalavra + tmpStr.Strings[0] + ' '
        else
          sNovaPalavra := sNovaPalavra + sPalavra + ' ';
      end;

    if lstPalavras.Count = 1 then
      sNovaPalavra := StringReplace(sNovaPalavra, ' ', EmptyStr, [rfReplaceAll]);
    result := Trim(sNovaPalavra);
  finally
    FreeAndNil(tmpStr);    
    lstPalavras.Free;
  end;
end;

end.
