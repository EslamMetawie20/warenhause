unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus, Vcl.Grids;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    pnlSearch: TPanel;
    pnlWithdraw: TPanel;
    lblTitle: TLabel;
    lblSearchID: TLabel;
    edtSearchID: TEdit;
    btnSearch: TButton;
    lblWithdrawQty: TLabel;
    edtWithdrawQty: TEdit;
    btnWithdraw: TButton;
    btnAddItem: TButton;
    btnPrintReceipt: TButton;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuAddItem: TMenuItem;
    mnuSeparator1: TMenuItem;
    mnuExit: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edtSearchIDKeyPress(Sender: TObject; var Key: Char);
    procedure btnWithdrawClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnPrintReceiptClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCurrentItemID: string;
    FLastWithdrawDetails: string;
    procedure UpdateStatus(const Msg: string);
    procedure LoadAllItems;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uDatabase, uAddItem, uReceipt, uArabicTexts;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // إعدادات النموذج للغة العربية
  BiDiMode := bdRightToLeft;
  Caption := GetArabicText('FORM_MAIN');
  Position := poScreenCenter;
  WindowState := wsMaximized;
  
  // إعدادات اللوحة العلوية
  pnlTop.Align := alTop;
  pnlTop.Height := 80;
  pnlTop.Color := clNavy;
  pnlTop.Font.Color := clWhite;
  
  // عنوان النظام
  lblTitle.Parent := pnlTop;
  lblTitle.Caption := GetArabicText('SYSTEM_TITLE');
  lblTitle.Font.Name := 'Arial';
  lblTitle.Font.Size := 24;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := clWhite;
  lblTitle.Alignment := taCenter;
  
  // لوحة البحث
  pnlSearch.Align := alTop;
  pnlSearch.Height := 100;
  pnlSearch.BevelOuter := bvNone;
  
  // لوحة السحب
  pnlWithdraw.Align := alBottom;
  pnlWithdraw.Height := 80;
  pnlWithdraw.BevelOuter := bvNone;
  
  // Setup grid
  StringGrid1.Align := alClient;
  StringGrid1.BiDiMode := bdRightToLeft;
  StringGrid1.Font.Name := 'Arial';
  StringGrid1.Font.Size := 12;
  StringGrid1.ColCount := 5;
  StringGrid1.RowCount := 2;
  StringGrid1.FixedRows := 1;
  StringGrid1.DefaultRowHeight := 30;
  StringGrid1.DefaultColWidth := 150;
  
  // تحديث عناوين النموذج والشبكة
  
  StringGrid1.Cells[0, 0] := 'رقم القطعة';
  StringGrid1.Cells[1, 0] := 'اسم القطعة';
  StringGrid1.Cells[2, 0] := 'الكمية المتاحة';
  StringGrid1.Cells[3, 0] := 'مكان التخزين';
  StringGrid1.Cells[4, 0] := 'السعر';
  
  
  // شريط الحالة
  StatusBar1.SimplePanel := True;
  StatusBar1.BiDiMode := bdRightToLeft;
  UpdateStatus('مرحباً بك في نظام إدارة المخازن');
  
  // تحميل جميع القطع
  LoadAllItems;
end;

procedure TfrmMain.LoadAllItems;
var
  Items: TList;
  I: Integer;
  Item: ^TSparePartItem;
begin
  Items := DBManager.GetAllItems;
  StringGrid1.RowCount := Items.Count + 1;
  
  if Items.Count = 0 then
    StringGrid1.RowCount := 2;
    
  for I := 0 to Items.Count - 1 do
  begin
    Item := Items[I];
    StringGrid1.Cells[0, I + 1] := Item^.ItemID;
    StringGrid1.Cells[1, I + 1] := Item^.ItemName;
    StringGrid1.Cells[2, I + 1] := IntToStr(Item^.Quantity);
    StringGrid1.Cells[3, I + 1] := Item^.Location;
    StringGrid1.Cells[4, I + 1] := FormatFloat('0.00', Item^.Price);
  end;
end;

procedure TfrmMain.btnSearchClick(Sender: TObject);
var
  Item: TSparePartItem;
