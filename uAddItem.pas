unit uAddItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAddItem = class(TForm)
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
    procedure ClearFields;
  public
    { Public declarations }
  end;

var
  frmAddItem: TfrmAddItem;

implementation

uses uDatabase, uArabicTexts;

{$R *.dfm}

procedure TfrmAddItem.FormCreate(Sender: TObject);
begin
  // إعدادات النموذج للغة العربية
  BiDiMode := bdRightToLeft;
  Position := poMainFormCenter;
  BorderStyle := bsDialog;
end;

procedure TfrmAddItem.btnSaveClick(Sender: TObject);
var
  Qty: Integer;
  Price: Currency;
begin
  // التحقق من البيانات
  if Trim(edtItemID.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل رقم القطعة', mtWarning, [mbOK], 0);
    edtItemID.SetFocus;
    Exit;
  end;
  
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
  
  // حفظ البيانات
  if DBManager.AddNewItem(edtItemID.Text, edtItemName.Text, edtLocation.Text, Qty, Price) then
  begin
    MessageDlg('تم حفظ القطعة بنجاح', mtInformation, [mbOK], 0);
    ClearFields;
    edtItemID.SetFocus;
  end
  else
  begin
    MessageDlg('رقم القطعة موجود بالفعل', mtError, [mbOK], 0);
  end;
end;

procedure TfrmAddItem.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddItem.edtQuantityKeyPress(Sender: TObject; var Key: Char);
begin
  // السماح بالأرقام فقط
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmAddItem.edtPriceKeyPress(Sender: TObject; var Key: Char);
begin
  // السماح بالأرقام والنقطة العشرية
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

procedure TfrmAddItem.ClearFields;
begin
  edtItemID.Clear;
  edtItemName.Clear;
  edtQuantity.Clear;
  edtPrice.Clear;
  edtLocation.Text := 'المخزن / الرف / الدرج';
end;

end.