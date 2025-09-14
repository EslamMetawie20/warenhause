object frmCart: TfrmCart
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1575#1604#1608#1575'renkorb - '#1593#1585#1590' '#1575#1604#1593#1606#1575#1589#1585' '#1575#1604#1605#1581#1583#1583#1577
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  ParentBiDiMode = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 16
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = 15132390
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 20
      Top = 10
      Width = 300
      Height = 25
      Caption = #1575#1604#1608#1575'renkorb - '#1575#1604#1593#1606#1575#1589#1585' '#1575#1604#1605#1582#1578#1575#1585#1577
      Font.Charset = ARABIC_CHARSET
      Font.Color = 2825216
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSummary: TLabel
      Left = 20
      Top = 45
      Width = 400
      Height = 20
      Caption = #1575#1604#1605#1580#1605#1608#1593': 0 '#1593#1606#1589#1585' - 0.00 '#1580#1606#1610#1607
      Font.Charset = ARABIC_CHARSET
      Font.Color = 1402240
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 80
    Width = 700
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object StringGrid1: TStringGrid
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 680
      Height = 280
      Align = alClient
      BiDiMode = bdRightToLeft
      ColCount = 6
      DefaultRowHeight = 35
      FixedCols = 0
      RowCount = 2
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
      ParentBiDiMode = False
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = StringGrid1DrawCell
      OnSelectCell = StringGrid1SelectCell
      ColWidths = (
        90
        180
        80
        80
        120
        130)
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 380
    Width = 700
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    Color = 15132390
    ParentBackground = False
    TabOrder = 2
    object pnlQtyUpdate: TPanel
      Left = 0
      Top = 0
      Width = 700
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Color = 15132390
      ParentBackground = False
      TabOrder = 0
      object lblNewQty: TLabel
        Left = 20
        Top = 15
        Width = 80
        Height = 20
        Caption = #1578#1593#1583#1610#1604' '#1575#1604#1603#1605#1610#1577':'
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edtNewQty: TEdit
        Left = 110
        Top = 12
        Width = 80
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
        OnKeyPress = edtNewQtyKeyPress
      end
      object btnUpdateQty: TSpeedButton
        Left = 200
        Top = 10
        Width = 80
        Height = 29
        Caption = #1578#1581#1583#1610#1579
        Flat = True
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = btnUpdateQtyClick
      end
      object btnRemoveItem: TSpeedButton
        Left = 290
        Top = 10
        Width = 100
        Height = 29
        Caption = #1581#1584#1601' '#1575#1604#1593#1606#1589#1585
        Flat = True
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = btnRemoveItemClick
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 60
      Width = 700
      Height = 60
      Align = alBottom
      BevelOuter = bvNone
      Color = 15132390
      ParentBackground = False
      TabOrder = 1
      object btnCheckout: TButton
        Left = 20
        Top = 15
        Width = 120
        Height = 35
        Caption = #1578#1571#1603#1610#1583' '#1575#1604#1587#1581#1576
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnCheckoutClick
      end
      object btnClear: TButton
        Left = 150
        Top = 15
        Width = 120
        Height = 35
        Caption = #1573#1601#1585#1575#1594' '#1575#1604#1608#1575'renkorb'
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnClearClick
      end
      object btnClose: TButton
        Left = 280
        Top = 15
        Width = 80
        Height = 35
        Cancel = True
        Caption = #1573#1594#1604#1575#1602
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnCloseClick
      end
    end
  end
end