@echo off
chcp 65001
echo ========================================
echo  Arabic Warehouse System - Compiler
echo ========================================
echo.
echo Step 1: Force stopping ALL WarehouseSystem processes...
taskkill //F //IM WarehouseSystem.exe 2>nul >nul
wmic process where "name='WarehouseSystem.exe'" delete 2>nul >nul
echo Done!
echo.
echo Step 2: Deep cleaning build files...
del /Q *.dcu 2>nul >nul
del /Q *.exe 2>nul >nul
del /Q *.~* 2>nul >nul
del /Q *.dsk 2>nul >nul
del /Q *.local 2>nul >nul
echo Done!
echo.
echo Step 3: Checking for locked files...
dir WarehouseSystem.exe 2>nul && echo ERROR: EXE still exists! || echo OK: No EXE found
echo.
echo Step 4: Ready to compile!
echo ========================================
echo 1. Open WarehouseSystem.dpr in Delphi
echo 2. Project Options -^> Building -^> Delphi Compiler
echo 3. Set "Generate Console Application" = FALSE
echo 4. Project -^> Build WarehouseSystem
echo ========================================
echo.
echo Features: UTF-8 Arabic strings with GetArabicText()
echo Password: qwer56qwer
echo.
echo Press any key to continue...
pause >nul