object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'تسجيل الدخول - نظام إدارة المخازن'
  ClientHeight = 220
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 350
    Height = 220
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 25
      Top = 30
      Width = 300
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = 'نظام إدارة المخازن - الجيش المصري'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clNavy
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPassword: TLabel
      Left = 250
      Top = 100
      Width = 60
      Height = 19
      Caption = 'كلمة المرور:'
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
      Height = 27
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
      Caption = 'دخول'
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
      Caption = 'خروج'
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