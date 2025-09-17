unit uCartForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.Buttons, System.Generics.Collections, uCart;

type
  TfrmCart = class(TForm)
    pnlHeader: TPanel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    pnlButtons: TPanel;

    // Header Components
    lblTitle: TLabel;
    lblSummary: TLabel;

    // Content Components
    StringGrid1: TStringGrid;

    // Button Components
    btnCheckout: TButton;
    btnClear: TButton;
    btnClose: TButton;
    btnRemoveItem: TSpeedButton;
    btnUpdateQty: TSpeedButton;

    // Input für Mengenänderung
    pnlQtyUpdate: TPanel;
    lblNewQty: TLabel;
    edtNewQty: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCheckoutClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRemoveItemClick(Sender: TObject);
    procedure btnUpdateQtyClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure edtNewQtyKeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

  private
    procedure SetupUI;
    procedure SetupColors;
    procedure SetupFonts;
    procedure LoadCartItems;
    procedure UpdateSummary;
    procedure OnCartChanged(Sender: TObject);
    function ShowArabicMessage(const AText, ACaption: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
    function GetSelectedItemID: string;
  public
    { Public declarations }
  end;

var
  frmCart: TfrmCart;

implementation

uses uArabicTexts, uPDFReceipt, uDatabase;

{$R *.dfm}

procedure TfrmCart.FormCreate(Sender: TObject);
begin
  BiDiMode := bdRightToLeft;
  Position := poScreenCenter;
  WindowState := wsNormal;

  SetupUI;
  SetupColors;
  SetupFonts;

  // Event für Warenkorb-Änderungen registrieren
  CartManager.OnCartChanged := OnCartChanged;

  Caption := 'السلة  - عرض العناصر المحددة';
end;

procedure TfrmCart.FormShow(Sender: TObject);
begin
  LoadCartItems;
  UpdateSummary;
end;

procedure TfrmCart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide; // Form verstecken statt schließen
end;

procedure TfrmCart.SetupUI;
begin
  // Header Setup
  pnlHeader.Align := alTop;
  pnlHeader.Height := 80;
  pnlHeader.BevelOuter := bvNone;

  lblTitle.Parent := pnlHeader;
  lblTitle.Caption := 'السلة  - العناصر المختارة';
  lblTitle.Left := 20;
  lblTitle.Top := 10;
  lblTitle.Width := 300;
  lblTitle.Height := 25;
  lblTitle.Font.Size := 14;
  lblTitle.Font.Style := [fsBold];

  lblSummary.Parent := pnlHeader;
  lblSummary.Caption := 'المجموع: 0 عنصر - 0.00 جنيه';
  lblSummary.Left := 20;
  lblSummary.Top := 45;
  lblSummary.Width := 400;
  lblSummary.Height := 20;

  // Content Setup
  pnlContent.Align := alClient;
  pnlContent.BevelOuter := bvNone;

  StringGrid1.Parent := pnlContent;
  StringGrid1.Align := alClient;
  StringGrid1.AlignWithMargins := True;
  StringGrid1.Margins.SetBounds(10, 10, 10, 10);
  StringGrid1.BiDiMode := bdRightToLeft;
  StringGrid1.ColCount := 6;
  StringGrid1.RowCount := 2;
  StringGrid1.FixedRows := 1;
  StringGrid1.DefaultRowHeight := 35;
  StringGrid1.Options := StringGrid1.Options + [goRowSelect, goThumbTracking];
  StringGrid1.ScrollBars := ssVertical;

  // Grid Headers
  StringGrid1.Cells[0, 0] := 'رقم القطعة';
  StringGrid1.Cells[1, 0] := 'اسم القطعة';
  StringGrid1.Cells[2, 0] := 'الكمية المطلوبة';
  StringGrid1.Cells[3, 0] := 'المتاح';
  StringGrid1.Cells[4, 0] := 'السعر الإجمالي';
  StringGrid1.Cells[5, 0] := 'مكان التخزين';

  // Footer Setup
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 120;
  pnlFooter.BevelOuter := bvNone;

  // Quantity Update Panel
  pnlQtyUpdate.Parent := pnlFooter;
  pnlQtyUpdate.Align := alTop;
  pnlQtyUpdate.Height := 50;
  pnlQtyUpdate.BevelOuter := bvNone;

  lblNewQty.Parent := pnlQtyUpdate;
  lblNewQty.Caption := 'تعديل الكمية:';
  lblNewQty.Left := 20;
  lblNewQty.Top := 15;
  lblNewQty.Width := 80;
  lblNewQty.Height := 20;

  edtNewQty.Parent := pnlQtyUpdate;
  edtNewQty.Left := 110;
  edtNewQty.Top := 12;
  edtNewQty.Width := 80;
  edtNewQty.Height := 25;
  edtNewQty.BiDiMode := bdRightToLeft;

  btnUpdateQty.Parent := pnlQtyUpdate;
  btnUpdateQty.Caption := 'تحديث';
  btnUpdateQty.Left := 200;
  btnUpdateQty.Top := 10;
  btnUpdateQty.Width := 80;
  btnUpdateQty.Height := 29;
  btnUpdateQty.Flat := True;

  btnRemoveItem.Parent := pnlQtyUpdate;
  btnRemoveItem.Caption := 'حذف العنصر';
  btnRemoveItem.Left := 290;
  btnRemoveItem.Top := 10;
  btnRemoveItem.Width := 100;
  btnRemoveItem.Height := 29;
  btnRemoveItem.Flat := True;

  // Buttons Panel
  pnlButtons.Parent := pnlFooter;
  pnlButtons.Align := alBottom;
  pnlButtons.Height := 60;
  pnlButtons.BevelOuter := bvNone;

  btnCheckout.Parent := pnlButtons;
  btnCheckout.Caption := 'تأكيد السحب';
  btnCheckout.Left := 20;
  btnCheckout.Top := 15;
  btnCheckout.Width := 120;
  btnCheckout.Height := 35;
  btnCheckout.Font.Style := [fsBold];

  btnClear.Parent := pnlButtons;
  btnClear.Caption := 'إفراغ السلة';
  btnClear.Left := 150;
  btnClear.Top := 15;
  btnClear.Width := 120;
  btnClear.Height := 35;

  btnClose.Parent := pnlButtons;
  btnClose.Caption := 'إغلاق';
  btnClose.Left := 280;
  btnClose.Top := 15;
  btnClose.Width := 80;
  btnClose.Height := 35;
  btnClose.Cancel := True;
end;

procedure TfrmCart.SetupColors;
begin
  Color := $F5F5F5;

  pnlHeader.Color := $E8E8E8;
  pnlContent.Color := $F5F5F5;
  pnlFooter.Color := $E8E8E8;
  pnlButtons.Color := $E8E8E8;
  pnlQtyUpdate.Color := $E8E8E8;

  StringGrid1.Color := clWhite;
  StringGrid1.FixedColor := $4A4A4A;

  // Button colors are handled through ParentColor in DFM
end;

procedure TfrmCart.SetupFonts;
begin
  Font.Name := 'Arial';
  Font.Size := 9;

  lblTitle.Font.Name := 'Arial';
  lblTitle.Font.Size := 14;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := $2B1810;

  lblSummary.Font.Name := 'Arial';
  lblSummary.Font.Size := 10;
  lblSummary.Font.Style := [fsBold];
  lblSummary.Font.Color := $1565C0;

  StringGrid1.Font.Name := 'Arial';
  StringGrid1.Font.Size := 9;
end;

procedure TfrmCart.LoadCartItems;
var
  CartItems: TList<TCartItem>;
  I: Integer;
  Item: TCartItem;
begin
  CartItems := CartManager.GetCartItems;
  StringGrid1.RowCount := CartItems.Count + 1;

  if CartItems.Count = 0 then
    StringGrid1.RowCount := 2;

  for I := 0 to CartItems.Count - 1 do
  begin
    Item := CartItems[I];
    StringGrid1.Cells[0, I + 1] := Item.ItemID;
    StringGrid1.Cells[1, I + 1] := Item.ItemName;
    StringGrid1.Cells[2, I + 1] := IntToStr(Item.RequestedQty);
    StringGrid1.Cells[3, I + 1] := IntToStr(Item.AvailableQty);
    StringGrid1.Cells[4, I + 1] := FormatFloat('0.00', Item.TotalPrice);
    StringGrid1.Cells[5, I + 1] := Item.Location;
  end;

  // Buttons aktivieren/deaktivieren
  btnCheckout.Enabled := not CartManager.IsEmpty;
  btnClear.Enabled := not CartManager.IsEmpty;
  btnRemoveItem.Enabled := (StringGrid1.Row > 0) and not CartManager.IsEmpty;
  btnUpdateQty.Enabled := (StringGrid1.Row > 0) and not CartManager.IsEmpty;
end;

procedure TfrmCart.UpdateSummary;
begin
  lblSummary.Caption := Format('المجموع: %d عنصر - %.2f جنيه (إجمالي القطع: %d)',
    [CartManager.GetItemCount, CartManager.GetTotalValue, CartManager.GetTotalItems]);
end;

procedure TfrmCart.OnCartChanged(Sender: TObject);
begin
  LoadCartItems;
  UpdateSummary;
end;

procedure TfrmCart.btnCheckoutClick(Sender: TObject);
var
  ErrorMessage: string;
  CartItemsCopy: TList<TCartItem>;
  I: Integer;
begin
  if CartManager.IsEmpty then
  begin
    ShowArabicMessage('السلة  فارغة', 'تنبيه', mtWarning, [mbOK]);
    Exit;
  end;

  // Warenkorb validieren
  if not CartManager.ValidateCart(ErrorMessage) then
  begin
    ShowArabicMessage('خطأ في التحقق من السلة :'#13#10 + ErrorMessage,
      'خطأ', mtError, [mbOK]);
    Exit;
  end;

  // Bestätigung vom Benutzer
  if ShowArabicMessage('هل تريد تأكيد سحب جميع العناصر من السلة ؟',
    'تأكيد السحب', mtConfirmation, [mbYes, mbNo]) <> mrYes then
    Exit;

  // SICHERER CHECKOUT - Minimale Komplexität
  CartItemsCopy := TList<TCartItem>.Create;
  try
    // 1. Cart-Items kopieren
    for I := 0 to CartManager.GetCartItems.Count - 1 do
      CartItemsCopy.Add(CartManager.GetCartItems[I]);

    // 2. SaveDialog anzeigen
    var SaveDialog := TSaveDialog.Create(Self);
    var ReceiptPath := '';
    var AllSuccessful := False;
    try
      SaveDialog.Filter := 'PDF Files (*.pdf)|*.pdf';
      SaveDialog.DefaultExt := 'pdf';
      SaveDialog.FileName := 'ايصال_سحب_' + FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now);
      SaveDialog.Title := 'حفظ إيصال السحب';
      SaveDialog.Options := SaveDialog.Options + [ofOverwritePrompt];

      if SaveDialog.Execute then
      begin
        ReceiptPath := SaveDialog.FileName;

        // SICHERE Entnahme ohne ProcessCheckout
        AllSuccessful := True;
        for I := 0 to CartItemsCopy.Count - 1 do
        begin
          if not DBManager.WithdrawItem(CartItemsCopy[I].ItemID, CartItemsCopy[I].RequestedQty) then
          begin
            AllSuccessful := False;
            Break;
          end;
        end;

        // PDF generieren nach erfolgreicher Entnahme
        if AllSuccessful then
        begin
          if not TPDFReceiptGenerator.GenerateReceiptPDF(CartItemsCopy, ReceiptPath) then
            AllSuccessful := False;
        end;
      end;
    finally
      SaveDialog.Free;
    end;

    // 3. Ergebnisse verarbeiten
    if (ReceiptPath <> '') and AllSuccessful then
    begin
      // Warenkorb leeren
      CartManager.ClearCart;

      // Erfolg anzeigen
      ShowArabicMessage('تم السحب بنجاح!'#13#10'تم حفظ إيصال PDF في:'#13#10 + ExtractFileName(ReceiptPath),
        'نجح', mtInformation, [mbOK]);

      // Form schließen
      ModalResult := mrOk;
    end
    else if ReceiptPath <> '' then
    begin
      // Fehler beim PDF-Export, aber Entnahme war erfolgreich
      CartManager.ClearCart;
      ShowArabicMessage('تم السحب بنجاح ولكن فشل حفظ إيصال PDF', 'تنبيه', mtWarning, [mbOK]);
      ModalResult := mrOk;
    end
    else
    begin
      // User cancelled save dialog - do nothing
      Exit;
    end;
  finally
    CartItemsCopy.Free;
  end;
