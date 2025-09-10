object frmMain: TfrmMain
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = 'نظام إدارة المخازن - الجيش المصري'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 80
    Align = alTop
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 250
      Top = 20
      Width = 400
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Caption = 'نظام إدارة المخازن'
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
    Width = 900
    Height = 100
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblSearchID: TLabel
      Left = 650
      Top = 35
      Width = 80
      Height = 19
      Caption = 'رقم القطعة:'
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
      Height = 27
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
      Caption = 'بحث'
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
    Width = 900
    Height = 80
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblWithdrawQty: TLabel
      Left = 650
      Top = 25
      Width = 85
      Height = 19
      Caption = 'الكمية:'
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
      Height = 27
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
      Caption = 'سحب'
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
      Caption = 'طباعة'
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
      Caption = 'إضافة قطعة'
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
    Width = 900
    Height = 300
    Align = alClient
    BiDiMode = bdRightToLeft
    ColCount = 5
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
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 560
    Width = 900
    Height = 40
    BiDiMode = bdRightToLeft
    Panels = <>
    ParentBiDiMode = False
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    BiDiMode = bdRightToLeft
    Left = 40
    Top = 190
    object mnuFile: TMenuItem
      Caption = 'ملف'
      object mnuAddItem: TMenuItem
        Caption = 'إضافة قطعة'
        OnClick = btnAddItemClick
      end
      object mnuSeparator1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'خروج'
        OnClick = mnuExitClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'مساعدة'
      object mnuAbout: TMenuItem
        Caption = 'حول البرنامج'
        OnClick = mnuAboutClick
      end
    end
  end
end