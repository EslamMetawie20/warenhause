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
  // Arabic texts using UTF-8 encoding
  if Key = 'SYSTEM_TITLE' then
    Result := UTF8ToString('نظام إدارة المخازن')
  else if Key = 'PASSWORD' then
    Result := UTF8ToString('كلمة المرور:')
  else if Key = 'ENTER' then
    Result := UTF8ToString('دخول')
  else if Key = 'EXIT' then
    Result := UTF8ToString('خروج')
  else if Key = 'SEARCH' then
    Result := UTF8ToString('بحث')
  else if Key = 'WITHDRAW' then
    Result := UTF8ToString('سحب')
  else if Key = 'SAVE' then
    Result := UTF8ToString('حفظ')
  else if Key = 'CANCEL' then
    Result := UTF8ToString('إلغاء')
  else if Key = 'ITEM_NUMBER' then
    Result := UTF8ToString('رقم القطعة:')
  else if Key = 'REQUIRED_QTY' then
    Result := UTF8ToString('الكمية المطلوبة:')
  else if Key = 'PRINT_RECEIPT' then
    Result := UTF8ToString('طباعة الإيصال')
  else if Key = 'ADD_NEW_ITEM' then
    Result := UTF8ToString('إضافة قطعة جديدة')
  
  // Grid columns
  else if Key = 'COL_ITEM_ID' then
    Result := UTF8ToString('رقم القطعة')
  else if Key = 'COL_ITEM_NAME' then
    Result := UTF8ToString('اسم القطعة')
  else if Key = 'COL_QUANTITY' then
    Result := UTF8ToString('الكمية المتاحة')
  else if Key = 'COL_LOCATION' then
    Result := UTF8ToString('مكان التخزين')
  else if Key = 'COL_PRICE' then
    Result := UTF8ToString('السعر')
  
  // Messages
  else if Key = 'MSG_PASSWORD_EMPTY' then
    Result := UTF8ToString('من فضلك أدخل كلمة المرور')
  else if Key = 'MSG_PASSWORD_WRONG' then
    Result := UTF8ToString('كلمة المرور غير صحيحة')
  else if Key = 'MSG_ENTER_ITEM_ID' then
    Result := UTF8ToString('من فضلك أدخل رقم القطعة')
  else if Key = 'MSG_ITEM_NOT_FOUND' then
    Result := UTF8ToString('القطعة غير موجودة في المخزن')
  else if Key = 'MSG_ITEM_FOUND' then
    Result := UTF8ToString('تم العثور على القطعة')
  else if Key = 'MSG_SEARCH_FIRST' then
    Result := UTF8ToString('من فضلك ابحث عن قطعة أولاً')
  else if Key = 'MSG_ENTER_VALID_QTY' then
    Result := UTF8ToString('من فضلك أدخل كمية صحيحة')
  else if Key = 'MSG_QTY_MORE_THAN_AVAIL' then
    Result := UTF8ToString('الكمية المطلوبة أكبر من المتاح')
  else if Key = 'MSG_WITHDRAW_SUCCESS' then
    Result := UTF8ToString('تمت عملية السحب بنجاح')
  else if Key = 'MSG_WITHDRAW_FAILED' then
    Result := UTF8ToString('فشلت عملية السحب')
  else if Key = 'MSG_ITEM_SAVED' then
    Result := UTF8ToString('تم حفظ القطعة بنجاح')
  else if Key = 'MSG_ITEM_EXISTS' then
    Result := UTF8ToString('فشل حفظ القطعة. ربما يكون رقم القطعة موجود بالفعل')
  else if Key = 'MSG_EXIT_CONFIRM' then
    Result := UTF8ToString('هل تريد الخروج من البرنامج؟')
  else if Key = 'MSG_WELCOME' then
    Result := UTF8ToString('مرحباً بك في نظام إدارة المخازن')
  else if Key = 'MSG_RECEIPT_PRINTED' then
    Result := UTF8ToString('تمت طباعة الإيصال')
  else if Key = 'MSG_ENTER_ITEM_NAME' then
    Result := UTF8ToString('من فضلك أدخل اسم القطعة')
  else if Key = 'MSG_ENTER_VALID_PRICE' then
    Result := UTF8ToString('من فضلك أدخل سعر صحيح')
  else if Key = 'MSG_ENTER_LOCATION' then
    Result := UTF8ToString('من فضلك أدخل مكان التخزين')
  else if Key = 'MSG_ITEMS_WITHDRAWN' then
    Result := UTF8ToString('تم سحب القطع بنجاح')
  
  // Form titles
  else if Key = 'FORM_LOGIN' then
    Result := UTF8ToString('تسجيل الدخول - نظام إدارة المخازن')
  else if Key = 'FORM_MAIN' then
    Result := UTF8ToString('نظام إدارة المخازن - الجيش المصري')
  else if Key = 'FORM_ADD_ITEM' then
    Result := UTF8ToString('إضافة قطعة جديدة')
  
  // Add Item Form
  else if Key = 'QUANTITY' then
    Result := UTF8ToString('الكمية:')
  else if Key = 'PRICE_FIELD' then
    Result := UTF8ToString('السعر:')
  else if Key = 'LOCATION' then
    Result := UTF8ToString('مكان التخزين:')
  else if Key = 'DEFAULT_LOCATION' then
    Result := UTF8ToString('المخزن / الرف / الدرج')
  
  // Labels and Buttons
  else if Key = 'LBL_ITEM_ID' then
    Result := UTF8ToString('رقم القطعة:')
  else if Key = 'LBL_QTY' then
    Result := UTF8ToString('الكمية:')
  else if Key = 'BTN_SEARCH' then
    Result := UTF8ToString('بحث')
  else if Key = 'BTN_WITHDRAW' then
    Result := UTF8ToString('سحب')
  else if Key = 'BTN_PRINT' then
    Result := UTF8ToString('طباعة')
  else if Key = 'BTN_ADD_ITEM' then
    Result := UTF8ToString('إضافة قطعة')
  
  // Menu items
  else if Key = 'MENU_FILE' then
    Result := UTF8ToString('ملف')
  else if Key = 'MENU_EXIT' then
    Result := UTF8ToString('خروج')
  else if Key = 'MENU_HELP' then
    Result := UTF8ToString('مساعدة')
  else if Key = 'MENU_ABOUT' then
    Result := UTF8ToString('حول البرنامج')
  
  // About
  else if Key = 'ABOUT_TEXT' then
    Result := UTF8ToString('نظام إدارة المخازن') + #13#10 +
              UTF8ToString('الإصدار 1.0') + #13#10 +
              UTF8ToString('الجيش المصري') + #13#10 +
              '2024'
  
  else
    Result := Key; // Return key if not found
end;

end.