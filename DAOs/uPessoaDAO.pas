unit uPessoaDAO;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, System.Classes, uPessoaListaModel, uPessoaModel;

type
  TPessoaDAO = class
  private
    FConnection: TFDConnection;
    FPessoaLista: TPessoaLista;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    function GravarNoBanco(APessoaLista: TPessoaLista): Boolean;
    function CarregarNaMemoria: TPessoaLista;
    function DeletarPorCodigo(ACodigo: Integer): Boolean;
  end;

implementation

uses
  uConexaoDAO;

constructor TPessoaDAO.Create(AConnection: TFDConnection);
begin
  FConnection  := AConnection;
  FPessoaLista := TPessoaLista.Create;
end;

destructor TPessoaDAO.Destroy;
begin
  FPessoaLista.Free;
end;

function TPessoaDAO.GravarNoBanco(APessoaLista: TPessoaLista): Boolean;
var
  LPessoa: TPessoa;
  LPessoaQuery: TFDQuery;
begin
  Result := false;
  FConnection.StartTransaction;
  try
    LPessoaQuery := TFDQuery.Create(nil);

    try
      LPessoaQuery.Connection := FConnection;
      LPessoaQuery.SQL.Text   := 'insert into pessoas (nome, datanascimento, saldodevedor)'+
                                 ' values (:nome, :datanascimento, :saldodevedor)';

      for LPessoa in APessoaLista.RetornarListaPessoas do
      begin
        LPessoaQuery.ParamByName('nome').AsString             := LPessoa.Nome;
        LPessoaQuery.ParamByName('datanascimento').AsDateTime := LPessoa.DataNascimento;
        LPessoaQuery.ParamByName('saldodevedor').AsCurrency   := LPessoa.SaldoDevedor;
        LPessoaQuery.ExecSQL;
      end;
    finally
      LPessoaQuery.Free;
    end;    

    FConnection.Commit;
    Result := true;
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise Exception.Create('Erro ao gravar no banco: ' + E.Message);
    end;
  end;
end;

function TPessoaDAO.CarregarNaMemoria: TPessoaLista;
var
  LPessoaQuery: TFDQuery;
  LPessoa: TPessoa;
begin
  try
    LPessoaQuery := TFDQuery.Create(nil);

    try
      LPessoaQuery.Connection := FConnection;
      LPessoaQuery.SQL.Text   := 'select * from pessoas';
      LPessoaQuery.Open;

      while not LPessoaQuery.Eof do
      begin
        LPessoa                := TPessoa.Create;
        LPessoa.Codigo         := LPessoaQuery.FieldByName('codigo').AsInteger;
        LPessoa.Nome           := LPessoaQuery.FieldByName('nome').AsString;
        LPessoa.DataNascimento := LPessoaQuery.FieldByName('datanascimento').AsDateTime;
        LPessoa.SaldoDevedor   := LPessoaQuery.FieldByName('saldodevedor').AsCurrency;
        FPessoaLista.AdicionarPessoa(LPessoa);
        LPessoaQuery.Next;
      end;
                
    finally
      LPessoaQuery.Free;
    end;

    Result := FPessoaLista;    
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise Exception.Create('Erro ao carregar dados do banco: ' + E.Message);
    end;
  end;
end;

function TPessoaDAO.DeletarPorCodigo(ACodigo: Integer): Boolean;
var
  LDeletarQuery : TFDQuery;
begin
  Result := False;
  FConnection.StartTransaction;
  try
    LDeletarQuery := TFDQuery.Create(nil);
    try
      LDeletarQuery.Connection := FConnection;
      LDeletarQuery.SQL.Text   := 'delete from pessoas '+
                                  ' where codigo = :codigo';
                                  
      LDeletarQuery.ParamByName('codigo').AsInteger := ACodigo;
      LDeletarQuery.ExecSQL;                            
    finally
      LDeletarQuery.Free;
    end;

    FConnection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise Exception.Create('Erro ao deletar registro: ' + E.Message);
    end;
  end;  
end;

end.
