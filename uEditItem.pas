unit uEditItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmEditItem = class(TForm)
    pnlMain: TPanel;
    lblItemID: TLabel;
    lblItemName: TLabel;
    lblQuantity: TLabel;
    lblPrice: TLabel;
    lblLocation: TLabel;
    edtItemID: TEdit;
    edtItemName: TEdit;
    edtQuantity: TEdit;
    edtPrice: TEdit;
    edtLocation: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtQuantityKeyPress(Sender: TObject; var Key: Char);
    procedure edtPriceKeyPress(Sender: TObject; var Key: Char);
  private
    FItemID: string;
  public
    procedure LoadItem(const ItemID, ItemName, Location: string;
      Quantity: Integer; Price: Currency);
    property ItemID: string read FItemID;
  end;

var
  frmEditItem: TfrmEditItem;

implementation

uses uDatabase;

{$R *.dfm}

procedure TfrmEditItem.FormCreate(Sender: TObject);
begin
  // إعدادات النموذج
  BiDiMode := bdRightToLeft;
  Position := poMainFormCenter;
  BorderStyle := bsDialog;

  // إعدادات الخط لدعم العربية
  Font.Name := 'Segoe UI';
  Font.Charset := ARABIC_CHARSET;

  // تعيين النصوص بالعربية
  Caption             := 'تعديل قطعة';
  lblItemID.Caption   := 'رقم القطعة:';
  lblItemName.Caption := 'اسم القطعة:';
  lblQuantity.Caption := 'الكمية:';
  lblPrice.Caption    := 'السعر:';
  lblLocation.Caption := 'مكان التخزين:';
  btnSave.Caption     := 'حفظ التغييرات';
  btnCancel.Caption   := 'إلغاء';

  // جعل رقم القطعة غير قابل للتحرير
  edtItemID.ReadOnly := True;
  edtItemID.Color := clBtnFace;
end;

procedure TfrmEditItem.LoadItem(const ItemID, ItemName, Location: string;
  Quantity: Integer; Price: Currency);
begin
  FItemID := ItemID;
  edtItemID.Text := ItemID;
  edtItemName.Text := ItemName;
  edtQuantity.Text := IntToStr(Quantity);
  edtPrice.Text := FormatFloat('0.00', Price);
  edtLocation.Text := Location;
end;

procedure TfrmEditItem.btnSaveClick(Sender: TObject);
var
  Qty: Integer;
  Price: Currency;
begin
  if Trim(edtItemName.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل اسم القطعة', mtWarning, [mbOK], 0);
    edtItemName.SetFocus;
    Exit;
  end;

  if not TryStrToInt(edtQuantity.Text, Qty) or (Qty < 0) then
  begin
    MessageDlg('من فضلك أدخل كمية صحيحة', mtWarning, [mbOK], 0);
    edtQuantity.SetFocus;
    Exit;
  end;

  if not TryStrToCurr(edtPrice.Text, Price) or (Price < 0) then
  begin
    MessageDlg('من فضلك أدخل سعر صحيح', mtWarning, [mbOK], 0);
    edtPrice.SetFocus;
    Exit;
  end;

  if Trim(edtLocation.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل مكان التخزين', mtWarning, [mbOK], 0);
    edtLocation.SetFocus;
    Exit;
  end;

  if DBManager.UpdateItem(FItemID, edtItemName.Text, edtLocation.Text, Qty, Price) then
  begin
    MessageDlg('تم تحديث بيانات القطعة بنجاح', mtInformation, [mbOK], 0);
    ModalResult := mrOk;
  end
  else
  begin
    MessageDlg('فشل في تحديث بيانات القطعة', mtError, [mbOK], 0);
  end;
end;

procedure TfrmEditItem.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmEditItem.edtQuantityKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmEditItem.edtPriceKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

end.