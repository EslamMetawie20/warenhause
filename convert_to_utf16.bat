@echo off
chcp 65001 > nul
echo تحويل الملفات إلى UTF-16...

powershell -Command "Get-ChildItem -Path '*.pas' | ForEach-Object { $content = Get-Content $_.FullName -Raw -Encoding UTF8; [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode) }"
powershell -Command "Get-ChildItem -Path '*.dfm' | ForEach-Object { $content = Get-Content $_.FullName -Raw -Encoding UTF8; [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode) }"
powershell -Command "Get-ChildItem -Path '*.dpr' | ForEach-Object { $content = Get-Content $_.FullName -Raw -Encoding UTF8; [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode) }"
powershell -Command "Get-ChildItem -Path '*.dproj' | ForEach-Object { $content = Get-Content $_.FullName -Raw -Encoding UTF8; [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode) }"

echo تمت عملية التحويل بنجاح!
pause