unit uPessoaModel;

interface

uses
  System.Generics.Collections;

type

  TPessoa = class
  private
    FCodigo: Integer;
    FNome: String;
    FDataNascimento: TDateTime;
    FSaldoDevedor: Currency;
    FPessoas: TObjectList<TPessoa>;
  public
    constructor Create;
    destructor Destroy; override;
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: String read FNome write FNome;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property SaldoDevedor: Currency read FSaldoDevedor write FSaldoDevedor;
    property Pessoas: TObjectList<TPessoa> read FPessoas;
  end;

implementation

constructor TPessoa.Create;
begin
  FPessoas := TObjectList<TPessoa>.Create(true);
end;

destructor TPessoa.Destroy;
begin
  FPessoas.Free;
  inherited;
end;

end.
