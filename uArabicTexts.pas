unit uArabicTexts;

interface

uses
  System.SysUtils;

const
  // System
  APP_PASSWORD = 'qwer56qwer';

function GetArabicText(const Key: string): string;
function ConvertToArabicNumbers(const Input: string): string;

implementation

function ConvertToArabicNumbers(const Input: string): string;
begin
  Result := Input;
  Result := StringReplace(Result, '0', '٠', [rfReplaceAll]);
  Result := StringReplace(Result, '1', '١', [rfReplaceAll]);
  Result := StringReplace(Result, '2', '٢', [rfReplaceAll]);
  Result := StringReplace(Result, '3', '٣', [rfReplaceAll]);
  Result := StringReplace(Result, '4', '٤', [rfReplaceAll]);
  Result := StringReplace(Result, '5', '٥', [rfReplaceAll]);
  Result := StringReplace(Result, '6', '٦', [rfReplaceAll]);
  Result := StringReplace(Result, '7', '٧', [rfReplaceAll]);
  Result := StringReplace(Result, '8', '٨', [rfReplaceAll]);
  Result := StringReplace(Result, '9', '٩', [rfReplaceAll]);
end;

function GetArabicText(const Key: string): string;
begin
  if Key = 'SYSTEM_TITLE' then
    Result := 'نظام إدارة المخازن'
  else if Key = 'PASSWORD' then
    Result := 'كلمة المرور:'
  else if Key = 'ENTER' then
    Result := 'دخول'
  else if Key = 'EXIT' then
    Result := 'خروج'
  else if Key = 'SEARCH' then
    Result := 'بحث'
  else if Key = 'WITHDRAW' then
    Result := 'سحب'
  else if Key = 'SAVE' then
    Result := 'حفظ'
  else if Key = 'CANCEL' then
    Result := 'إلغاء'
  else if Key = 'ITEM_NUMBER' then
    Result := 'رقم القطعة:'
  else if Key = 'REQUIRED_QTY' then
    Result := 'الكمية المطلوبة:'
  else if Key = 'PRINT_RECEIPT' then
    Result := 'طباعة الإيصال'
  else if Key = 'ADD_NEW_ITEM' then
    Result := 'إضافة قطعة جديدة'

  // Grid columns
  else if Key = 'COL_ITEM_ID' then
    Result := 'رقم القطعة'
  else if Key = 'COL_ITEM_NAME' then
    Result := 'اسم القطعة'
      else if Key = 'MENU_ADD_ITEM' then
    Result := 'إضافة قطعة جديدة'
  else if Key = 'COL_QUANTITY' then
    Result := 'الكمية المتاحة'
  else if Key = 'COL_LOCATION' then
    Result := 'مكان التخزين'
  else if Key = 'COL_PRICE' then
    Result := 'السعر'

  // Messages
  else if Key = 'MSG_PASSWORD_EMPTY' then
    Result := 'من فضلك أدخل كلمة المرور'
  else if Key = 'MSG_PASSWORD_WRONG' then
    Result := 'كلمة المرور غير صحيحة'
  else if Key = 'MSG_ENTER_ITEM_ID' then
    Result := 'من فضلك أدخل رقم القطعة'
  else if Key = 'MSG_ITEM_NOT_FOUND' then
    Result := 'القطعة غير موجودة في المخزن'
  else if Key = 'MSG_ITEM_FOUND' then
    Result := 'تم العثور على القطعة'
  else if Key = 'MSG_SEARCH_FIRST' then
    Result := 'من فضلك ابحث عن قطعة أولاً'
  else if Key = 'MSG_ENTER_VALID_QTY' then
    Result := 'من فضلك أدخل كمية صحيحة'
  else if Key = 'MSG_QTY_MORE_THAN_AVAIL' then
    Result := 'الكمية المطلوبة أكبر من المتاح'
  else if Key = 'MSG_WITHDRAW_SUCCESS' then
    Result := 'تمت عملية السحب بنجاح'
  else if Key = 'MSG_WITHDRAW_FAILED' then
    Result := 'فشلت عملية السحب'
  else if Key = 'MSG_ITEM_SAVED' then
    Result := 'تم حفظ القطعة بنجاح'
  else if Key = 'MSG_ITEM_EXISTS' then
    Result := 'رقم القطعة موجود بالفعل'
  else if Key = 'MSG_EXIT_CONFIRM' then
    Result := 'هل تريد الخروج من البرنامج؟'
  else if Key = 'MSG_WELCOME' then
    Result := 'مرحباً بك في نظام إدارة المخازن'
  else if Key = 'MSG_RECEIPT_PRINTED' then
    Result := 'تمت طباعة الإيصال'
  else if Key = 'MSG_ENTER_ITEM_NAME' then
    Result := 'من فضلك أدخل اسم القطعة'
  else if Key = 'MSG_ENTER_VALID_PRICE' then
    Result := 'من فضلك أدخل سعر صحيح'
  else if Key = 'MSG_ENTER_LOCATION' then
    Result := 'من فضلك أدخل مكان التخزين'
  else if Key = 'MSG_ITEMS_WITHDRAWN' then
    Result := 'تم سحب القطع بنجاح'

  // Form titles
  else if Key = 'FORM_LOGIN' then
    Result := 'تسجيل الدخول - نظام إدارة المخازن'
  else if Key = 'FORM_MAIN' then
    Result := 'نظام إدارة المخازن - الجيش المصري'
  else if Key = 'FORM_ADD_ITEM' then
    Result := 'إضافة قطعة جديدة'

  // Add Item Form
  else if Key = 'QUANTITY' then
    Result := 'الكمية:'
  else if Key = 'PRICE_FIELD' then
    Result := 'السعر:'
  else if Key = 'LOCATION' then
    Result := 'مكان التخزين:'
  else if Key = 'DEFAULT_LOCATION' then
    Result := 'المخزن / الرف / الدرج'

  // Labels and Buttons
  else if Key = 'LBL_ITEM_ID' then
    Result := 'رقم القطعة:'
  else if Key = 'LBL_QTY' then
    Result := 'الكمية:'
  else if Key = 'BTN_SEARCH' then
    Result := 'بحث'
  else if Key = 'BTN_WITHDRAW' then
    Result := 'سحب'
  else if Key = 'BTN_PRINT' then
    Result := 'طباعة'
  else if Key = 'BTN_ADD_ITEM' then
    Result := 'إضافة قطعة'

  // Menu items
  else if Key = 'MENU_FILE' then
    Result := 'ملف'
  else if Key = 'MENU_EXIT' then
    Result := 'خروج'
  else if Key = 'MENU_HELP' then
    Result := 'مساعدة'
  else if Key = 'MENU_ABOUT' then
    Result := 'حول البرنامج'

  // About
  else if Key = 'ABOUT_TEXT' then
    Result := 'نظام إدارة المخازن' + #13#10 +
              'الإصدار 1.0' + #13#10 +
              'الجيش المصري' + #13#10 +
              '2024'

  // Receipt title
  else if Key = 'RECEIPT_TITLE' then
    Result := 'إيصال سحب من المخزن'

  else
    Result := Key;
end;

end.

