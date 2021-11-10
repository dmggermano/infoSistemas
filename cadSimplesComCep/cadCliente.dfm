object fCadClienteComCep: TfCadClienteComCep
  Left = 0
  Top = 0
  Caption = 'Cadastro Cliente Simplificado'
  ClientHeight = 568
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 41
    Align = alTop
    Caption = 'Cadastro Cliente Simplificado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 499
    Width = 774
    Height = 69
    Align = alBottom
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 6
      Width = 193
      Height = 51
      Caption = 'Enviar Novamente Registro'
    end
    object Label14: TLabel
      Left = 160
      Top = 16
      Width = 132
      Height = 13
      Caption = 'E-Mail de Destino Arq. XML:'
    end
    object Edit1: TEdit
      Left = 298
      Top = 13
      Width = 369
      Height = 21
      TabOrder = 0
      Text = 'emailDestinoArqXML@teste.com.br'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 774
    Height = 458
    Align = alClient
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 351
      Width = 772
      Height = 12
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 201
      ExplicitWidth = 573
    end
    object Panel4: TPanel
      Left = 1
      Top = 363
      Width = 772
      Height = 94
      Align = alBottom
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 770
        Height = 67
        Align = alClient
        DataSource = dsCadCliente
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 68
        Width = 770
        Height = 25
        DataSource = dsCadCliente
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alBottom
        TabOrder = 1
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 772
      Height = 350
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 24
        Top = 5
        Width = 116
        Height = 19
        Caption = 'Nome Cliente:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 45
        Top = 37
        Width = 95
        Height = 19
        Caption = 'Identidade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 492
        Top = 37
        Width = 37
        Height = 19
        Caption = 'CPF:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 62
        Top = 70
        Width = 78
        Height = 19
        Caption = 'Telefone:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 83
        Top = 102
        Width = 57
        Height = 19
        Caption = 'E-Mail:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 102
        Top = 135
        Width = 38
        Height = 19
        Caption = 'CEP:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 41
        Top = 168
        Width = 99
        Height = 19
        Caption = 'Logradouro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 78
        Top = 265
        Width = 62
        Height = 19
        Caption = 'Cidade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 79
        Top = 298
        Width = 61
        Height = 19
        Caption = 'Estado:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 412
        Top = 298
        Width = 40
        Height = 19
        Caption = 'Pais:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 84
        Top = 232
        Width = 56
        Height = 19
        Caption = 'Bairro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 333
        Top = 201
        Width = 119
        Height = 19
        Caption = 'Complemento:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 70
        Top = 202
        Width = 70
        Height = 19
        Caption = 'N'#250'mero:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Panel6: TPanel
        Left = 1
        Top = 307
        Width = 770
        Height = 42
        Align = alBottom
        TabOrder = 5
        object SpeedButton2: TSpeedButton
          Left = 6
          Top = 8
          Width = 113
          Height = 29
          Caption = 'Incluir Dados'
          OnClick = SpeedButton2Click
        end
      end
      object edtTelefone: TMaskEdit
        Left = 146
        Top = 67
        Width = 109
        Height = 24
        EditMask = '!\(00\)0000-00009;0;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 14
        ParentFont = False
        TabOrder = 3
        Text = ''
        OnExit = edtTelefoneExit
      end
      object edtCPF: TMaskEdit
        Tag = 1
        Left = 535
        Top = 34
        Width = 110
        Height = 24
        EditMask = '000.000.000-00;0;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 14
        ParentFont = False
        TabOrder = 2
        Text = ''
        OnExit = edtCPFExit
      end
      object edtEmail: TEdit
        Left = 146
        Top = 99
        Width = 503
        Height = 27
        TabOrder = 4
        OnExit = edtEmailExit
      end
      object edtNome: TEdit
        Tag = 1
        Left = 146
        Top = 2
        Width = 503
        Height = 27
        TabOrder = 0
        OnDblClick = edtNomeDblClick
      end
      object edtIdentidade: TEdit
        Left = 146
        Top = 34
        Width = 121
        Height = 27
        TabOrder = 1
      end
      object edtLogradouro: TEdit
        Tag = 1
        Left = 146
        Top = 165
        Width = 503
        Height = 27
        TabOrder = 7
      end
      object edtBairro: TEdit
        Tag = 1
        Left = 146
        Top = 229
        Width = 503
        Height = 27
        TabOrder = 10
      end
      object edtCidade: TEdit
        Tag = 1
        Left = 146
        Top = 262
        Width = 503
        Height = 27
        TabOrder = 11
      end
      object edtUF: TEdit
        Tag = 1
        Left = 146
        Top = 295
        Width = 39
        Height = 27
        TabOrder = 12
        OnExit = edtUFExit
      end
      object edtPais: TEdit
        Tag = 1
        Left = 458
        Top = 295
        Width = 191
        Height = 27
        TabOrder = 13
      end
      object edtCEP: TMaskEdit
        Tag = 1
        Left = 146
        Top = 132
        Width = 108
        Height = 24
        EditMask = '00000-000;0;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 9
        ParentFont = False
        TabOrder = 6
        Text = ''
        OnExit = edtCEPExit
      end
      object edtComplemento: TEdit
        Left = 458
        Top = 196
        Width = 191
        Height = 27
        TabOrder = 9
      end
      object edtNumero: TEdit
        Tag = 1
        Left = 146
        Top = 196
        Width = 181
        Height = 27
        TabOrder = 8
      end
    end
  end
  object dsCadCliente: TDataSource
    DataSet = fdCliente
    Left = 409
    Top = 97
  end
  object fdCliente: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 497
    Top = 98
    object fdClientenome: TStringField
      FieldName = 'nome'
      Size = 50
    end
    object fdClienteidentidade: TStringField
      FieldName = 'identidade'
      Size = 50
    end
    object fdClientecpf: TStringField
      FieldName = 'cpf'
      Size = 11
    end
    object fdClientetelefone: TStringField
      FieldName = 'telefone'
      Size = 11
    end
    object fdClienteemail: TStringField
      FieldName = 'email'
      Size = 60
    end
    object fdClientecep: TStringField
      FieldName = 'cep'
      Size = 8
    end
    object fdClientelogradouro: TStringField
      FieldName = 'logradouro'
      Size = 30
    end
    object fdClientenumero: TStringField
      FieldName = 'numero'
      Size = 10
    end
    object fdClientecomplemento: TStringField
      FieldName = 'complemento'
      Size = 30
    end
    object fdClientebairro: TStringField
      FieldName = 'bairro'
      Size = 50
    end
    object fdClientecidade: TStringField
      FieldName = 'cidade'
      Size = 50
    end
    object fdClienteestado: TStringField
      FieldName = 'estado'
      Size = 2
    end
    object fdClientepais: TStringField
      FieldName = 'pais'
      Size = 50
    end
    object fdClientetransmissao: TStringField
      FieldName = 'transmissao'
      Size = 2
    end
  end
end
