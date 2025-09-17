object frmAddItem: TfrmAddItem
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  BorderStyle = bsDialog
  Caption = #216#165#216#182#216#167#217#129#216#169' '#217#8218#216#183#216#185#216#169' '#216#172#216#175#217#352#216#175#216#169
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
  OnShow = FormShow
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
      Left = 224
      Top = 30
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
    object lblItemName: TLabel
      Left = 222
      Top = 70
      Width = 183
      Height = 18
      Caption = #216#167#216#179#217#8230' '#216#167#217#8222#217#8218#216#183#216#185#216#169':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblQuantity: TLabel
      Left = 251
      Top = 110
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
    object lblPrice: TLabel
      Left = 289
      Top = 150
      Width = 96
      Height = 18
      Caption = #216#167#217#8222#216#179#216#185#216#177':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblLocation: TLabel
      Left = 187
      Top = 190
      Width = 233
      Height = 18
      Caption = #217#8230#217#402#216#167#217#8224' '#216#167#217#8222#216#170#216#174#216#178#217#352#217#8224':'
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtItemID: TEdit
      Left = 140
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
      TabOrder = 0
    end
    object edtItemName: TEdit
      Left = 140
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
      Left = 140
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
      Left = 140
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
      Left = 140
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
      Text = #216#167#217#8222#217#8230#216#174#216#178#217#8224' / '#216#167#217#8222#216#177#217#129' / '#216#167#217#8222#216#175#216#177#216#172
    end
    object btnSave: TButton
      Left = 240
      Top = 250
      Width = 100
      Height = 35
      Caption = #216#173#217#129#216#184
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
      Left = 130
      Top = 250
      Width = 100
      Height = 35
      Caption = #216#165#217#8222#216#186#216#167#216#161
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
