object frmMain: TfrmMain
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = #1606#1592#1575#1605' '#1573#1583#1575#1585#1577' '#1575#1604#1605#1582#1575#1586#1606' - '#1575#1604#1580#1610#1588' '#1575#1604#1605#1589#1585#1610
  ClientHeight = 700
  ClientWidth = 1200
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
  OnDestroy = FormDestroy
  OnResize = FormResize
  TextHeight = 16

  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = 2825232
    ParentBackground = False
    TabOrder = 0
    object imgLogo: TImage
      Left = 20
      Top = 10
      Width = 60
      Height = 60
      Proportional = True
      Stretch = True
    end
    object lblSystemTitle: TLabel
      Left = 100
      Top = 15
      Width = 500
      Height = 30
      Alignment = taLeftJustify
      Caption = #1606#1592#1575#1605' '#1573#1583#1575#1585#1577' '#1602#1591#1593' '#1575#1604#1594#1610#1575#1585' - '#1575#1604#1602#1608#1575#1578' '#1575#1604#1605#1587#1604#1581#1577' '#1575#1604#1605#1589#1585#1610#1577
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDateTime: TLabel
      Left = 1000
      Top = 45
      Width = 180
      Height = 20
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Date Time'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clSilver
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end

  object pnlContent: TPanel
    Left = 0
    Top = 80
    Width = 1200
    Height = 595
    Align = alClient
    BevelOuter = bvNone
    Color = 15855609
    ParentBackground = False
    TabOrder = 1
    object pnlSidebar: TPanel
      Left = 880
      Top = 0
      Width = 320
      Height = 595
      Align = alRight
      BevelOuter = bvNone
      Color = 15263976
      ParentBackground = False
      TabOrder = 0
      object pnlSearchSection: TPanel
        Left = 10
        Top = 10
        Width = 300
        Height = 140
        AlignWithMargins = True
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lblSearchID: TLabel
          Left = 20
          Top = 45
          Width = 80
          Height = 20
          Caption = #1585#1602#1605' '#1575#1604#1602#1591#1593#1577':'
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edtSearchID: TEdit
          Left = 20
          Top = 70
          Width = 180
          Height = 25
          BiDiMode = bdRightToLeft
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 0
          OnKeyPress = edtSearchIDKeyPress
        end
        object btnSearch: TSpeedButton
          Left = 210
          Top = 68
          Width = 80
          Height = 29
          Caption = #1576#1581#1579
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btnSearchClick
        end
        object btnShowAll: TSpeedButton
          Left = 20
          Top = 105
          Width = 270
          Height = 29
          Caption = #1593#1585#1590' '#1575#1604#1603#1604
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btnShowAllClick
        end
      end
      object pnlWithdrawSection: TPanel
        Left = 10
        Top = 155
        Width = 300
        Height = 120
        AlignWithMargins = True
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object lblWithdrawQty: TLabel
          Left = 20
          Top = 45
          Width = 80
          Height = 20
          Caption = #1575#1604#1603#1605#1610#1577':'
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edtWithdrawQty: TEdit
          Left = 20
          Top = 70
          Width = 180
          Height = 25
          BiDiMode = bdRightToLeft
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 0
        end
        object btnAddToCart: TButton
          Left = 210
          Top = 68
          Width = 80
          Height = 29
          Caption = #1573#1590#1575#1601#1577' '#1604#1604#1608#1575'renkorb'
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnAddToCartClick
        end
      end
      object pnlCartSection: TPanel
        Left = 10
        Top = 285
        Width = 300
        Height = 140
        AlignWithMargins = True
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object lblCartStatus: TLabel
          Left = 20
          Top = 45
          Width = 270
          Height = 20
          Caption = #1575#1604#1608#1575'renkorb '#1601#1575#1585#1594
          Font.Charset = ARABIC_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnViewCart: TButton
          Left = 20
          Top = 70
          Width = 130
          Height = 35
          Caption = #1593#1585#1590' '#1575#1604#1608#1575'renkorb'
          Enabled = False
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnViewCartClick
        end
        object btnClearCart: TSpeedButton
          Left = 160
          Top = 68
          Width = 80
          Height = 29
          Caption = #1573#1601#1585#1575#1594
          Enabled = False
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = btnClearCartClick
        end
      end
      object pnlActionsSection: TPanel
        Left = 10
        Top = 435
        Width = 300
        Height = 180
        AlignWithMargins = True
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object btnAddItem: TSpeedButton
          Left = 20
          Top = 45
          Width = 270
          Height = 35
          Caption = #1573#1590#1575#1601#1577' '#1602#1591#1593#1577' '#1580#1583#1610#1583#1577
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btnAddItemClick
        end
        object btnPrintReceipt: TButton
          Left = 20
          Top = 90
          Width = 270
          Height = 35
          Caption = #1591#1576#1575#1593#1577' '#1573#1610#1589#1575#1604' '#1575#1604#1587#1581#1576
          Enabled = False
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnPrintReceiptClick
        end
        object btnExport: TButton
          Left = 20
          Top = 135
          Width = 270
          Height = 35
          Caption = #1578#1589#1583#1610#1585' '#1575#1604#1576#1610#1575#1606#1575#1578
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnExportClick
        end
      end
    end
    object pnlMainContent: TPanel
      Left = 0
      Top = 0
      Width = 880
      Height = 595
      Align = alClient
      BevelOuter = bvNone
      Color = 15855609
      ParentBackground = False
      TabOrder = 1
      object pnlGridHeader: TPanel
        Left = 0
        Top = 0
        Width = 880
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        Color = 13882323
        ParentBackground = False
        TabOrder = 0
        object lblGridTitle: TLabel
          Left = 20
          Top = 10
          Width = 200
          Height = 20
          Alignment = taLeftJustify
          Caption = #1602#1575#1574#1605#1577' '#1602#1591#1593' '#1575#1604#1594#1610#1575#1585
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblRecordCount: TLabel
          Left = 710
          Top = 10
          Width = 150
          Height = 20
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1593#1583#1583' '#1575#1604#1587#1580#1604#1575#1578': 0'
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
      end
      object StringGrid1: TStringGrid
        Left = 10
        Top = 50
        Width = 860
        Height = 535
        Align = alClient
        AlignWithMargins = True
        BiDiMode = bdRightToLeft
        ColCount = 5
        DefaultRowHeight = 35
        FixedColor = 4868682
        FixedRows = 1
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
        ParentBiDiMode = False
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
        OnDrawCell = StringGrid1DrawCell
      end
    end
  end

  object pnlFooter: TPanel
    Left = 0
    Top = 675
    Width = 1200
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    Color = 15263976
    ParentBackground = False
    TabOrder = 2
    object StatusBar1: TStatusBar
      Left = 0
      Top = 0
      Width = 1200
      Height = 25
      BiDiMode = bdRightToLeft
      Color = 15263976
      Panels = <>
      ParentBiDiMode = False
      SimplePanel = True
    end
  end

  object tmrClock: TTimer
    Enabled = False
    OnTimer = tmrClockTimer
    Left = 72
    Top = 200
  end

  object MainMenu1: TMainMenu
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Left = 40
    Top = 190
    object mnuFile: TMenuItem
      Caption = #1605#1604#1601
      object mnuAddItem: TMenuItem
        Caption = #1573#1590#1575#1601#1577' '#1602#1591#1593#1577' '#1580#1583#1610#1583#1577
        OnClick = btnAddItemClick
      end
      object mnuExport: TMenuItem
        Caption = #1578#1589#1583#1610#1585' '#1575#1604#1576#1610#1575#1606#1575#1578
        OnClick = btnExportClick
      end
      object mnuSeparator1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = #1582#1585#1608#1580
        OnClick = mnuExitClick
      end
    end
    object mnuView: TMenuItem
      Caption = #1593#1585#1590
      object mnuRefresh: TMenuItem
        Caption = #1578#1581#1583#1610#1579
        OnClick = mnuRefreshClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = #1605#1587#1575#1593#1583#1577
      object mnuAbout: TMenuItem
        Caption = #1581#1608#1604' '#1575#1604#1576#1585#1606#1575#1605#1580
        OnClick = mnuAboutClick
      end
    end
  end
end