end;

procedure TfrmCart.btnClearClick(Sender: TObject);
begin
  if CartManager.IsEmpty then
    Exit;

  if ShowArabicMessage('هل تريد إفراغ  السلة ؟'#13#10'سيتم حذف جميع العناصر بدون سحبها.',
    'تأكيد الإفراغ', mtConfirmation, [mbYes, mbNo]) = mrYes then
  begin
    CartManager.ClearCart;
    ShowArabicMessage('تم إفراغ السلة ', 'تم', mtInformation, [mbOK]);
  end;
end;

procedure TfrmCart.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCart.btnRemoveItemClick(Sender: TObject);
var
  ItemID: string;
begin
  ItemID := GetSelectedItemID;
  if ItemID <> '' then
  begin
    if ShowArabicMessage(Format('هل تريد حذف العنصر "%s" من السلة ؟', [ItemID]),
      'تأكيد الحذف', mtConfirmation, [mbYes, mbNo]) = mrYes then
    begin
      CartManager.RemoveItem(ItemID);
      ShowArabicMessage('تم حذف العنصر من السلة ', 'تم', mtInformation, [mbOK]);
    end;
  end;
end;

procedure TfrmCart.btnUpdateQtyClick(Sender: TObject);
var
  ItemID: string;
  NewQty: Integer;
