object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #216#170#216#179#216#172#217#352#217#8222' '#216#167#217#8222#216#175#216#174#217#710#217#8222' - '#217#8224#216#184#216#167#217#8230' '#216#165#216#175#216#167#216#177#216#169' '#216#167#217#8222#217#8230#216#174#216#167#216#178#217#8224
  ClientHeight = 337
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBiDiMode = False
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 337
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 348
    ExplicitHeight = 212
    object lblTitle: TLabel
      Left = 25
      Top = 30
      Width = 300
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = #217#8224#216#184#216#167#217#8230' '#216#165#216#175#216#167#216#177#216#169' '#216#167#217#8222#217#8230#216#174#216#167#216#178#217#8224' - '#216#167#217#8222#216#172#217#352#216#180' '#216#167#217#8222#217#8230#216#181#216#177#217#352
      Font.Charset = ARABIC_CHARSET
      Font.Color = clNavy
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPassword: TLabel
      Left = 93
      Top = 100
      Width = 217
      Height = 18
      Caption = #217#402#217#8222#217#8230#216#169' '#216#167#217#8222#217#8230#216#177#217#710#216#177':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtPassword: TEdit
      Left = 40
      Top = 100
      Width = 200
      Height = 26
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      OnKeyPress = edtPasswordKeyPress
    end
    object btnLogin: TButton
      Left = 140
      Top = 150
      Width = 100
      Height = 35
      Caption = #216#175#216#174#217#710#217#8222
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnLoginClick
    end
    object btnExit: TButton
      Left = 30
      Top = 150
      Width = 100
      Height = 35
      Caption = #216#174#216#177#217#710#216#172
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnExitClick
    end
  end
end
