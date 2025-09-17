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
    procedure FormShow(Sender: TObject);
  private
    procedure ClearFields;
    procedure SetupForm;
    procedure SetupArabicFont;
    function ValidateInputs: Boolean;
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
  SetupForm;
  SetupArabicFont;
end;

procedure TfrmAddItem.FormShow(Sender: TObject);
begin
  // تحديث رقم القطعة عند عرض النموذج
  ClearFields;
  if Assigned(edtItemName) then
    edtItemName.SetFocus;
end;

procedure TfrmAddItem.SetupForm;
begin
  // إعدادات النموذج الأساسية
  BiDiMode := bdRightToLeft;
  Position := poMainFormCenter;
  BorderStyle := bsDialog;
  FormStyle := fsNormal;

  // تعيين النصوص بالعربية
  Caption             := 'إضافة قطعة جديدة - نظام إدارة المخازن';
  lblItemID.Caption   := 'رقم القطعة:';
  lblItemName.Caption := 'اسم القطعة:';
  lblQuantity.Caption := 'الكمية:';
  lblPrice.Caption    := 'السعر:';
  lblLocation.Caption := 'مكان التخزين:';
  btnSave.Caption     := 'حفظ';
  btnCancel.Caption   := 'إلغاء';

  // إعداد حقل رقم القطعة
  if Assigned(edtItemID) then
  begin
    edtItemID.ReadOnly := True;
    edtItemID.Color := clBtnFace;
    edtItemID.TabStop := False;
  end;

  // إعداد النص الافتراضي لمكان التخزين
  if Assigned(edtLocation) then
    edtLocation.Text := 'المخزن / الرف / الدرج';
end;

procedure TfrmAddItem.SetupArabicFont;
begin
  // إعداد الخط لدعم العربية
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Font.Charset := ARABIC_CHARSET;

  // تطبيق الخط على جميع العناصر
  if Assigned(pnlMain) then
    pnlMain.ParentFont := True;
end;

procedure TfrmAddItem.btnSaveClick(Sender: TObject);
var
  NewItemID: string;
begin
  if not ValidateInputs then
    Exit;

  try
    NewItemID := DBManager.AddNewItem(
      Trim(edtItemName.Text),
      Trim(edtLocation.Text),
      StrToInt(edtQuantity.Text),
      StrToCurr(edtPrice.Text)
    );

    if NewItemID <> '' then
    begin
      MessageDlg('تم حفظ القطعة بنجاح برقم: ' + NewItemID,
                 mtInformation, [mbOK], 0);
      // إغلاق النافذة بعد الحفظ الناجح
      ModalResult := mrOk;
      Close;
    end
    else
    begin
      MessageDlg('حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى.',
                 mtError, [mbOK], 0);
    end;
  except
    on E: Exception do
    begin
      MessageDlg('خطأ: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmAddItem.btnCancelClick(Sender: TObject);
begin
  Close;
end;

function TfrmAddItem.ValidateInputs: Boolean;
var
  Qty: Integer;
  Price: Currency;
begin
  Result := False;

  // التحقق من اسم القطعة
  if Trim(edtItemName.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل اسم القطعة', mtWarning, [mbOK], 0);
    if Assigned(edtItemName) then
      edtItemName.SetFocus;
    Exit;
  end;

  // التحقق من الكمية
  if not TryStrToInt(Trim(edtQuantity.Text), Qty) then
  begin
    MessageDlg('من فضلك أدخل كمية صحيحة (أرقام فقط)', mtWarning, [mbOK], 0);
    if Assigned(edtQuantity) then
    begin
      edtQuantity.SelectAll;
      edtQuantity.SetFocus;
    end;
    Exit;
  end;

  if Qty < 0 then
  begin
    MessageDlg('الكمية لا يمكن أن تكون أقل من صفر', mtWarning, [mbOK], 0);
    if Assigned(edtQuantity) then
    begin
      edtQuantity.SelectAll;
      edtQuantity.SetFocus;
    end;
    Exit;
  end;

  // التحقق من السعر
  if not TryStrToCurr(Trim(edtPrice.Text), Price) then
  begin
    MessageDlg('من فضلك أدخل سعر صحيح', mtWarning, [mbOK], 0);
    if Assigned(edtPrice) then
    begin
      edtPrice.SelectAll;
      edtPrice.SetFocus;
    end;
    Exit;
  end;

  if Price < 0 then
  begin
    MessageDlg('السعر لا يمكن أن يكون أقل من صفر', mtWarning, [mbOK], 0);
    if Assigned(edtPrice) then
    begin
      edtPrice.SelectAll;
      edtPrice.SetFocus;
    end;
    Exit;
  end;

  // التحقق من مكان التخزين
  if Trim(edtLocation.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل مكان التخزين', mtWarning, [mbOK], 0);
    if Assigned(edtLocation) then
      edtLocation.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmAddItem.edtQuantityKeyPress(Sender: TObject; var Key: Char);
begin
  // السماح بالأرقام فقط ومفتاح الحذف
  if not CharInSet(Key, ['0'..'9', #8, #13]) then
    Key := #0;

  // إذا تم الضغط على Enter، انتقل للحقل التالي
  if Key = #13 then
  begin
    Key := #0;
    if Assigned(edtPrice) then
      edtPrice.SetFocus;
  end;
end;

procedure TfrmAddItem.edtPriceKeyPress(Sender: TObject; var Key: Char);
begin
  // السماح بالأرقام والنقطة العشرية ومفتاح الحذف
  if not CharInSet(Key, ['0'..'9', '.', ',', #8, #13]) then
    Key := #0;

  // منع أكثر من نقطة عشرية واحدة
  if (Key = '.') or (Key = ',') then
  begin
    if (Pos('.', edtPrice.Text) > 0) or (Pos(',', edtPrice.Text) > 0) then
      Key := #0
    else
      Key := '.'; // توحيد استخدام النقطة
  end;

  // إذا تم الضغط على Enter، انتقل للحقل التالي
  if Key = #13 then
  begin
    Key := #0;
    if Assigned(edtLocation) then
      edtLocation.SetFocus;
  end;
end;

procedure TfrmAddItem.ClearFields;
begin
  try
    // الحصول على الرقم التالي وعرضه
    if Assigned(DBManager) and Assigned(edtItemID) then
    begin
      edtItemID.Text := DBManager.GetNextID;
      // للتأكد من أن الرقم يظهر
      edtItemID.Refresh;
    end
    else if Assigned(edtItemID) then
      edtItemID.Text := '1';

    if Assigned(edtItemName) then
      edtItemName.Clear;

    if Assigned(edtQuantity) then
      edtQuantity.Clear;

    if Assigned(edtPrice) then
      edtPrice.Clear;

    if Assigned(edtLocation) then
      edtLocation.Text := 'المخزن / الرف / الدرج';
  except
    on E: Exception do
    begin
      // في حالة حدوث خطأ، اعرض رسالة
      MessageDlg('خطأ في تحديث البيانات: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