begin
  ItemID := GetSelectedItemID;
  if ItemID = '' then
  begin
    ShowArabicMessage('يرجى اختيار عنصر من القائمة', 'تنبيه', mtWarning, [mbOK]);
    Exit;
  end;

  if not TryStrToInt(edtNewQty.Text, NewQty) or (NewQty < 0) then
  begin
    ShowArabicMessage('يرجى إدخال كمية صالحة', 'خطأ', mtError, [mbOK]);
    edtNewQty.SetFocus;
    Exit;
  end;

  if NewQty = 0 then
  begin
    btnRemoveItemClick(Self);
    Exit;
  end;

  if CartManager.UpdateItemQuantity(ItemID, NewQty) then
  begin
    ShowArabicMessage('تم تحديث الكمية بنجاح', 'تم', mtInformation, [mbOK]);
    edtNewQty.Clear;
  end
  else
  begin
    ShowArabicMessage('فشل في تحديث الكمية - تحقق من الكمية المتاحة',
      'خطأ', mtError, [mbOK]);
  end;
end;

function TfrmCart.GetSelectedItemID: string;
begin
  Result := '';
  if (StringGrid1.Row > 0) and (StringGrid1.Row < StringGrid1.RowCount) then
    Result := StringGrid1.Cells[0, StringGrid1.Row];
