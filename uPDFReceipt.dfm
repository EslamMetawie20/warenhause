object frmReceiptDialog: TfrmReceiptDialog
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1573#1610#1589#1575#1604' '#1587#1581#1576' '#1602#1591#1593' '#1575#1604#1594#1610#1575#1585
  ClientHeight = 600
  ClientWidth = 800
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
  TextHeight = 16
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 2825216
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 800
      Height = 50
      Align = alClient
      Alignment = taCenter
      Caption = #1573#1610#1589#1575#1604' '#1587#1581#1576' '#1602#1591#1593' '#1575#1604#1594#1610#1575#1585' - '#1575#1604#1602#1608#1575#1578' '#1575#1604#1605#1587#1604#1581#1577' '#1575#1604#1605#1589#1585#1610#1577
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 490
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object memoReceipt: TMemo
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 780
      Height = 470
      Align = alClient
      BiDiMode = bdRightToLeft
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 540
    Width = 800
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = 15132390
    ParentBackground = False
    TabOrder = 2
    object btnSavePDF: TButton
      Left = 20
      Top = 15
      Width = 100
      Height = 35
      Caption = #1581#1601#1592' '#1603#1600' PDF
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSavePDFClick
    end
    object btnPrint: TButton
      Left = 130
      Top = 15
      Width = 80
      Height = 35
      Caption = #1591#1576#1575#1593#1577
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnCopy: TButton
      Left = 220
      Top = 15
      Width = 80
      Height = 35
      Caption = #1606#1587#1582
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCopyClick
    end
    object btnClose: TButton
      Left = 310
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
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1605#1604#1601#1575#1578' '#1606#1589#1610#1577' (*.txt)|*.txt|'#1580#1605#1610#1593' '#1575#1604#1605#1604#1601#1575#1578' (*.*)|*.*'
    Left = 720
    Top = 16
  end
end