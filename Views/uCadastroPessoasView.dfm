object frmCadastroPessoasView: TfrmCadastroPessoasView
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Pessoas'
  ClientHeight = 519
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 519
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Parte 1'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 489
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 4
        ExplicitTop = 26
        DesignSize = (
          854
          489)
        object gbCadastro: TGroupBox
          Left = 16
          Top = 16
          Width = 818
          Height = 73
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Cadastro'
          TabOrder = 0
          object lblNome: TLabel
            Left = 16
            Top = 20
            Width = 33
            Height = 15
            Caption = 'Nome'
          end
          object lblDataNascimento: TLabel
            Left = 392
            Top = 20
            Width = 91
            Height = 15
            Caption = 'Data Nascimento'
          end
          object lblSaldoDevedor: TLabel
            Left = 527
            Top = 20
            Width = 76
            Height = 15
            Caption = 'Saldo Devedor'
          end
          object edtNome: TEdit
            Left = 16
            Top = 37
            Width = 361
            Height = 23
            TabOrder = 0
          end
          object dtpDataNascimento: TDateTimePicker
            Left = 392
            Top = 37
            Width = 113
            Height = 23
            Date = 45696.000000000000000000
            Time = 0.709105092595564200
            TabOrder = 1
          end
          object btnAdicionarPessoa: TButton
            Left = 648
            Top = 36
            Width = 143
            Height = 25
            Caption = 'Adicionar em mem'#243'ria'
            TabOrder = 3
            OnClick = btnAdicionarPessoaClick
          end
          object edtSaldoDevedor: TEdit
            Left = 528
            Top = 37
            Width = 105
            Height = 23
            TabOrder = 2
          end
        end
        object gbBancoDados: TGroupBox
          Left = 16
          Top = 104
          Width = 818
          Height = 73
          Caption = 'Banco de Dados'
          TabOrder = 1
          object btnGravarBanco: TButton
            Left = 16
            Top = 29
            Width = 233
            Height = 25
            Caption = 'Gravar (mem'#243'ria >> banco de dados)'
            TabOrder = 0
            OnClick = btnGravarBancoClick
          end
          object btnExcluir: TButton
            Left = 272
            Top = 29
            Width = 113
            Height = 25
            Caption = 'Excluir por Id'
            TabOrder = 1
            OnClick = btnExcluirClick
          end
          object btnCarregarMemoria: TButton
            Left = 408
            Top = 29
            Width = 241
            Height = 25
            Caption = 'Carregar (banco de dados >> mem'#243'ria)'
            TabOrder = 2
            OnClick = btnCarregarMemoriaClick
          end
        end
        object btnMostrarRegistros: TButton
          Left = 24
          Top = 197
          Width = 241
          Height = 25
          Caption = 'Mostrar "pessoas" em mem'#243'ria'
          TabOrder = 2
          OnClick = btnMostrarRegistrosClick
        end
        object lstPessoasMemoria: TListBox
          Left = 24
          Top = 240
          Width = 810
          Height = 233
          ItemHeight = 15
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Parte 2'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 489
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 432
        ExplicitTop = 160
        ExplicitWidth = 185
        ExplicitHeight = 41
        object btnBuscar: TButton
          Left = 16
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Buscar'
          TabOrder = 0
          OnClick = btnBuscarClick
        end
        object DBGrid1: TDBGrid
          Left = 16
          Top = 39
          Width = 825
          Height = 434
          DataSource = DataSource1
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
  end
  object FDMemTableApi: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 372
    Top = 98
  end
  object DataSource1: TDataSource
    DataSet = FDMemTableApi
    Left = 356
    Top = 210
  end
end
