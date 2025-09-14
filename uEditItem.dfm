object frmEditItem: TfrmEditItem
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderStyle = bsDialog
  Caption = #1578#1593#1583#1610#1604' '#1602#1591#1593#1577
  ClientHeight = 350
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblItemID: TLabel
      Left = 300
      Top = 30
      Width = 120
      Height = 18
      Caption = #1585#1602#1605' '#1575#1604#1602#1591#1593#1577':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblItemName: TLabel
      Left = 300
      Top = 70
      Width = 120
      Height = 18
      Caption = #1575#1587#1605' '#1575#1604#1602#1591#1593#1577':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblQuantity: TLabel
      Left = 300
      Top = 110
      Width = 120
      Height = 18
      Caption = #1575#1604#1603#1605#1610#1577':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblPrice: TLabel
      Left = 300
      Top = 150
      Width = 120
      Height = 18
      Caption = #1575#1604#1587#1593#1585':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblLocation: TLabel
      Left = 300
      Top = 190
      Width = 120
      Height = 18
      Caption = #1605#1603#1575#1606' '#1575#1604#1578#1582#1586#1610#1606':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtItemID: TEdit
      Left = 70
      Top = 30
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
      ReadOnly = True
      TabOrder = 0
    end
    object edtItemName: TEdit
      Left = 70
      Top = 70
      Width = 200
      Height = 26
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtQuantity: TEdit
      Left = 70
      Top = 110
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
      TabOrder = 2
      OnKeyPress = edtQuantityKeyPress
    end
    object edtPrice: TEdit
      Left = 70
      Top = 150
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
      TabOrder = 3
      OnKeyPress = edtPriceKeyPress
    end
    object edtLocation: TEdit
      Left = 70
      Top = 190
      Width = 200
      Height = 26
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object btnSave: TButton
      Left = 280
      Top = 250
      Width = 120
      Height = 35
      Caption = #1581#1601#1592' '#1575#1604#1578#1594#1610#1610#1585#1575#1578
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 150
      Top = 250
      Width = 100
      Height = 35
      Caption = #1573#1604#1594#1575#1569
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnCancelClick
    end
  end
end