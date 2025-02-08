unit uPessoaController;

interface

uses
  System.SysUtils, uPessoaModel, uPessoaListaModel, uPessoaDAO, uConexaoDAO, Vcl.StdCtrls;

type
  TPessoaController = class
  private
    FPessoaLista: TPessoaLista;
    FPessoaDAO: TPessoaDAO;
    FConexaoDAO: TConexaoDAO;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AdicionarPessoa(ANome: String; ADataNascimento: TDateTime; ASaldoDevedor: Currency);
    function GravarNoBanco: Boolean;
    function DeletarPorCodigo(ACodigo: Integer): Boolean;
    function CarregarLista: Boolean;
    procedure MostrarPessoasNaMemoria(AListBox: TListBox);
  end;

implementation

constructor TPessoaController.Create;
begin
  FConexaoDAO := TConexaoDAO.Create;
  FPessoaDAO  := TPessoaDAO.Create(FConexaoDAO.GetConn);

  FPessoaLista := TPessoaLista.Create;
end;

destructor TPessoaController.Destroy;
begin
  FPessoaDAO.Free;
  FConexaoDAO.Free;
  FPessoaLista.Free;
  inherited;
end;

procedure TPessoaController.AdicionarPessoa(ANome: string; ADataNascimento: TDateTime; ASaldoDevedor: Currency);
var
  LPessoa: TPessoa;
begin
  LPessoa                := TPessoa.Create;
  LPessoa.Nome           := ANome;
  LPessoa.DataNascimento := ADataNascimento;
  LPessoa.SaldoDevedor   := ASaldoDevedor;

  FPessoaLista.AdicionarPessoa(LPessoa);
end;

function TPessoaController.GravarNoBanco: Boolean;
begin
  Result := FPessoaDAO.GravarNoBanco(FPessoaLista);
end;

function TPessoaController.DeletarPorCodigo(ACodigo: Integer): Boolean;
begin
  Result := FPessoaDAO.DeletarPorCodigo(ACodigo);
end;

function TPessoaController.CarregarLista: Boolean;
begin
  FPessoaLista := FPessoaDAO.CarregarNaMemoria;
  if Assigned(FPessoaLista) then
    Result := True
  else
    Result := False;
end;

procedure TPessoaController.MostrarPessoasNaMemoria(AListBox: TListBox);
var
  LPessoa: TPessoa;
begin
  if FPessoaLista.RetornarListaPessoas.Count > 0 then
  begin
    AListBox.Clear;

    AListBox.Items.Add('Código - Nome - Data Nascimento - Saldo Devedor');

    for LPessoa in FPessoaLista.RetornarListaPessoas do
    begin
      AListBox.Items.Add(Format('%d - %s - %s - R$ %.2f',[LPessoa.Codigo,LPessoa.Nome,DateToStr(LPessoa.DataNascimento),LPessoa.SaldoDevedor]));
    end;

  end;
end;

end.
