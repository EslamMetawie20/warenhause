object frmMain: TfrmMain
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = #217#8224#216#184#216#167#217#8230' '#216#165#216#175#216#167#216#177#216#169' '#216#167#217#8222#217#8230#216#174#216#167#216#178#217#8224' - '#216#167#217#8222#216#172#217#352#216#180' '#216#167#217#8222#217#8230#216#181#216#177#217#352
  ClientHeight = 600
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  ParentBiDiMode = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 80
    Align = alTop
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 900
    object lblTitle: TLabel
      Left = 250
      Top = 20
      Width = 400
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Caption = #217#8224#216#184#216#167#217#8230' '#216#165#216#175#216#167#216#177#216#169' '#216#167#217#8222#217#8230#216#174#216#167#216#178#217#8224
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWhite
      Font.Height = -32
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlSearch: TPanel
    Left = 0
    Top = 80
    Width = 884
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 900
    object lblSearchID: TLabel
      Left = 549
      Top = 35
      Width = 181
      Height = 18
      Caption = #216#177#217#8218#217#8230' '#216#167#217#8222#217#8218#216#183#216#185#216#169':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtSearchID: TEdit
      Left = 440
      Top = 35
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
      TabOrder = 0
      OnKeyPress = edtSearchIDKeyPress
    end
    object btnSearch: TButton
      Left = 330
      Top = 32
      Width = 100
      Height = 35
      Caption = #216#168#216#173#216#171
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnSearchClick
    end
  end
  object pnlWithdraw: TPanel
    Left = 0
    Top = 480
    Width = 884
    Height = 80
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 900
    object lblWithdrawQty: TLabel
      Left = 601
      Top = 25
      Width = 134
      Height = 18
      Caption = #216#167#217#8222#217#402#217#8230#217#352#216#169':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtWithdrawQty: TEdit
      Left = 540
      Top = 25
      Width = 100
      Height = 26
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
    end
    object btnWithdraw: TButton
      Left = 430
      Top = 22
      Width = 100
      Height = 35
      Caption = #216#179#216#173#216#168
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnWithdrawClick
    end
    object btnPrintReceipt: TButton
      Left = 300
      Top = 22
      Width = 120
      Height = 35
      Caption = #216#183#216#168#216#167#216#185#216#169
      Enabled = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnPrintReceiptClick
    end
    object btnAddItem: TButton
      Left = 140
      Top = 22
      Width = 150
      Height = 35
      Caption = #216#165#216#182#216#167#217#129#216#169' '#217#8218#216#183#216#185#216#169
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnAddItemClick
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 180
    Width = 884
    Height = 300
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BiDiMode = bdRightToLeft
    DefaultColWidth = 150
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 2
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 174
    ExplicitWidth = 900
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 560
    Width = 884
    Height = 40
    BiDiMode = bdRightToLeft
    Panels = <>
    ParentBiDiMode = False
    SimplePanel = True
    ExplicitWidth = 900
  end
  object MainMenu1: TMainMenu
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Left = 40
    Top = 190
    object mnuFile: TMenuItem
      Caption = #217#8230#217#8222#217#129
      object mnuAddItem: TMenuItem
        Caption = #216#165#216#182#216#167#217#129#216#169' '#217#8218#216#183#216#185#216#169
        OnClick = btnAddItemClick
      end
      object mnuSeparator1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = #216#174#216#177#217#710#216#172
        OnClick = mnuExitClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = #217#8230#216#179#216#167#216#185#216#175#216#169
      object mnuAbout: TMenuItem
        Caption = #216#173#217#710#217#8222' '#216#167#217#8222#216#168#216#177#217#8224#216#167#217#8230#216#172
        OnClick = mnuAboutClick
      end
    end
  end
end
