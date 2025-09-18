unit uPDFReceipt;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uCart;

type
  TPDFReceiptGenerator = class
  public
    class function GenerateReceiptPDF(CartItems: TList<TCartItem>;
      const OutputPath: string): Boolean;
  end;

implementation

uses
  Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.Forms, SynPdf;

{ TPDFReceiptGenerator }

class function TPDFReceiptGenerator.GenerateReceiptPDF(
  CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
var
  PDF: TPdfDocument;
  Page: TPdfPage;
  I: Integer;
  CartItem: TCartItem;
  TotalValue: Currency;
  TotalItems: Integer;
  ReceiptNo: string;
  YPos: Double;
  ItemText: WideString;
begin
  Result := False;

  try
    // Calculate totals
    TotalValue := 0;
    TotalItems := 0;
    for I := 0 to CartItems.Count - 1 do
    begin
      CartItem := CartItems[I];
      TotalValue := TotalValue + CartItem.TotalPrice;
      TotalItems := TotalItems + CartItem.RequestedQty;
    end;

    ReceiptNo := FormatDateTime('yyyymmddhhnnss', Now);

    // Create PDF document
    PDF := TPdfDocument.Create;
    try
      // Add page
      Page := PDF.AddPage;

      // Set initial Y position (from top)
      YPos := 750;

      // Header - Egyptian Armed Forces
      Page.Canvas.SetFont('Arial-Unicode', 18);
      Page.Canvas.TextOutW(250, YPos, WideString('القوات المسلحة المصرية'));

      YPos := YPos - 30;
      Page.Canvas.SetFont('Arial-Unicode', 16);
      Page.Canvas.TextOutW(230, YPos, WideString('إيصال سحب قطع غيار'));

      // Receipt Information
      YPos := YPos - 40;
      Page.Canvas.SetFont('Arial-Unicode', 12);
      Page.Canvas.TextOutW(400, YPos, WideString('رقم الإيصال: ' + ReceiptNo));

      YPos := YPos - 25;
      Page.Canvas.TextOutW(400, YPos, WideString('التاريخ: ' + DateToStr(Now)));

      YPos := YPos - 25;
      Page.Canvas.TextOutW(400, YPos, WideString('الوقت: ' + TimeToStr(Now)));

      // Section Header
      YPos := YPos - 40;
      Page.Canvas.SetFont('Arial-Unicode', 14);
      Page.Canvas.TextOutW(400, YPos, WideString('تفاصيل القطع المسحوبة:'));

      // Draw table header line
      YPos := YPos - 10;
      Page.Canvas.MoveToPoint(50, YPos);
      Page.Canvas.DrawLine(550, YPos);

      // Items Details
      YPos := YPos - 30;
      Page.Canvas.SetFont('Arial-Unicode', 11);

      for I := 0 to CartItems.Count - 1 do
      begin
        CartItem := CartItems[I];

        // Create item text with all details
        ItemText := WideString(Format('%s - %s', [CartItem.ItemID, CartItem.ItemName]));
        Page.Canvas.TextOutW(350, YPos, ItemText);

        ItemText := WideString(Format('الكمية: %d - السعر: %.2f جنيه',
          [CartItem.RequestedQty, CartItem.TotalPrice]));
        Page.Canvas.TextOutW(350, YPos - 15, ItemText);

        ItemText := WideString(Format('المكان: %s', [CartItem.Location]));
        Page.Canvas.TextOutW(350, YPos - 30, ItemText);

        YPos := YPos - 50;

        // Add separator line
        Page.Canvas.MoveToPoint(100, YPos + 10);
        Page.Canvas.DrawLine(500, YPos + 10);
      end;

      // Summary
      YPos := YPos - 20;
      Page.Canvas.SetFont('Arial-Unicode', 12);
      Page.Canvas.TextOutW(350, YPos, WideString('عدد الأصناف: ' + IntToStr(CartItems.Count)));

      YPos := YPos - 25;
      Page.Canvas.TextOutW(350, YPos, WideString('إجمالي القطع: ' + IntToStr(TotalItems)));

      YPos := YPos - 25;
      Page.Canvas.SetFont('Arial-Unicode', 14);
      Page.Canvas.TextOutW(350, YPos, WideString('القيمة الإجمالية: ' +
        FormatFloat('#,##0.00', TotalValue) + ' جنيه'));

      // Signatures
      YPos := YPos - 50;
      Page.Canvas.SetFont('Arial-Unicode', 12);
      Page.Canvas.TextOutW(400, YPos, WideString('توقيع المستلم: ___________________'));

      YPos := YPos - 35;
      Page.Canvas.TextOutW(400, YPos, WideString('توقيع أمين المخزن: ___________________'));

      // Footer
      YPos := 50;
      Page.Canvas.SetFont('Arial-Unicode', 10);
      Page.Canvas.TextOutW(200, YPos, WideString('© 2025 القوات المسلحة المصرية'));

      // Save PDF
      PDF.SaveToFile(ChangeFileExt(OutputPath, '.pdf'));
      Result := True;
    finally
      PDF.Free;
    end;
  except
    on E: Exception do
    begin
      // Fall back to simple receipt if PDF fails
      Result := False;
    end;
  end;
end;

end.