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
    procedure FormResize(Sender: TObject);
  private
    FCurrentItemID: string;
    FLastWithdrawDetails: string;
    procedure UpdateStatus(const Msg: string);
    procedure LoadAllItems;
    function ShowArabicMessage(const AText, ACaption: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
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

  // تعيين القوائم بالنصوص العربية
  mnuFile.Caption := GetArabicText('MENU_FILE');
  mnuAddItem.Caption := GetArabicText('MENU_ADD_ITEM');
  mnuExit.Caption := GetArabicText('MENU_EXIT');
  mnuHelp.Caption := GetArabicText('MENU_HELP');
  mnuAbout.Caption := GetArabicText('MENU_ABOUT');

  // اللوحة العلوية
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
  lblSearchID.Caption := GetArabicText('ITEM_NUMBER');
  btnSearch.Caption := GetArabicText('SEARCH');

  // لوحة السحب
  pnlWithdraw.Align := alBottom;
  pnlWithdraw.Height := 80;
  pnlWithdraw.BevelOuter := bvNone;
  lblWithdrawQty.Caption := GetArabicText('REQUIRED_QTY');
  btnWithdraw.Caption := GetArabicText('WITHDRAW');
  btnAddItem.Caption := GetArabicText('ADD_NEW_ITEM');
  btnPrintReceipt.Caption := GetArabicText('PRINT_RECEIPT');

  // إعداد الشبكة
  StringGrid1.Align := alClient;
  StringGrid1.AlignWithMargins := False;
  StringGrid1.Margins.SetBounds(0,0,0,0);
  StringGrid1.Anchors := [akLeft, akTop, akRight, akBottom];
  StringGrid1.BiDiMode := bdRightToLeft;
  StringGrid1.Font.Name := 'Arial';
  StringGrid1.Font.Size := 12;
  StringGrid1.ColCount := 5;
  StringGrid1.RowCount := 2;
  StringGrid1.FixedRows := 1;
  StringGrid1.DefaultRowHeight := 30;
  StringGrid1.DefaultColWidth := 150;

  // عناوين الأعمدة
  StringGrid1.Cells[0, 0] := GetArabicText('COL_ITEM_ID');
  StringGrid1.Cells[1, 0] := GetArabicText('COL_ITEM_NAME');
  StringGrid1.Cells[2, 0] := GetArabicText('COL_QUANTITY');
  StringGrid1.Cells[3, 0] := GetArabicText('COL_LOCATION');
  StringGrid1.Cells[4, 0] := GetArabicText('COL_PRICE');

  // شريط الحالة
  StatusBar1.SimplePanel := True;
  StatusBar1.BiDiMode := bdRightToLeft;
  UpdateStatus(GetArabicText('MSG_WELCOME'));

  // تحميل جميع القطع
  LoadAllItems;

  // sorgt dafür, dass die Spalten automatisch angepasst werden
  Self.OnResize := FormResize;

  // einmal sofort beim Start aufrufen
  FormResize(Self);
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
    ShowArabicMessage(GetArabicText('MSG_ENTER_ITEM_ID'), 
      GetArabicText('SYSTEM_TITLE'), mtWarning, [mbOK]);
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

    UpdateStatus(GetArabicText('MSG_ITEM_FOUND'));
    edtWithdrawQty.SetFocus;
  end
  else
  begin
    UpdateStatus(GetArabicText('MSG_ITEM_NOT_FOUND'));
    ShowArabicMessage(GetArabicText('MSG_ITEM_NOT_FOUND'), 
      GetArabicText('SYSTEM_TITLE'), mtInformation, [mbOK]);
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
    ShowArabicMessage(GetArabicText('MSG_SEARCH_FIRST'), 
      GetArabicText('SYSTEM_TITLE'), mtWarning, [mbOK]);
    Exit;
  end;

  if not TryStrToInt(edtWithdrawQty.Text, Qty) or (Qty <= 0) then
  begin
    ShowArabicMessage(GetArabicText('MSG_ENTER_VALID_QTY'), 
      GetArabicText('SYSTEM_TITLE'), mtWarning, [mbOK]);
    edtWithdrawQty.SetFocus;
    Exit;
  end;

  if DBManager.GetItemDetails(FCurrentItemID, ItemName, Location, AvailableQty, Price) then
  begin
    if Qty > AvailableQty then
    begin
      ShowArabicMessage(Format(GetArabicText('MSG_QTY_MORE_THAN_AVAIL') + ' (%d > %d)',
        [Qty, AvailableQty]), GetArabicText('SYSTEM_TITLE'), mtWarning, [mbOK]);
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

      UpdateStatus(GetArabicText('MSG_ITEMS_WITHDRAWN'));
      ShowArabicMessage(GetArabicText('MSG_WITHDRAW_SUCCESS'), 
        GetArabicText('SYSTEM_TITLE'), mtInformation, [mbOK]);
      btnPrintReceipt.Enabled := True;

      // تحديث الشبكة
      btnSearchClick(nil);
      edtWithdrawQty.Clear;
    end
    else
    begin
      ShowArabicMessage(GetArabicText('MSG_WITHDRAW_FAILED'), 
        GetArabicText('SYSTEM_TITLE'), mtError, [mbOK]);
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
    UpdateStatus(GetArabicText('MSG_RECEIPT_PRINTED'));
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  ShowArabicMessage(GetArabicText('ABOUT_TEXT'), 
    GetArabicText('SYSTEM_TITLE'), mtInformation, [mbOK]);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ShowArabicMessage(GetArabicText('MSG_EXIT_CONFIRM'),
    GetArabicText('SYSTEM_TITLE'), mtConfirmation, [mbYes, mbNo]) = mrYes then
  begin
    Application.Terminate;
    Action := caFree;
  end
  else
    Action := caNone;
end;

procedure TfrmMain.UpdateStatus(const Msg: string);
begin
  StatusBar1.SimpleText := '  ' + Msg;
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  W, q15, q25, q30: Integer;
begin
  // verfügbare Breite im Grid
  W := StringGrid1.ClientWidth;

  // Spaltenbreiten prozentual verteilen
  q15 := (W * 15) div 100;
  q25 := (W * 25) div 100;
  q30 := (W * 30) div 100;

  if StringGrid1.ColCount >= 5 then
  begin
    StringGrid1.ColWidths[0] := q15; // Spalte: Artikelnummer
    StringGrid1.ColWidths[1] := q30; // Spalte: Artikelname
    StringGrid1.ColWidths[2] := q15; // Spalte: Menge
    StringGrid1.ColWidths[3] := q25; // Spalte: Lagerort
    StringGrid1.ColWidths[4] := W - (q15 + q30 + q15 + q25); // Spalte: Preis
  end;
end;

function TfrmMain.ShowArabicMessage(const AText, ACaption: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
var
  MsgForm: TForm;
  MsgLabel: TLabel;
  ButtonPanel: TPanel;
  OKButton, YesButton, NoButton, CancelButton: TButton;
  // IconImage: TImage;
  ButtonWidth, ButtonLeft: Integer;
begin
  MsgForm := TForm.Create(nil);
  try
    MsgForm.Caption := ACaption;
    MsgForm.BiDiMode := bdRightToLeft;
    MsgForm.Position := poScreenCenter;
    MsgForm.BorderStyle := bsDialog;
    MsgForm.Width := 400;
    MsgForm.Height := 200;
    
    // إنشاء التسمية للنص
    MsgLabel := TLabel.Create(MsgForm);
    MsgLabel.Parent := MsgForm;
    MsgLabel.Caption := AText;
    MsgLabel.BiDiMode := bdRightToLeft;
    MsgLabel.Font.Name := 'Arial';
    MsgLabel.Font.Size := 11;
    MsgLabel.WordWrap := True;
    MsgLabel.Left := 20;
    MsgLabel.Top := 40;
    MsgLabel.Width := 340;
    MsgLabel.Height := 60;
    MsgLabel.Alignment := taRightJustify;
    
    // لوحة الأزرار
    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 50;
    ButtonPanel.BevelOuter := bvNone;
    
    ButtonWidth := 75;
    ButtonLeft := MsgForm.Width - 100;
    
    // إنشاء الأزرار حسب الحاجة
    if mbOK in Buttons then
    begin
      OKButton := TButton.Create(MsgForm);
      OKButton.Parent := ButtonPanel;
      OKButton.Caption := 'موافق';
      OKButton.ModalResult := mrOk;
      OKButton.Width := ButtonWidth;
      OKButton.Left := ButtonLeft;
      OKButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbYes in Buttons then
    begin
      YesButton := TButton.Create(MsgForm);
      YesButton.Parent := ButtonPanel;
      YesButton.Caption := 'نعم';
      YesButton.ModalResult := mrYes;
      YesButton.Width := ButtonWidth;
      YesButton.Left := ButtonLeft;
      YesButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbNo in Buttons then
    begin
      NoButton := TButton.Create(MsgForm);
      NoButton.Parent := ButtonPanel;
      NoButton.Caption := 'لا';
      NoButton.ModalResult := mrNo;
      NoButton.Width := ButtonWidth;
      NoButton.Left := ButtonLeft;
      NoButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbCancel in Buttons then
    begin
      CancelButton := TButton.Create(MsgForm);
      CancelButton.Parent := ButtonPanel;
      CancelButton.Caption := 'إلغاء';
      CancelButton.ModalResult := mrCancel;
      CancelButton.Width := ButtonWidth;
      CancelButton.Left := ButtonLeft;
      CancelButton.Top := 10;
    end;
    
    Result := MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

end.

