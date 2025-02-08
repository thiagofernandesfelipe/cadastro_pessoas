unit uPessoaListaModel;

interface

uses
  System.Generics.Collections, uPessoaModel;

type
  TPessoaLista = class
  private
    FPessoas: TObjectList<TPessoa>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AdicionarPessoa(APessoa: TPessoa);
    function RetornarListaPessoas: TObjectList<TPessoa>;
  end;

implementation

constructor TPessoaLista.Create;
begin
  FPessoas := TObjectList<TPessoa>.Create(True);
end;

destructor TPessoaLista.Destroy;
begin
  FPessoas.Free;
  inherited;
end;

procedure TPessoaLista.AdicionarPessoa(APessoa: TPessoa);
begin
  FPessoas.Add(APessoa);
end;

function TPessoaLista.RetornarListaPessoas: TObjectList<TPessoa>;
begin
  Result := FPessoas;
end;

end.
