unit uCadastroPessoasView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, uPessoaController, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Tabs, Vcl.DockTabSet, System.JSON, REST.Client,
  REST.Types, System.Net.HttpClient, System.Net.URLClient, System.Net.HttpClientComponent;

type
  TfrmCadastroPessoasView = class(TForm)
    Panel1: TPanel;
    gbCadastro: TGroupBox;
    edtNome: TEdit;
    lblNome: TLabel;
    dtpDataNascimento: TDateTimePicker;
    lblDataNascimento: TLabel;
    lblSaldoDevedor: TLabel;
    btnAdicionarPessoa: TButton;
    gbBancoDados: TGroupBox;
    btnGravarBanco: TButton;
    btnExcluir: TButton;
    btnCarregarMemoria: TButton;
    btnMostrarRegistros: TButton;
    edtSaldoDevedor: TEdit;
    lstPessoasMemoria: TListBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    btnBuscar: TButton;
    FDMemTableApi: TFDMemTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure btnAdicionarPessoaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGravarBancoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCarregarMemoriaClick(Sender: TObject);
    procedure btnMostrarRegistrosClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
  private
    FPessoaController: TPessoaController;
    procedure LimparCampos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroPessoasView: TfrmCadastroPessoasView;

implementation

{$R *.dfm}

procedure TfrmCadastroPessoasView.btnAdicionarPessoaClick(Sender: TObject);
begin
  FPessoaController.AdicionarPessoa(edtNome.Text, dtpDataNascimento.DateTime, StrToCurr(edtSaldoDevedor.Text));
  LimparCampos;
end;

procedure TfrmCadastroPessoasView.btnBuscarClick(Sender: TObject);
var
  LHTTP: TNetHTTPClient;
  LResponse: IHTTPResponse;
  LJSONValue: TJSONValue;
  LJSONArray: TJSONArray;
  LItem: TJSONValue;
  LObj: TJSONObject;

  LCarArr: TJSONArray;
  LCarItem: TJSONValue;
  LCaracteristicas: string;

  LFormat: TFormatSettings;
  LPreco: string;
begin
  LHTTP := TNetHTTPClient.Create(nil);
  try
    LResponse := LHTTP.Get('https://developers.silbeck.com.br/mocks/apiteste/v2/aptos');

    if LResponse.StatusCode = 200 then
    begin
      LJSONValue := TJSONObject.ParseJSONValue(LResponse.ContentAsString(TEncoding.UTF8));
      try
        if Assigned(LJSONValue) and (LJSONValue is TJSONArray) then
        begin
          LJSONArray := LJSONValue as TJSONArray;

          FDMemTableApi.Close;
          FDMemTableApi.FieldDefs.Clear;

          FDMemTableApi.FieldDefs.Add('Código', ftString, 10);
          FDMemTableApi.FieldDefs.Add('Nome', ftString, 35);
          FDMemTableApi.FieldDefs.Add('Preço', ftFloat);
          FDMemTableApi.FieldDefs.Add('Características', ftString, 60);
          FDMemTableApi.CreateDataSet;

          LFormat := TFormatSettings.Create;
          LFormat.DecimalSeparator := '.';

          for LItem in LJSONArray do
          begin
            if not (LItem is TJSONObject) then
              Continue;

            LObj := TJSONObject(LItem);

            FDMemTableApi.Append;
            try
              FDMemTableApi.FieldByName('Código').AsString := LObj.Values['codigo'].Value;
              FDMemTableApi.FieldByName('Nome').AsString   := LObj.Values['nome'].Value;
              LPreco := LObj.Values['preco'].Value;
              FDMemTableApi.FieldByName('Preço').AsFloat := StrToFloat(LPreco, LFormat);
              LCaracteristicas := '';
              LCarArr := LObj.Values['caracteristicas'] as TJSONArray;
              if Assigned(LCarArr) then
                for LCarItem in LCarArr do
                  if (LCarItem is TJSONObject)
                     and Assigned((LCarItem as TJSONObject).Values['nome']) then
                  begin
                    if LCaracteristicas <> '' then
                      LCaracteristicas := LCaracteristicas + ', ';
                    LCaracteristicas := LCaracteristicas +
                      (LCarItem as TJSONObject).Values['nome'].Value;
                  end;

              FDMemTableApi.FieldByName('Características').AsString := LCaracteristicas;

              FDMemTableApi.Post;
            except
              FDMemTableApi.Cancel;
              raise;
            end;
          end;
        end;
      finally
        LJSONValue.Free;
      end;
    end
    else
    begin
      ShowMessage('Erro na requisição. Status: ' + LResponse.StatusCode.ToString);
    end;
  finally
    LHTTP.Free;
  end;
end;

procedure TfrmCadastroPessoasView.btnCarregarMemoriaClick(Sender: TObject);
begin
  if FPessoaController.CarregarLista then
    ShowMessage('Registros carregados com sucesso.')
  else
    ShowMessage('Erro ao carregar os registros.');
end;

procedure TfrmCadastroPessoasView.btnExcluirClick(Sender: TObject);
var
  LCodigoPessoa: String;
begin
  if InputQuery('Excluir por Id', 'Informe o código da pessoa:', LCodigoPessoa) then
  begin
    if FPessoaController.DeletarPorCodigo(StrToInt(LCodigoPessoa)) then
      ShowMessage('Registro deletado com sucesso.')
    else
      ShowMessage('Erro ao deletar registro.');
  end;
end;

procedure TfrmCadastroPessoasView.btnGravarBancoClick(Sender: TObject);
begin
  if FPessoaController.GravarNoBanco then
    ShowMessage('Registros gravados com sucesso.')
  else
    ShowMessage('Erro ao gravar registros no banco.');
end;

procedure TfrmCadastroPessoasView.btnMostrarRegistrosClick(Sender: TObject);
begin
  FPessoaController.MostrarPessoasNaMemoria(lstPessoasMemoria)
end;

procedure TfrmCadastroPessoasView.FormCreate(Sender: TObject);
begin
  FPessoaController := TPessoaController.Create;
end;

procedure TfrmCadastroPessoasView.LimparCampos;
begin
  edtNome.Clear;
  edtSaldoDevedor.Clear;
  dtpDataNascimento.DateTime := Now;
  edtNome.SetFocus;
end;

end.
