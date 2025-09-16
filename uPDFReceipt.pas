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
  Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.Forms;

{ TPDFReceiptGenerator }

class function TPDFReceiptGenerator.GenerateReceiptPDF(
  CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
var
  PDFContent: TStringList;
  I: Integer;
  CartItem: TCartItem;
  TotalValue: Currency;
  TotalItems: Integer;
  ReceiptNo: string;
begin
  Result := False;
  PDFContent := TStringList.Create;
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

    // Generate PDF content
    PDFContent.Add('%PDF-1.4');
    PDFContent.Add('1 0 obj');
    PDFContent.Add('<<');
    PDFContent.Add('/Type /Catalog');
    PDFContent.Add('/Pages 2 0 R');
    PDFContent.Add('>>');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('2 0 obj');
    PDFContent.Add('<<');
    PDFContent.Add('/Type /Pages');
    PDFContent.Add('/Kids [3 0 R]');
    PDFContent.Add('/Count 1');
    PDFContent.Add('>>');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('3 0 obj');
    PDFContent.Add('<<');
    PDFContent.Add('/Type /Page');
    PDFContent.Add('/Parent 2 0 R');
    PDFContent.Add('/MediaBox [0 0 612 792]');
    PDFContent.Add('/Contents 4 0 R');
    PDFContent.Add('/Resources <<');
    PDFContent.Add('/Font <<');
    PDFContent.Add('/F1 5 0 R');
    PDFContent.Add('>>');
    PDFContent.Add('>>');
    PDFContent.Add('>>');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('4 0 obj');
    PDFContent.Add('<<');
    PDFContent.Add('/Length 6 0 R');
    PDFContent.Add('>>');
    PDFContent.Add('stream');
    PDFContent.Add('BT');
    PDFContent.Add('/F1 18 Tf');
    PDFContent.Add('50 750 Td');
    PDFContent.Add('(القوات المسلحة المصرية) Tj');
    PDFContent.Add('0 -25 Td');
    PDFContent.Add('/F1 16 Tf');
    PDFContent.Add('(إيصال سحب قطع غيار) Tj');
    PDFContent.Add('0 -40 Td');
    PDFContent.Add('/F1 12 Tf');
    PDFContent.Add('(رقم الإيصال: ' + ReceiptNo + ') Tj');
    PDFContent.Add('0 -20 Td');
    PDFContent.Add('(التاريخ: ' + DateToStr(Now) + ') Tj');
    PDFContent.Add('0 -20 Td');
    PDFContent.Add('(الوقت: ' + TimeToStr(Now) + ') Tj');
    PDFContent.Add('0 -40 Td');
    PDFContent.Add('/F1 14 Tf');
    PDFContent.Add('(تفاصيل القطع المسحوبة:) Tj');
    PDFContent.Add('0 -30 Td');
    PDFContent.Add('/F1 10 Tf');

    // Add items
    for I := 0 to CartItems.Count - 1 do
    begin
      CartItem := CartItems[I];
      PDFContent.Add('(' + CartItem.ItemID + ' - ' + CartItem.ItemName + ' - كمية: ' +
                     IntToStr(CartItem.RequestedQty) + ' - سعر: ' +
                     FormatFloat('0.00', CartItem.TotalPrice) + ' جنيه) Tj');
      PDFContent.Add('0 -15 Td');
    end;

    PDFContent.Add('0 -20 Td');
    PDFContent.Add('/F1 12 Tf');
    PDFContent.Add('(عدد الأصناف: ' + IntToStr(CartItems.Count) + ') Tj');
    PDFContent.Add('0 -20 Td');
    PDFContent.Add('(إجمالي القطع: ' + IntToStr(TotalItems) + ') Tj');
    PDFContent.Add('0 -20 Td');
    PDFContent.Add('(القيمة الإجمالية: ' + FormatFloat('#,##0.00', TotalValue) + ' جنيه) Tj');
    PDFContent.Add('0 -40 Td');
    PDFContent.Add('(توقيع المستلم: ___________________) Tj');
    PDFContent.Add('0 -30 Td');
    PDFContent.Add('(توقيع أمين المخزن: ___________________) Tj');
    PDFContent.Add('0 -40 Td');
    PDFContent.Add('(© 2025 القوات المسلحة المصرية) Tj');
    PDFContent.Add('ET');
    PDFContent.Add('endstream');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('5 0 obj');
    PDFContent.Add('<<');
    PDFContent.Add('/Type /Font');
    PDFContent.Add('/Subtype /Type1');
    PDFContent.Add('/BaseFont /Helvetica');
    PDFContent.Add('>>');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('6 0 obj');
    PDFContent.Add('1200');
    PDFContent.Add('endobj');
    PDFContent.Add('');
    PDFContent.Add('xref');
    PDFContent.Add('0 7');
    PDFContent.Add('0000000000 65535 f ');
    PDFContent.Add('0000000009 00000 n ');
    PDFContent.Add('0000000074 00000 n ');
    PDFContent.Add('0000000120 00000 n ');
    PDFContent.Add('0000000179 00000 n ');
    PDFContent.Add('0000000364 00000 n ');
    PDFContent.Add('0000000466 00000 n ');
    PDFContent.Add('trailer');
    PDFContent.Add('<<');
    PDFContent.Add('/Size 7');
    PDFContent.Add('/Root 1 0 R');
    PDFContent.Add('>>');
    PDFContent.Add('startxref');
    PDFContent.Add('484');
    PDFContent.Add('%%EOF');

    // Save as PDF
    PDFContent.SaveToFile(ChangeFileExt(OutputPath, '.pdf'), TEncoding.UTF8);
    Result := True;
  finally
    PDFContent.Free;
  end;
end;

end.