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

uses uDatabase;

{$R *.dfm}

procedure TfrmAddItem.FormCreate(Sender: TObject);
begin
  // إعدادات النموذج
  BiDiMode := bdRightToLeft;
  Position := poMainFormCenter;
  BorderStyle := bsDialog;

  // إعدادات الخط لدعم العربية
  Font.Name := 'Segoe UI';
  Font.Charset := ARABIC_CHARSET;

  // تعيين النصوص بالعربية هنا بدل الـ DFM
  Caption             := 'إضافة قطعة جديدة';
  lblItemID.Caption   := 'رقم القطعة:';
  lblItemName.Caption := 'اسم القطعة:';
  lblQuantity.Caption := 'الكمية:';
  lblPrice.Caption    := 'السعر:';
  lblLocation.Caption := 'مكان التخزين:';
  btnSave.Caption     := 'حفظ';
  btnCancel.Caption   := 'إلغاء';

  edtLocation.Text    := 'المخزن / الرف / الدرج';

  // عرض الرقم التالي وجعله غير قابل للتحرير
  edtItemID.ReadOnly := True;
  edtItemID.Color := clBtnFace;
  edtItemID.Text := DBManager.GetNextID;
end;

procedure TfrmAddItem.btnSaveClick(Sender: TObject);
var
  Qty: Integer;
  Price: Currency;
  NewItemID: string;
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

  NewItemID := DBManager.AddNewItem(edtItemName.Text, edtLocation.Text, Qty, Price);
  MessageDlg('تم حفظ القطعة برقم: ' + NewItemID, mtInformation, [mbOK], 0);
  ClearFields;
  edtItemName.SetFocus;
end;

procedure TfrmAddItem.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddItem.edtQuantityKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmAddItem.edtPriceKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

procedure TfrmAddItem.ClearFields;
begin
  edtItemID.Text := DBManager.GetNextID;
  edtItemName.Clear;
  edtQuantity.Clear;
  edtPrice.Clear;
  edtLocation.Text := 'المخزن / الرف / الدرج';
end;

end.

