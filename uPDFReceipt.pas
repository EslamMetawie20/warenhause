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

{ TPDFReceiptGenerator }

class function TPDFReceiptGenerator.GenerateReceiptPDF(
  CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
var
  ReceiptLines: TStringList;
  I: Integer;
  CartItem: TCartItem;
  TotalValue: Currency;
  TotalItems: Integer;
  ReceiptNo: string;
begin
  Result := False;
  ReceiptLines := TStringList.Create;
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

    // Build receipt content in Arabic with RTL formatting
    ReceiptLines.Add('=========================================');
    ReceiptLines.Add('القوات المسلحة المصرية');
    ReceiptLines.Add('إيصال سحب قطع غيار');
    ReceiptLines.Add('=========================================');
    ReceiptLines.Add('');
    ReceiptLines.Add('رقم الإيصال: ' + ReceiptNo);
    ReceiptLines.Add('التاريخ: ' + DateToStr(Now));
    ReceiptLines.Add('الوقت: ' + TimeToStr(Now));
    ReceiptLines.Add('');
    ReceiptLines.Add('=========================================');
    ReceiptLines.Add('تفاصيل القطع المسحوبة:');
    ReceiptLines.Add('=========================================');

    // Items table header
    ReceiptLines.Add(Format('%-15s %-20s %-8s %-10s %-12s %s',
      ['رقم القطعة', 'اسم القطعة', 'الكمية', 'السعر', 'الإجمالي', 'المكان']));
    ReceiptLines.Add('-----------------------------------------');

    // Items
    for I := 0 to CartItems.Count - 1 do
    begin
      CartItem := CartItems[I];
      ReceiptLines.Add(Format('%-15s %-20s %-8d %-10.2f %-12.2f %s',
        [CartItem.ItemID,
         CartItem.ItemName,
         CartItem.RequestedQty,
         CartItem.Price,
         CartItem.TotalPrice,
         CartItem.Location]));
    end;

    ReceiptLines.Add('=========================================');
    ReceiptLines.Add('');
    ReceiptLines.Add('الملخص:');
    ReceiptLines.Add('عدد الأصناف: ' + IntToStr(CartItems.Count));
    ReceiptLines.Add('إجمالي القطع: ' + IntToStr(TotalItems));
    ReceiptLines.Add('القيمة الإجمالية: ' + FormatFloat('#,##0.00', TotalValue) + ' جنيه');
    ReceiptLines.Add('');
    ReceiptLines.Add('=========================================');
    ReceiptLines.Add('');
    ReceiptLines.Add('توقيع المستلم: ___________________');
    ReceiptLines.Add('');
    ReceiptLines.Add('توقيع أمين المخزن: ___________________');
    ReceiptLines.Add('');
    ReceiptLines.Add('© 2025 القوات المسلحة المصرية');
    ReceiptLines.Add('=========================================');

    // Save as text file (can be printed or converted to PDF)
    ReceiptLines.SaveToFile(OutputPath, TEncoding.UTF8);
    Result := True;
  finally
    ReceiptLines.Free;
  end;
end;

end.