begin
  if Trim(edtSearchID.Text) = '' then
  begin
    MessageDlg('من فضلك أدخل رقم القطعة', mtWarning, [mbOK], 0);
    edtSearchID.SetFocus;
    Exit;
  end;
  
  FCurrentItemID := edtSearchID.Text;
  Item := DBManager.FindItem(FCurrentItemID);
  
  if Item.ItemID <> '' then
  begin
    // عرض القطعة المطلوبة فقط
    StringGrid1.RowCount := 2;
    StringGrid1.Cells[0, 1] := Item.ItemID;
    StringGrid1.Cells[1, 1] := Item.ItemName;
    StringGrid1.Cells[2, 1] := IntToStr(Item.Quantity);
    StringGrid1.Cells[3, 1] := Item.Location;
    StringGrid1.Cells[4, 1] := FormatFloat('0.00', Item.Price);
    
    UpdateStatus('تم العثور على القطعة');
    edtWithdrawQty.SetFocus;
  end
  else
  begin
    UpdateStatus('القطعة غير موجودة في المخزن');
    MessageDlg('القطعة غير موجودة في المخزن', mtInformation, [mbOK], 0);
  end;
end;

procedure TfrmMain.edtSearchIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
    Key := #0;
  end;
end;

procedure TfrmMain.btnWithdrawClick(Sender: TObject);
var
  Qty: Integer;
  ItemName, Location: string;
  AvailableQty: Integer;
  Price: Currency;
begin
  if FCurrentItemID = '' then
  begin
    MessageDlg('من فضلك ابحث عن قطعة أولاً', mtWarning, [mbOK], 0);
    Exit;
  end;
  
  if not TryStrToInt(edtWithdrawQty.Text, Qty) or (Qty <= 0) then
  begin
    MessageDlg('من فضلك أدخل كمية صحيحة', mtWarning, [mbOK], 0);
    edtWithdrawQty.SetFocus;
    Exit;
  end;
  
  if DBManager.GetItemDetails(FCurrentItemID, ItemName, Location, AvailableQty, Price) then
  begin
    if Qty > AvailableQty then
    begin
      MessageDlg(Format('الكمية المطلوبة (%d) أكبر من المتاح (%d)', [Qty, AvailableQty]), 
        mtWarning, [mbOK], 0);
      Exit;
    end;
    
    if DBManager.WithdrawItem(FCurrentItemID, Qty) then
    begin
      FLastWithdrawDetails := Format(
        'رقم القطعة: %s'#13#10 +
        'اسم القطعة: %s'#13#10 +
        'الكمية المسحوبة: %d'#13#10 +
        'السعر الإجمالي: %.2f جنيه'#13#10 +
        'التاريخ: %s'#13#10 +
        'الوقت: %s',
        [FCurrentItemID, ItemName, Qty, Price * Qty, 
         DateToStr(Now), TimeToStr(Now)]
      );
      
      UpdateStatus('تم سحب القطع بنجاح');
      MessageDlg('تمت عملية السحب بنجاح', mtInformation, [mbOK], 0);
      btnPrintReceipt.Enabled := True;
      
      // تحديث الشبكة
      btnSearchClick(nil);
      edtWithdrawQty.Clear;
    end
    else
    begin
      MessageDlg('فشلت عملية السحب', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMain.btnAddItemClick(Sender: TObject);
begin
  if not Assigned(frmAddItem) then
    Application.CreateForm(TfrmAddItem, frmAddItem);
  frmAddItem.ShowModal;
  LoadAllItems; // تحديث القائمة بعد الإضافة
end;

procedure TfrmMain.btnPrintReceiptClick(Sender: TObject);
begin
  if FLastWithdrawDetails <> '' then
  begin
    PrintReceipt(FLastWithdrawDetails);
    UpdateStatus('تمت طباعة الإيصال');
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  MessageDlg('نظام إدارة المخازن' + #13#10 + 
              'الإصدار 1.0' + #13#10 + 
              'الجيش المصري' + #13#10 + 
              '2024', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageDlg('هل تريد الخروج من البرنامج؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Action := caFree;
    Application.Terminate;
  end
  else
    Action := caNone;
end;

procedure TfrmMain.UpdateStatus(const Msg: string);
begin
  StatusBar1.SimpleText := '  ' + Msg;
end;


end.