end;

procedure TfrmCart.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow > 0 then
    edtNewQty.Text := StringGrid1.Cells[2, ARow];

  btnRemoveItem.Enabled := (ARow > 0) and not CartManager.IsEmpty;
  btnUpdateQty.Enabled := (ARow > 0) and not CartManager.IsEmpty;
end;

procedure TfrmCart.edtNewQtyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnUpdateQtyClick(Sender);
    Key := #0;
  end;

  // Nur Zahlen erlauben
  if not CharInSet(Key, ['0'..'9', #8, #13]) then
    Key := #0;
end;

procedure TfrmCart.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Grid: TStringGrid;
  Text: string;
begin
  Grid := Sender as TStringGrid;
  Text := Grid.Cells[ACol, ARow];

  with Grid.Canvas do
  begin
    if ARow = 0 then
    begin
      Brush.Color := $4A4A4A;
      Font.Color := clWhite;
      Font.Style := [fsBold];
    end
    else
    begin
      if ARow mod 2 = 0 then
        Brush.Color := $F8F8F8
      else
        Brush.Color := clWhite;

      Font.Color := clBlack;
      Font.Style := [];

      if gdSelected in State then
      begin
        Brush.Color := $E6F3FF;
        Font.Style := [fsBold];
      end;

      // Niedrige verfügbare Menge warnen (Spalte 3 = Available Qty)
      if (ACol = 3) and (ARow > 0) then
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
    TextOut(Rect.Left + (Rect.Width - TextWidth(Text)) div 2,
            Rect.Top + (Rect.Height - TextHeight(Text)) div 2, Text);
  end;
end;

function TfrmCart.ShowArabicMessage(const AText, ACaption: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
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

    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 50;
    ButtonPanel.BevelOuter := bvNone;
    ButtonPanel.Color := $F0F0F0;

    ButtonWidth := 75;
    ButtonLeft := MsgForm.Width - 100;

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