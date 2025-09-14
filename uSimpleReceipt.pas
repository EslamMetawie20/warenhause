unit uSimpleReceipt;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uCart;

type
  TSimpleReceiptGenerator = class
  public
    class function GenerateReceiptPDF(CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
    class function CreateReceiptHTML(CartItems: TList<TCartItem>): string;
    class function SaveReceiptToFile(CartItems: TList<TCartItem>; const BasePath: string = ''): string;
  end;

implementation

{ TSimpleReceiptGenerator }

class function TSimpleReceiptGenerator.CreateReceiptHTML(CartItems: TList<TCartItem>): string;
var
  I: Integer;
  CartItem: TCartItem;
  TotalValue: Currency;
  TotalItems: Integer;
  HTML: TStringBuilder;
begin
  HTML := TStringBuilder.Create;
  try
    TotalValue := 0;
    TotalItems := 0;

    // Calculate totals
    for I := 0 to CartItems.Count - 1 do
    begin
      CartItem := CartItems[I];
      TotalValue := TotalValue + CartItem.TotalPrice;
      TotalItems := TotalItems + CartItem.RequestedQty;
    end;

    // HTML Structure
    HTML.AppendLine('<!DOCTYPE html>');
    HTML.AppendLine('<html dir="rtl">');
    HTML.AppendLine('<head>');
    HTML.AppendLine('<meta charset="UTF-8">');
    HTML.AppendLine('<title>إيصال سحب قطع الغيار</title>');
    HTML.AppendLine('<style>');
    HTML.AppendLine('body { font-family: Arial, sans-serif; direction: rtl; margin: 20px; }');
    HTML.AppendLine('.header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 10px; }');
    HTML.AppendLine('.company { font-size: 18px; font-weight: bold; }');
    HTML.AppendLine('.receipt-title { font-size: 16px; margin: 10px 0; }');
    HTML.AppendLine('.info { margin: 20px 0; }');
    HTML.AppendLine('table { width: 100%; border-collapse: collapse; margin: 20px 0; }');
    HTML.AppendLine('th, td { border: 1px solid #000; padding: 8px; text-align: center; }');
    HTML.AppendLine('th { background-color: #f0f0f0; font-weight: bold; }');
    HTML.AppendLine('.summary { margin-top: 20px; font-weight: bold; }');
    HTML.AppendLine('.footer { text-align: center; margin-top: 30px; border-top: 1px solid #000; padding-top: 10px; }');
    HTML.AppendLine('</style>');
    HTML.AppendLine('</head>');
    HTML.AppendLine('<body>');

    // Header
    HTML.AppendLine('<div class="header">');
    HTML.AppendLine('<div class="company">القوات المسلحة المصرية</div>');
    HTML.AppendLine('<div class="receipt-title">إيصال سحب قطع الغيار</div>');
    HTML.AppendLine('</div>');

    // Info
    HTML.AppendLine('<div class="info">');
    HTML.AppendLine('<p><strong>التاريخ:</strong> ' + DateToStr(Now) + '</p>');
    HTML.AppendLine('<p><strong>الوقت:</strong> ' + TimeToStr(Now) + '</p>');
    HTML.AppendLine('<p><strong>رقم الإيصال:</strong> ' + FormatDateTime('yyyymmddhhnnss', Now) + '</p>');
    HTML.AppendLine('</div>');

    // Items Table
    HTML.AppendLine('<table>');
    HTML.AppendLine('<tr>');
    HTML.AppendLine('<th>رقم القطعة</th>');
    HTML.AppendLine('<th>اسم القطعة</th>');
    HTML.AppendLine('<th>الكمية المسحوبة</th>');
    HTML.AppendLine('<th>سعر الوحدة</th>');
    HTML.AppendLine('<th>الإجمالي</th>');
    HTML.AppendLine('<th>مكان التخزين</th>');
    HTML.AppendLine('</tr>');

    for I := 0 to CartItems.Count - 1 do
    begin
      CartItem := CartItems[I];
      HTML.AppendLine('<tr>');
      HTML.AppendLine('<td>' + CartItem.ItemID + '</td>');
      HTML.AppendLine('<td>' + CartItem.ItemName + '</td>');
      HTML.AppendLine('<td>' + IntToStr(CartItem.RequestedQty) + '</td>');
      HTML.AppendLine('<td>' + FormatFloat('0.00', CartItem.Price) + ' جنيه</td>');
      HTML.AppendLine('<td>' + FormatFloat('0.00', CartItem.TotalPrice) + ' جنيه</td>');
      HTML.AppendLine('<td>' + CartItem.Location + '</td>');
      HTML.AppendLine('</tr>');
    end;

    HTML.AppendLine('</table>');

    // Summary
    HTML.AppendLine('<div class="summary">');
    HTML.AppendLine('<p>عدد الأصناف: ' + IntToStr(CartItems.Count) + '</p>');
    HTML.AppendLine('<p>إجمالي القطع: ' + IntToStr(TotalItems) + '</p>');
    HTML.AppendLine('<p>القيمة الإجمالية: ' + FormatFloat('0.00', TotalValue) + ' جنيه</p>');
    HTML.AppendLine('</div>');

    // Footer
    HTML.AppendLine('<div class="footer">');
    HTML.AppendLine('<p>توقيع المسؤول: ___________________</p>');
    HTML.AppendLine('<p>© 2025 القوات المسلحة المصرية - جميع الحقوق محفوظة</p>');
    HTML.AppendLine('</div>');

    HTML.AppendLine('</body>');
    HTML.AppendLine('</html>');

    Result := HTML.ToString;
  finally
    HTML.Free;
  end;
end;

class function TSimpleReceiptGenerator.GenerateReceiptPDF(CartItems: TList<TCartItem>; const OutputPath: string): Boolean;
var
  HTMLContent: string;
  HTMLFile: TStringList;
  HTMLPath: string;
begin
  Result := False;
  try
    // Generate HTML content
    HTMLContent := CreateReceiptHTML(CartItems);

    // Save as HTML file first (can be converted to PDF later)
    HTMLPath := ChangeFileExt(OutputPath, '.html');
    HTMLFile := TStringList.Create;
    try
      HTMLFile.Text := HTMLContent;
      HTMLFile.SaveToFile(HTMLPath, TEncoding.UTF8);
      Result := True;
    finally
      HTMLFile.Free;
    end;
  except
    Result := False;
  end;
end;

class function TSimpleReceiptGenerator.SaveReceiptToFile(CartItems: TList<TCartItem>; const BasePath: string): string;
var
  FileName: string;
  FullPath: string;
begin
  Result := '';
  try
    // Generate filename
    FileName := Format('ايصال_سحب_%s', [FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now)]);

    if BasePath = '' then
      FullPath := ExtractFilePath(ParamStr(0)) + FileName + '.html'
    else
      FullPath := IncludeTrailingPathDelimiter(BasePath) + FileName + '.html';

    if GenerateReceiptPDF(CartItems, FullPath) then
      Result := FullPath;
  except
    Result := '';
  end;
end;

end.