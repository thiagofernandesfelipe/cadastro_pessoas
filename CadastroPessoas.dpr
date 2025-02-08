program CadastroPessoas;

uses
  Vcl.Forms,
  uCadastroPessoasView in 'Views\uCadastroPessoasView.pas' {frmCadastroPessoasView},
  uPessoaModel in 'Models\uPessoaModel.pas',
  uPessoaListaModel in 'Models\uPessoaListaModel.pas',
  uConexaoDAO in 'DAOs\uConexaoDAO.pas',
  uPessoaController in 'Controllers\uPessoaController.pas',
  uPessoaDAO in 'DAOs\uPessoaDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroPessoasView, frmCadastroPessoasView);
  Application.Run;
end.
