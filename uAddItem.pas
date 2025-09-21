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
    FEditMode: Boolean;
    FOriginalItemID: string;
    procedure ClearFields;
    procedure SetupForm;
    procedure SetupArabicFont;
    function ValidateInputs: Boolean;
  public
    property EditMode: Boolean read FEditMode write FEditMode;
    property OriginalItemID: string read FOriginalItemID write FOriginalItemID;
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
  // في وضع الإضافة فقط، امسح الحقول
  if not FEditMode then
  begin
    ClearFields;
    if Assigned(edtItemID) then
      edtItemID.SetFocus;
  end
  else
  begin
    // في وضع التعديل، اجعل التركيز على حقل الاسم
    if Assigned(edtItemName) then
      edtItemName.SetFocus;
  end;
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

  // إعداد حقل رقم القطعة للإدخال اليدوي
  if Assigned(edtItemID) then
  begin
    edtItemID.ReadOnly := False;
    edtItemID.Color := clWindow;
    edtItemID.TabStop := True;
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
  Success: Boolean;
begin
  if not ValidateInputs then
    Exit;

  try
    if FEditMode then
    begin
      // في وضع التعديل - استخدم طريقة بسيطة
      if Trim(edtItemID.Text) = FOriginalItemID then
      begin
        // ID لم يتغير، حدث البيانات فقط
        Success := DBManager.UpdateItem(
          FOriginalItemID,
          Trim(edtItemName.Text),
          Trim(edtLocation.Text),
          StrToInt(edtQuantity.Text),
          StrToCurr(edtPrice.Text)
        );
      end
      else
      begin
        // ID تغير - احذف القديم وأضف جديد
        Success := DBManager.DeleteItem(FOriginalItemID) and
                   (DBManager.AddNewItemWithID(
                     Trim(edtItemID.Text),
                     Trim(edtItemName.Text),
                     Trim(edtLocation.Text),
                     StrToInt(edtQuantity.Text),
                     StrToCurr(edtPrice.Text)
                   ) <> '');
      end;

      if Success then
      begin
        MessageDlg('تم تحديث البيانات بنجاح!', mtInformation, [mbOK], 0);
        ModalResult := mrOk;
        Close;
      end
      else
      begin
        MessageDlg('حدث خطأ أثناء تحديث البيانات.',
                   mtError, [mbOK], 0);
      end;
    end
    else
    begin
      // في وضع الإضافة، قم بإضافة عنصر جديد
      NewItemID := DBManager.AddNewItemWithID(
        Trim(edtItemID.Text),
        Trim(edtItemName.Text),
        Trim(edtLocation.Text),
        StrToInt(edtQuantity.Text),
        StrToCurr(edtPrice.Text)
      );

      if NewItemID <> '' then
      begin
        MessageDlg('تم حفظ القطعة بنجاح برقم: ' + NewItemID,
                   mtInformation, [mbOK], 0);
        ModalResult := mrOk;
        Close;
      end
      else
      begin
        MessageDlg('حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى.',
                   mtError, [mbOK], 0);
      end;
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

  // التحقق من رقم القطعة
  if Trim(edtItemID.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل رقم القطعة', mtWarning, [mbOK], 0);
    if Assigned(edtItemID) then
      edtItemID.SetFocus;
    Exit;
  end;

  // التحقق من وجود رقم القطعة مسبقاً
  if FEditMode then
  begin
    // في وضع التعديل، تحقق فقط إذا تغير ID
    if (Trim(edtItemID.Text) <> FOriginalItemID) and DBManager.ItemIDExists(Trim(edtItemID.Text)) then
    begin
      MessageDlg('رقم القطعة موجود بالفعل! من فضلك استخدم رقم آخر', mtWarning, [mbOK], 0);
      if Assigned(edtItemID) then
      begin
        edtItemID.SelectAll;
        edtItemID.SetFocus;
      end;
      Exit;
    end;
  end
  else
  begin
    // في وضع الإضافة، تحقق من عدم وجود ID
    if DBManager.ItemIDExists(Trim(edtItemID.Text)) then
    begin
      MessageDlg('رقم القطعة موجود بالفعل! من فضلك استخدم رقم آخر', mtWarning, [mbOK], 0);
      if Assigned(edtItemID) then
      begin
        edtItemID.SelectAll;
        edtItemID.SetFocus;
      end;
      Exit;
    end;
  end;

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
    // مسح حقل رقم القطعة ليدخله المستخدم يدوياً
    if Assigned(edtItemID) then
      edtItemID.Clear;

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
