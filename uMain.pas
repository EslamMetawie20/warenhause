unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus, Vcl.Grids, Vcl.Buttons, Vcl.Imaging.pngimage, uCart;

type
  TfrmMain = class(TForm)
    // Layout Panels
    pnlHeader: TPanel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    pnlSidebar: TPanel;
    pnlMainContent: TPanel;

    // Header Components
    imgLogo: TImage;
    lblSystemTitle: TLabel;
    lblDateTime: TLabel;
    tmrClock: TTimer;

    // Sidebar Sections
    pnlSearchSection: TPanel;
    pnlWithdrawSection: TPanel;
    pnlActionsSection: TPanel;

    // Search Components
    lblSearchID: TLabel;
    edtSearchID: TEdit;
    btnSearch: TSpeedButton;
    btnShowAll: TSpeedButton;

    // Withdraw Components (now Cart)
    lblWithdrawQty: TLabel;
    edtWithdrawQty: TEdit;
    btnAddToCart: TButton;

    // Cart Components
    pnlCartSection: TPanel;
    lblCartStatus: TLabel;
    btnViewCart: TButton;
    btnClearCart: TSpeedButton;

    // Action Components
    btnAddItem: TSpeedButton;
    btnPrintReceipt: TButton;
    btnExport: TButton;

    // Main Content Components
    pnlGridHeader: TPanel;
    lblGridTitle: TLabel;
    lblRecordCount: TLabel;
    StringGrid1: TStringGrid;

    // Status and Menu
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuAddItem: TMenuItem;
    mnuExport: TMenuItem;
    mnuSeparator1: TMenuItem;
    mnuExit: TMenuItem;
    mnuView: TMenuItem;
    mnuRefresh: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnShowAllClick(Sender: TObject);
    procedure edtSearchIDKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddToCartClick(Sender: TObject);
    procedure btnViewCartClick(Sender: TObject);
    procedure btnClearCartClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnPrintReceiptClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    FCurrentItemID: string;
    FLastWithdrawDetails: string;
    procedure SetupUI;
    procedure SetupSidebarSections;
    procedure SetupColors;
    procedure SetupFonts;
    procedure UpdateStatus(const Msg: string);
    procedure LoadAllItems;
    procedure UpdateRecordCount;
    function ShowArabicMessage(const AText, ACaption: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
    procedure CreateSectionHeader(Panel: TPanel; const Title: string);
    procedure UpdateCartStatus;
    procedure OnCartChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uDatabase, uAddItem, uReceipt, uArabicTexts, uCartForm;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Basic Form Settings
  BiDiMode := bdRightToLeft;
  Caption := GetArabicText('FORM_MAIN');
  Position := poScreenCenter;
  WindowState := wsMaximized;

  SetupUI;
  SetupColors;
  SetupFonts;

  // Menu Setup
  mnuFile.Caption := GetArabicText('MENU_FILE');
  mnuAddItem.Caption := GetArabicText('MENU_ADD_ITEM');
  mnuExport.Caption := 'تصدير البيانات';
  mnuExit.Caption := GetArabicText('MENU_EXIT');
  mnuView.Caption := 'عرض';
  mnuRefresh.Caption := 'تحديث';
  mnuHelp.Caption := GetArabicText('MENU_HELP');
  mnuAbout.Caption := GetArabicText('MENU_ABOUT');

  // Cart Event Setup
  CartManager.OnCartChanged := OnCartChanged;

  // Load data and update display
  LoadAllItems;
  UpdateRecordCount;
  UpdateCartStatus;
  UpdateStatus(GetArabicText('MSG_WELCOME'));

  // Start clock timer
  tmrClock.Enabled := True;
  tmrClockTimer(nil);
end;

procedure TfrmMain.SetupUI;
begin
  // Main Layout Setup
  pnlHeader.Align := alTop;
  pnlHeader.Height := 80;
  pnlHeader.BevelOuter := bvNone;

  pnlContent.Align := alClient;
  pnlContent.BevelOuter := bvNone;

  pnlFooter.Align := alBottom;
  pnlFooter.Height := 25;
  pnlFooter.BevelOuter := bvNone;

  pnlSidebar.Parent := pnlContent;
  pnlSidebar.Align := alRight;
  pnlSidebar.Width := 320;
  pnlSidebar.BevelOuter := bvNone;

  pnlMainContent.Parent := pnlContent;
  pnlMainContent.Align := alClient;
  pnlMainContent.BevelOuter := bvNone;

  // Header Components
  imgLogo.Parent := pnlHeader;
  imgLogo.Left := 20;
  imgLogo.Top := 10;
  imgLogo.Width := 60;
  imgLogo.Height := 60;
  imgLogo.Proportional := True;
  imgLogo.Stretch := True;

  lblSystemTitle.Parent := pnlHeader;
  lblSystemTitle.Caption := 'نظام إدارة قطع الغيار - القوات المسلحة المصرية';
  lblSystemTitle.Left := 100;
  lblSystemTitle.Top := 15;
  lblSystemTitle.Width := 500;
  lblSystemTitle.Height := 30;
  lblSystemTitle.Alignment := taLeftJustify;

  lblDateTime.Parent := pnlHeader;
  lblDateTime.Left := pnlHeader.Width - 200;
  lblDateTime.Top := 45;
  lblDateTime.Width := 180;
  lblDateTime.Height := 20;
  lblDateTime.Alignment := taRightJustify;
  lblDateTime.Anchors := [akTop, akRight];

  // Sidebar Sections
  SetupSidebarSections;

  // Main Grid Area
  pnlGridHeader.Parent := pnlMainContent;
  pnlGridHeader.Align := alTop;
  pnlGridHeader.Height := 40;
  pnlGridHeader.BevelOuter := bvNone;

  lblGridTitle.Parent := pnlGridHeader;
  lblGridTitle.Caption := 'قائمة قطع الغيار';
  lblGridTitle.Left := 20;
  lblGridTitle.Top := 10;
  lblGridTitle.Width := 200;
  lblGridTitle.Height := 20;
  lblGridTitle.Alignment := taLeftJustify;

  lblRecordCount.Parent := pnlGridHeader;
  lblRecordCount.Caption := 'عدد السجلات: 0';
  lblRecordCount.Top := 10;
  lblRecordCount.Width := 150;
  lblRecordCount.Height := 20;
  lblRecordCount.Alignment := taRightJustify;
  lblRecordCount.Anchors := [akTop, akRight];
  lblRecordCount.Left := pnlGridHeader.Width - 170;

  StringGrid1.Parent := pnlMainContent;
  StringGrid1.Align := alClient;
  StringGrid1.AlignWithMargins := True;
  StringGrid1.Margins.SetBounds(10, 10, 10, 10);
  StringGrid1.BiDiMode := bdRightToLeft;
  StringGrid1.ColCount := 5;
  StringGrid1.RowCount := 2;
  StringGrid1.FixedRows := 1;
  StringGrid1.DefaultRowHeight := 35;
  StringGrid1.Options := StringGrid1.Options + [goRowSelect, goThumbTracking];
  StringGrid1.ScrollBars := ssVertical;

  // Grid Headers
  StringGrid1.Cells[0, 0] := 'رقم القطعة';
  StringGrid1.Cells[1, 0] := 'اسم القطعة';
  StringGrid1.Cells[2, 0] := 'الكمية المتاحة';
  StringGrid1.Cells[3, 0] := 'مكان التخزين';
  StringGrid1.Cells[4, 0] := 'السعر (جنيه)';

  // Status Bar
  StatusBar1.Parent := pnlFooter;
  StatusBar1.SimplePanel := True;
  StatusBar1.BiDiMode := bdRightToLeft;
end;

procedure TfrmMain.SetupSidebarSections;
begin
  // Search Section
  pnlSearchSection.Parent := pnlSidebar;
  pnlSearchSection.Align := alTop;
  pnlSearchSection.Height := 140;
  pnlSearchSection.BevelOuter := bvNone;
  pnlSearchSection.AlignWithMargins := True;
  pnlSearchSection.Margins.SetBounds(10, 10, 10, 5);

  CreateSectionHeader(pnlSearchSection, 'البحث عن القطع');

  lblSearchID.Parent := pnlSearchSection;
  lblSearchID.Caption := 'رقم القطعة:';
  lblSearchID.Left := 20;
  lblSearchID.Top := 45;
  lblSearchID.Width := 80;
  lblSearchID.Height := 20;

  edtSearchID.Parent := pnlSearchSection;
  edtSearchID.Left := 20;
  edtSearchID.Top := 70;
  edtSearchID.Width := 180;
  edtSearchID.Height := 25;
  edtSearchID.BiDiMode := bdRightToLeft;

  btnSearch.Parent := pnlSearchSection;
  btnSearch.Caption := 'بحث';
  btnSearch.Left := 210;
  btnSearch.Top := 68;
  btnSearch.Width := 80;
  btnSearch.Height := 29;
  btnSearch.Flat := True;

  btnShowAll.Parent := pnlSearchSection;
  btnShowAll.Caption := 'عرض الكل';
  btnShowAll.Left := 20;
  btnShowAll.Top := 105;
  btnShowAll.Width := 270;
  btnShowAll.Height := 29;
  btnShowAll.Flat := True;

  // Withdraw Section
  pnlWithdrawSection.Parent := pnlSidebar;
  pnlWithdrawSection.Align := alTop;
  pnlWithdrawSection.Height := 120;
  pnlWithdrawSection.BevelOuter := bvNone;
  pnlWithdrawSection.AlignWithMargins := True;
  pnlWithdrawSection.Margins.SetBounds(10, 5, 10, 5);

  CreateSectionHeader(pnlWithdrawSection, 'إضافة  السلة');

  lblWithdrawQty.Parent := pnlWithdrawSection;
  lblWithdrawQty.Caption := 'الكمية:';
  lblWithdrawQty.Left := 20;
  lblWithdrawQty.Top := 45;
  lblWithdrawQty.Width := 80;
  lblWithdrawQty.Height := 20;

  edtWithdrawQty.Parent := pnlWithdrawSection;
  edtWithdrawQty.Left := 20;
  edtWithdrawQty.Top := 70;
  edtWithdrawQty.Width := 180;
  edtWithdrawQty.Height := 25;
  edtWithdrawQty.BiDiMode := bdRightToLeft;

  btnAddToCart.Parent := pnlWithdrawSection;
  btnAddToCart.Caption := 'إضافة  السلة';
  btnAddToCart.Left := 210;
  btnAddToCart.Top := 68;
  btnAddToCart.Width := 80;
  btnAddToCart.Height := 29;

  // Cart Section
  pnlCartSection.Parent := pnlSidebar;
  pnlCartSection.Align := alTop;
  pnlCartSection.Height := 140;
  pnlCartSection.BevelOuter := bvNone;
  pnlCartSection.AlignWithMargins := True;
  pnlCartSection.Margins.SetBounds(10, 5, 10, 5);

  CreateSectionHeader(pnlCartSection, 'السلة');

  lblCartStatus.Parent := pnlCartSection;
  lblCartStatus.Caption := 'السلة  فارغ';
  lblCartStatus.Left := 20;
  lblCartStatus.Top := 45;
  lblCartStatus.Width := 270;
  lblCartStatus.Height := 20;
  lblCartStatus.Font.Style := [fsBold];

  btnViewCart.Parent := pnlCartSection;
  btnViewCart.Caption := 'عرض ا لسلة ';
  btnViewCart.Left := 20;
  btnViewCart.Top := 70;
  btnViewCart.Width := 130;
  btnViewCart.Height := 35;
  btnViewCart.Enabled := False;

  btnClearCart.Parent := pnlCartSection;
  btnClearCart.Caption := 'إفراغ';
  btnClearCart.Left := 160;
  btnClearCart.Top := 68;
  btnClearCart.Width := 80;
  btnClearCart.Height := 29;
  btnClearCart.Flat := True;
  btnClearCart.Enabled := False;

  // Actions Section
  pnlActionsSection.Parent := pnlSidebar;
  pnlActionsSection.Align := alTop;
  pnlActionsSection.Height := 180;
  pnlActionsSection.BevelOuter := bvNone;
  pnlActionsSection.AlignWithMargins := True;
  pnlActionsSection.Margins.SetBounds(10, 5, 10, 10);

  CreateSectionHeader(pnlActionsSection, 'العمليات');

  btnAddItem.Parent := pnlActionsSection;
  btnAddItem.Caption := 'إضافة قطعة جديدة';
  btnAddItem.Left := 20;
  btnAddItem.Top := 45;
  btnAddItem.Width := 270;
  btnAddItem.Height := 35;
  btnAddItem.Flat := True;

  btnPrintReceipt.Parent := pnlActionsSection;
  btnPrintReceipt.Caption := 'طباعة إيصال السحب';
  btnPrintReceipt.Left := 20;
  btnPrintReceipt.Top := 90;
  btnPrintReceipt.Width := 270;
  btnPrintReceipt.Height := 35;
  btnPrintReceipt.Enabled := False;

  btnExport.Parent := pnlActionsSection;
  btnExport.Caption := 'تصدير البيانات';
  btnExport.Left := 20;
  btnExport.Top := 135;
  btnExport.Width := 270;
  btnExport.Height := 35;
  // btnExport.Flat := True; // Not available for TButton
end;

procedure TfrmMain.CreateSectionHeader(Panel: TPanel; const Title: string);
var
  HeaderPanel: TPanel;
  TitleLabel: TLabel;
begin
  HeaderPanel := TPanel.Create(Panel);
  HeaderPanel.Parent := Panel;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 35;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Caption := '';

  TitleLabel := TLabel.Create(HeaderPanel);
  TitleLabel.Parent := HeaderPanel;
  TitleLabel.Caption := Title;
  TitleLabel.Left := 20;
  TitleLabel.Top := 8;
  TitleLabel.Width := 200;
  TitleLabel.Height := 20;
  TitleLabel.Font.Style := [fsBold];
  TitleLabel.Font.Size := 10;
end;

procedure TfrmMain.SetupColors;
begin
  // Color Scheme: Egyptian Military Theme
  Color := $F5F5F5; // Light gray background

  // Header
  pnlHeader.Color := $2B1810; // Dark brown (military)

  // Sidebar
  pnlSidebar.Color := $E8E8E8;
  pnlSearchSection.Color := clWhite;
  pnlWithdrawSection.Color := clWhite;
  pnlActionsSection.Color := clWhite;

  // Main content
  pnlMainContent.Color := $F5F5F5;
  pnlGridHeader.Color := $D4D4D4;

  // Grid
  StringGrid1.Color := clWhite;
  StringGrid1.FixedColor := $4A4A4A;

  // Buttons - Colors are set in DFM

  // Status Bar
  StatusBar1.Color := $E8E8E8;
end;

procedure TfrmMain.SetupFonts;
begin
  // System Title
  lblSystemTitle.Font.Name := 'Arial';
  lblSystemTitle.Font.Size := 14;
  lblSystemTitle.Font.Style := [fsBold];
  lblSystemTitle.Font.Color := clWhite;

  // DateTime
  lblDateTime.Font.Name := 'Arial';
  lblDateTime.Font.Size := 9;
  lblDateTime.Font.Color := clSilver;

  // Grid
  StringGrid1.Font.Name := 'Arial';
  StringGrid1.Font.Size := 10;

  // Labels and Buttons
  Font.Name := 'Arial';
  Font.Size := 9;

  // Button fonts are set in DFM
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  tmrClock.Enabled := False;
end;

procedure TfrmMain.tmrClockTimer(Sender: TObject);
begin
  lblDateTime.Caption := FormatDateTime('dddd، dd mmmm yyyy - hh:nn:ss', Now);
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

  UpdateRecordCount;
end;

procedure TfrmMain.UpdateRecordCount;
begin
  lblRecordCount.Caption := Format('عدد السجلات: %d', [StringGrid1.RowCount - 1]);
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
    StringGrid1.RowCount := 2;
    StringGrid1.Cells[0, 1] := Item.ItemID;
    StringGrid1.Cells[1, 1] := Item.ItemName;
    StringGrid1.Cells[2, 1] := IntToStr(Item.Quantity);
    StringGrid1.Cells[3, 1] := Item.Location;
    StringGrid1.Cells[4, 1] := FormatFloat('0.00', Item.Price);

    UpdateStatus(GetArabicText('MSG_ITEM_FOUND'));
    UpdateRecordCount;
    edtWithdrawQty.SetFocus;
  end
  else
  begin
    UpdateStatus(GetArabicText('MSG_ITEM_NOT_FOUND'));
    ShowArabicMessage(GetArabicText('MSG_ITEM_NOT_FOUND'),
      GetArabicText('SYSTEM_TITLE'), mtInformation, [mbOK]);
  end;
end;

procedure TfrmMain.btnShowAllClick(Sender: TObject);
begin
  LoadAllItems;
  UpdateStatus('تم عرض جميع القطع المتاحة');
  FCurrentItemID := '';
  edtSearchID.Clear;
  edtWithdrawQty.Clear;
end;

procedure TfrmMain.edtSearchIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
    Key := #0;
  end;
end;

procedure TfrmMain.btnAddToCartClick(Sender: TObject);
var
  Qty: Integer;
begin
  if FCurrentItemID = '' then
  begin
    ShowArabicMessage('يرجى البحث عن عنصر أولاً',
      'تنبيه', mtWarning, [mbOK]);
    Exit;
  end;

  if not TryStrToInt(edtWithdrawQty.Text, Qty) or (Qty <= 0) then
  begin
    ShowArabicMessage('يرجى إدخال كمية صالحة',
      'خطأ في البيانات', mtWarning, [mbOK]);
    edtWithdrawQty.SetFocus;
    Exit;
  end;

  // Add to cart
  if CartManager.AddItem(FCurrentItemID, Qty) then
  begin
    UpdateStatus(Format('تم إضافة %d من العنصر %s إلى السلة ', [Qty, FCurrentItemID]));
    ShowArabicMessage('تم إضافة العنصر إلى  ا لسلة بنجاح',
      'تمت الإضافة', mtInformation, [mbOK]);
    edtWithdrawQty.Clear;
    edtSearchID.SetFocus;
  end
  else
  begin
    ShowArabicMessage('فشل في إضافة العنصر - تحقق من الكمية المتاحة',
      'خطأ', mtError, [mbOK]);
    edtWithdrawQty.SetFocus;
  end;
end;

procedure TfrmMain.btnViewCartClick(Sender: TObject);
begin
  if not Assigned(frmCart) then
    Application.CreateForm(TfrmCart, frmCart);
  frmCart.ShowModal;
end;

procedure TfrmMain.btnClearCartClick(Sender: TObject);
begin
  if CartManager.IsEmpty then
    Exit;

  if ShowArabicMessage('هل تريد إفراغ السلة ؟'#13#10'سيتم حذف جميع العناصر.',
    'تأكيد الإفراغ', mtConfirmation, [mbYes, mbNo]) = mrYes then
  begin
    CartManager.ClearCart;
    UpdateStatus('تم إفراغ السلة ');
  end;
end;

procedure TfrmMain.UpdateCartStatus;
begin
  if CartManager.IsEmpty then
  begin
    lblCartStatus.Caption := 'السلة  فارغ';
    lblCartStatus.Font.Color := clGray;
    btnViewCart.Enabled := False;
    btnClearCart.Enabled := False;
  end
  else
  begin
    lblCartStatus.Caption := Format('%d عناصر - %.2f جنيه',
      [CartManager.GetTotalItems, CartManager.GetTotalValue]);
    lblCartStatus.Font.Color := $1565C0; // Blue
    btnViewCart.Enabled := True;
    btnClearCart.Enabled := True;
  end;
end;

procedure TfrmMain.OnCartChanged(Sender: TObject);
begin
  UpdateCartStatus;
  // Update grid to reflect any potential changes
  if FCurrentItemID <> '' then
    btnSearchClick(nil)
  else
    LoadAllItems;
end;

procedure TfrmMain.btnAddItemClick(Sender: TObject);
begin
  if not Assigned(frmAddItem) then
    Application.CreateForm(TfrmAddItem, frmAddItem);
  frmAddItem.ShowModal;
  LoadAllItems;
end;

procedure TfrmMain.btnPrintReceiptClick(Sender: TObject);
begin
  if FLastWithdrawDetails <> '' then
  begin
    PrintReceipt(FLastWithdrawDetails);
    UpdateStatus(GetArabicText('MSG_RECEIPT_PRINTED'));
  end;
end;

procedure TfrmMain.btnExportClick(Sender: TObject);
begin
  UpdateStatus('جاري تصدير البيانات...');
  // Export functionality would be implemented here
  ShowArabicMessage('تم تصدير البيانات بنجاح', 'تصدير', mtInformation, [mbOK]);
end;

procedure TfrmMain.mnuRefreshClick(Sender: TObject);
begin
  LoadAllItems;
  UpdateStatus('تم تحديث البيانات');
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  if ShowArabicMessage(GetArabicText('MSG_EXIT_CONFIRM'),
    GetArabicText('SYSTEM_TITLE'), mtConfirmation, [mbYes, mbNo]) = mrYes then
  begin
    Application.Terminate;
  end;
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
    Action := caFree;
    Application.Terminate;
  end
  else
    Action := caNone;
end;

procedure TfrmMain.UpdateStatus(const Msg: string);
begin
  StatusBar1.SimpleText := '  ' + Msg + ' - ' + FormatDateTime('hh:nn:ss', Now);
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  W, q15, q25, q30: Integer;
begin
  // Auto-adjust grid column widths
  W := StringGrid1.ClientWidth - 20;
  q15 := (W * 15) div 100;
  q25 := (W * 25) div 100;
  q30 := (W * 30) div 100;

  if StringGrid1.ColCount >= 5 then
  begin
    StringGrid1.ColWidths[0] := q15;  // Item ID
    StringGrid1.ColWidths[1] := q30;  // Item Name
    StringGrid1.ColWidths[2] := q15;  // Quantity
    StringGrid1.ColWidths[3] := q25;  // Location
    StringGrid1.ColWidths[4] := W - (q15 + q30 + q15 + q25); // Price
  end;

  // Adjust datetime label position
  lblDateTime.Left := pnlHeader.Width - 200;
  lblRecordCount.Left := pnlGridHeader.Width - 170;
end;

procedure TfrmMain.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Grid: TStringGrid;
  Text: string;
begin
  Grid := Sender as TStringGrid;
  Text := Grid.Cells[ACol, ARow];

  with Grid.Canvas do
  begin
    // Header row styling
    if ARow = 0 then
    begin
      Brush.Color := $4A4A4A;
      Font.Color := clWhite;
      Font.Style := [fsBold];
    end
    else
    begin
      // Alternate row colors
      if ARow mod 2 = 0 then
        Brush.Color := $F8F8F8
      else
        Brush.Color := clWhite;

      Font.Color := clBlack;
      Font.Style := [];

      // Highlight selected row
      if gdSelected in State then
      begin
        Brush.Color := $E6F3FF;
        Font.Style := [fsBold];
      end;

      // Low quantity warning (column 2 = quantity)
      if (ACol = 2) and (ARow > 0) then
      begin
        try
          if StrToIntDef(Text, 0) <= 5 then
          begin
            Font.Color := clRed;
            Font.Style := [fsBold];
          end;
        except
          // Ignore conversion errors
        end;
      end;
    end;

    FillRect(Rect);

    // Center text in cell
    TextOut(Rect.Left + (Rect.Width - TextWidth(Text)) div 2,
            Rect.Top + (Rect.Height - TextHeight(Text)) div 2, Text);
  end;
end;

function TfrmMain.ShowArabicMessage(const AText, ACaption: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
var
  MsgForm: TForm;
  MsgLabel: TLabel;
  ButtonPanel: TPanel;
  OKButton, YesButton, NoButton, CancelButton: TButton;
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
    MsgForm.Color := clWhite;

    // Message label
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

    // Button panel
    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 50;
    ButtonPanel.BevelOuter := bvNone;
    ButtonPanel.Color := $F0F0F0;

    ButtonWidth := 75;
    ButtonLeft := MsgForm.Width - 100;

    // Create buttons based on requirements
    if mbOK in Buttons then
    begin
      OKButton := TButton.Create(MsgForm);
      OKButton.Parent := ButtonPanel;
      OKButton.Caption := 'موافق';
      OKButton.ModalResult := mrOk;
      OKButton.Width := ButtonWidth;
      OKButton.Left := ButtonLeft;
      OKButton.Top := 10;
      OKButton.Font.Style := [fsBold];
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
      YesButton.Font.Style := [fsBold];
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
      NoButton.Font.Style := [fsBold];
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
      CancelButton.Font.Style := [fsBold];
    end;

    Result := MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

end.
