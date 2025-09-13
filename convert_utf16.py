import os
import codecs

# قائمة الملفات المطلوب تحويلها
files_to_convert = [
    'uAddItem.pas',
    'uArabicTexts.pas', 
    'uDatabase.pas',
    'uLogin.pas',
    'uMain.pas',
    'uReceipt.pas',
    'WarehouseSystem.dpr',
    'uAddItem.dfm',
    'uLogin.dfm',
    'uMain.dfm'
]

for filename in files_to_convert:
    if os.path.exists(filename):
        try:
            # قراءة الملف بترميز UTF-8
            with open(filename, 'r', encoding='utf-8-sig') as f:
                content = f.read()
            
            # كتابة الملف بترميز UTF-16
            with codecs.open(filename, 'w', encoding='utf-16') as f:
                f.write(content)
            
            print(f'تم تحويل: {filename}')
        except Exception as e:
            print(f'خطأ في تحويل {filename}: {e}')
    else:
        print(f'الملف غير موجود: {filename}')

print('انتهت عملية التحويل!')