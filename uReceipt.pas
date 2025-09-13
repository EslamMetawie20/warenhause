unit uReceipt;

interface

uses
  System.SysUtils, System.Classes, Vcl.Printers, Vcl.Graphics, Winapi.Windows,
  Vcl.Dialogs, uArabicTexts;

procedure PrintReceipt(const ReceiptText: string);

implementation

procedure PrintReceipt(const ReceiptText: string);
var
  PrintDialog: TPrintDialog;
  Y, LineHeight: Integer;
  Lines: TStringList;
  i: Integer;
  TextRect: TRect;
begin
  PrintDialog := TPrintDialog.Create(nil);
  try
    if PrintDialog.Execute then
    begin
      Lines := TStringList.Create;
      try
        Lines.Text := ReceiptText;

        Printer.BeginDoc;
        try
          // إعداد الخط للطباعة
          Printer.Canvas.Font.Name := 'Arial';
          Printer.Canvas.Font.Size := 12;
          Printer.Canvas.Font.Style := [];

          // حساب ارتفاع السطر
          LineHeight := Printer.Canvas.TextHeight('A') + 10;
          Y := 100;

          // طباعة رأس الإيصال
          Printer.Canvas.Font.Size := 16;
          Printer.Canvas.Font.Style := [fsBold];
          TextRect.Left := 100;
          TextRect.Top := Y;
          TextRect.Right := Printer.PageWidth - 100;
          TextRect.Bottom := Y + LineHeight * 2;

          // عنوان الإيصال بالعربية مع محاذاة لليمين
          DrawText(Printer.Canvas.Handle,
            PChar(GetArabicText('RECEIPT_TITLE')), -1,
            TextRect, DT_RIGHT or DT_RTLREADING);

          Y := Y + LineHeight * 3;

          // طباعة خط فاصل
          Printer.Canvas.MoveTo(100, Y);
          Printer.Canvas.LineTo(Printer.PageWidth - 100, Y);
          Y := Y + LineHeight;

          // طباعة تفاصيل الإيصال
          Printer.Canvas.Font.Size := 12;
          Printer.Canvas.Font.Style := [];

          for i := 0 to Lines.Count - 1 do
          begin
            TextRect.Left := 100;
            TextRect.Top := Y;
            TextRect.Right := Printer.PageWidth - 100;
            TextRect.Bottom := Y + LineHeight;

            DrawText(Printer.Canvas.Handle,
              PChar(Lines[i]), -1,
              TextRect, DT_RIGHT or DT_RTLREADING);

            Y := Y + LineHeight;
          end;

          // خط فاصل آخر
          Y := Y + LineHeight;
          Printer.Canvas.MoveTo(100, Y);
          Printer.Canvas.LineTo(Printer.PageWidth - 100, Y);

          // توقيعات
          Y := Y + LineHeight * 3;
          TextRect.Left := 100;
          TextRect.Top := Y;
          TextRect.Right := Printer.PageWidth - 100;
          TextRect.Bottom := Y + LineHeight;

          DrawText(Printer.Canvas.Handle,
            PChar('توقيع المستلم: _________________'), -1,
            TextRect, DT_RIGHT or DT_RTLREADING);

          Y := Y + LineHeight * 2;
          TextRect.Top := Y;
          TextRect.Bottom := Y + LineHeight;

          DrawText(Printer.Canvas.Handle,
            PChar('توقيع أمين المخزن: _________________'), -1,
            TextRect, DT_RIGHT or DT_RTLREADING);

          // ختم أسفل الصفحة
          Y := Y + LineHeight * 4;
          Printer.Canvas.Font.Size := 10;
          TextRect.Top := Y;
          TextRect.Bottom := Y + LineHeight;

          DrawText(Printer.Canvas.Handle,
            PChar('الجيش المصري - نظام إدارة المخازن'), -1,
            TextRect, DT_CENTER);

          Printer.EndDoc;

          ShowMessage('تمت الطباعة بنجاح');
        except
          on E: Exception do
          begin
            Printer.Abort;
            ShowMessage('حدث خطأ أثناء الطباعة: ' + E.Message);
          end;
        end;
      finally
        Lines.Free;
      end;
    end;
  finally
    PrintDialog.Free;
  end;
end;

end.

