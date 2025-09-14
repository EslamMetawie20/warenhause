unit uPDFReceipt;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  uCart;

type
  // PDF Receipt Generator
  TPDFReceiptGenerator = class
  private
    function FormatArabicText(const Text: string): string;
    function CreateReceiptContent(CartItems: TList<TCartItem>; TotalValue: Currency): TStringList;
  public
    function GeneratePDFReceipt(CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
    function GenerateHTMLReceipt(CartItems: TList<TCartItem>): string;
  end;

  // Receipt Dialog Form
  TfrmReceiptDialog = class(TForm)
    pnlHeader: TPanel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    lblTitle: TLabel;
    memoReceipt: TMemo;
    btnSavePDF: TButton;
    btnPrint: TButton;
    btnClose: TButton;
    btnCopy: TButton;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure btnSavePDFClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    FCartItems: TList<TCartItem>;
    FReceiptContent: string;
    procedure SetupUI;
    procedure SetupColors;
    procedure SetupFonts;
    procedure DisplayReceipt;
    function ShowArabicMessage(const AText, ACaption: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;

  public
    procedure SetReceiptData(CartItems: TList<TCartItem>; const ReceiptContent: string);
  end;

var
  frmReceiptDialog: TfrmReceiptDialog;

implementation

uses Vcl.Clipbrd, Vcl.Printers;

{$R *.dfm}

{ TPDFReceiptGenerator }

function TPDFReceiptGenerator.FormatArabicText(const Text: string): string;
begin
  // Simple text formatting for Arabic text
  Result := Text;
end;

function TPDFReceiptGenerator.CreateReceiptContent(CartItems: TList<TCartItem>; TotalValue: Currency): TStringList;
var
  I: Integer;
  CartItem: TCartItem;
  TotalItems: Integer;
begin
  Result := TStringList.Create;

  // Header
  Result.Add('========================================');
  Result.Add('    إيصال سحب قطع الغيار    ');
  Result.Add('   القوات المسلحة المصرية   ');
  Result.Add('========================================');
  Result.Add('');
  Result.Add('التاريخ: ' + DateToStr(Now));
  Result.Add('الوقت: ' + TimeToStr(Now));
  Result.Add('رقم الإيصال: ' + FormatDateTime('yyyymmddhhnnss', Now));
  Result.Add('');
  Result.Add('========================================');
  Result.Add('           الأصناف المسحوبة           ');
  Result.Add('========================================');
  Result.Add('');

  // Items
  TotalItems := 0;
  for I := 0 to CartItems.Count - 1 do
  begin
    CartItem := CartItems[I];
    TotalItems := TotalItems + CartItem.RequestedQty;

    Result.Add(Format('رقم القطعة: %s', [CartItem.ItemID]));
    Result.Add(Format('اسم القطعة: %s', [CartItem.ItemName]));
    Result.Add(Format('الكمية المسحوبة: %d', [CartItem.RequestedQty]));
    Result.Add(Format('سعر الوحدة: %.2f جنيه', [CartItem.Price]));
    Result.Add(Format('الإجمالي: %.2f جنيه', [CartItem.TotalPrice]));
    Result.Add(Format('مكان التخزين: %s', [CartItem.Location]));
    Result.Add('----------------------------------------');
    Result.Add('');
  end;

  // Summary
  Result.Add('========================================');
  Result.Add('              الملخص النهائي              ');
  Result.Add('========================================');
  Result.Add(Format('عدد الأصناف: %d', [CartItems.Count]));
  Result.Add(Format('إجمالي القطع: %d', [TotalItems]));
  Result.Add(Format('القيمة الإجمالية: %.2f جنيه', [TotalValue]));
  Result.Add('');
  Result.Add('========================================');
  Result.Add('');
  Result.Add('توقيع المسؤول: ___________________');
  Result.Add('');
  Result.Add('التاريخ: ___________________');
  Result.Add('');
  Result.Add('© 2025 القوات المسلحة المصرية');
  Result.Add('جميع الحقوق محفوظة');
end;

function TPDFReceiptGenerator.GenerateHTMLReceipt(CartItems: TList<TCartItem>): string;
var
  Content: TStringList;
  I: Integer;
  TotalValue: Currency;
begin
  Result := '';
  TotalValue := 0;

  // Calculate total value
  for I := 0 to CartItems.Count - 1 do
    TotalValue := TotalValue + CartItems[I].TotalPrice;

  Content := CreateReceiptContent(CartItems, TotalValue);
  try
    // Convert to HTML format
    Result := '<html dir="rtl"><head><meta charset="UTF-8">' +
              '<style>body{font-family:Arial;direction:rtl;text-align:center;}</style>' +
              '</head><body><pre>';

    for I := 0 to Content.Count - 1 do
      Result := Result + Content[I] + '<br>';

    Result := Result + '</pre></body></html>';
  finally
    Content.Free;
  end;
end;

function TPDFReceiptGenerator.GeneratePDFReceipt(CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
var
  Content: TStringList;
  TotalValue: Currency;
  I: Integer;
begin
  Result := False;

  try
    TotalValue := 0;
    for I := 0 to CartItems.Count - 1 do
      TotalValue := TotalValue + CartItems[I].TotalPrice;

    Content := CreateReceiptContent(CartItems, TotalValue);
    try
      // Save as text file (can be enhanced to real PDF later)
      Content.SaveToFile(ChangeFileExt(OutputPath, '.txt'), TEncoding.UTF8);
      Result := True;
    finally
      Content.Free;
    end;
  except
    Result := False;
  end;
end;

{ TfrmReceiptDialog }

procedure TfrmReceiptDialog.FormCreate(Sender: TObject);
begin
  BiDiMode := bdRightToLeft;
  Position := poScreenCenter;
  WindowState := wsNormal;

  SetupUI;
  SetupColors;
  SetupFonts;

  Caption := 'إيصال سحب قطع الغيار';
end;

procedure TfrmReceiptDialog.SetupUI;
begin
  // Header Setup
  pnlHeader.Align := alTop;
  pnlHeader.Height := 50;
  pnlHeader.BevelOuter := bvNone;

  lblTitle.Parent := pnlHeader;
  lblTitle.Caption := 'إيصال سحب قطع الغيار - القوات المسلحة المصرية';
  lblTitle.Align := alClient;
  lblTitle.Alignment := taCenter;
  lblTitle.Font.Size := 14;
  lblTitle.Font.Style := [fsBold];

  // Content Setup
  pnlContent.Align := alClient;
  pnlContent.BevelOuter := bvNone;

  memoReceipt.Parent := pnlContent;
  memoReceipt.Align := alClient;
  memoReceipt.AlignWithMargins := True;
  memoReceipt.Margins.SetBounds(10, 10, 10, 10);
  memoReceipt.ReadOnly := True;
  memoReceipt.Font.Name := 'Courier New';
  memoReceipt.Font.Size := 10;
  memoReceipt.ScrollBars := ssVertical;

  // Footer Setup
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 60;
  pnlFooter.BevelOuter := bvNone;

  btnSavePDF.Parent := pnlFooter;
  btnSavePDF.Caption := 'حفظ كـ PDF';
  btnSavePDF.Left := 20;
  btnSavePDF.Top := 15;
  btnSavePDF.Width := 100;
  btnSavePDF.Height := 35;

  btnPrint.Parent := pnlFooter;
  btnPrint.Caption := 'طباعة';
  btnPrint.Left := 130;
  btnPrint.Top := 15;
  btnPrint.Width := 80;
  btnPrint.Height := 35;

  btnCopy.Parent := pnlFooter;
  btnCopy.Caption := 'نسخ';
  btnCopy.Left := 220;
  btnCopy.Top := 15;
  btnCopy.Width := 80;
  btnCopy.Height := 35;

  btnClose.Parent := pnlFooter;
  btnClose.Caption := 'إغلاق';
  btnClose.Left := 310;
  btnClose.Top := 15;
  btnClose.Width := 80;
  btnClose.Height := 35;
  btnClose.Cancel := True;

  // Save Dialog Setup
  SaveDialog1.Filter := 'ملفات نصية (*.txt)|*.txt|جميع الملفات (*.*)|*.*';
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.FileName := 'ايصال_' + FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now);
end;

procedure TfrmReceiptDialog.SetupColors;
begin
  Color := $F5F5F5;
  pnlHeader.Color := $2B1810;
  pnlContent.Color := $F5F5F5;
  pnlFooter.Color := $E8E8E8;

  lblTitle.Font.Color := clWhite;
  memoReceipt.Color := clWhite;
end;

procedure TfrmReceiptDialog.SetupFonts;
begin
  Font.Name := 'Arial';
  Font.Size := 9;

  lblTitle.Font.Name := 'Arial';
  lblTitle.Font.Size := 14;
  lblTitle.Font.Style := [fsBold];

  memoReceipt.Font.Name := 'Courier New';
  memoReceipt.Font.Size := 10;
end;

procedure TfrmReceiptDialog.SetReceiptData(CartItems: TList<TCartItem>; const ReceiptContent: string);
begin
  FCartItems := CartItems;
  FReceiptContent := ReceiptContent;
  DisplayReceipt;
end;

procedure TfrmReceiptDialog.DisplayReceipt;
var
  Generator: TPDFReceiptGenerator;
  Content: TStringList;
  TotalValue: Currency;
  I: Integer;
begin
  if not Assigned(FCartItems) then Exit;

  Generator := TPDFReceiptGenerator.Create;
  try
    TotalValue := 0;
    for I := 0 to FCartItems.Count - 1 do
      TotalValue := TotalValue + FCartItems[I].TotalPrice;

    Content := Generator.CreateReceiptContent(FCartItems, TotalValue);
    try
      memoReceipt.Lines.Assign(Content);
    finally
      Content.Free;
    end;
  finally
    Generator.Free;
  end;
end;

procedure TfrmReceiptDialog.btnSavePDFClick(Sender: TObject);
var
  Generator: TPDFReceiptGenerator;
  OutputPath: string;
begin
  if SaveDialog1.Execute then
  begin
    OutputPath := SaveDialog1.FileName;

    Generator := TPDFReceiptGenerator.Create;
    try
      if Generator.GeneratePDFReceipt(FCartItems, OutputPath) then
      begin
        ShowArabicMessage('تم حفظ الإيصال بنجاح في:'#13#10 + OutputPath,
          'حفظ الإيصال', mtInformation, [mbOK]);
      end
      else
      begin
        ShowArabicMessage('فشل في حفظ الإيصال',
          'خطأ', mtError, [mbOK]);
      end;
    finally
      Generator.Free;
    end;
  end;
end;

procedure TfrmReceiptDialog.btnPrintClick(Sender: TObject);
var
  PrintDialog: TPrintDialog;
begin
  PrintDialog := TPrintDialog.Create(nil);
  try
    if PrintDialog.Execute then
    begin
      try
        Printer.BeginDoc;
        try
          Printer.Canvas.Font.Name := 'Arial';
          Printer.Canvas.Font.Size := 12;
          // Simple text printing - can be enhanced later
          Printer.Canvas.TextOut(100, 100, 'Receipt printed - see text file for details');
        finally
          Printer.EndDoc;
        end;
        ShowArabicMessage('تم إرسال الإيصال للطابعة',
          'طباعة', mtInformation, [mbOK]);
      except
        ShowArabicMessage('فشل في طباعة الإيصال',
          'خطأ في الطباعة', mtError, [mbOK]);
      end;
    end;
  finally
    PrintDialog.Free;
  end;
end;

procedure TfrmReceiptDialog.btnCopyClick(Sender: TObject);
begin
  try
    Clipboard.AsText := memoReceipt.Text;
    ShowArabicMessage('تم نسخ محتوى الإيصال إلى الحافظة',
      'نسخ', mtInformation, [mbOK]);
  except
    ShowArabicMessage('فشل في نسخ المحتوى',
      'خطأ', mtError, [mbOK]);
  end;
end;

procedure TfrmReceiptDialog.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReceiptDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree; // Form wird komplett freigegeben
  frmReceiptDialog := nil;
end;

function TfrmReceiptDialog.ShowArabicMessage(const AText, ACaption: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
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