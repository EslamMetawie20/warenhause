@echo off
echo Cleaning build files...
del /Q *.dcu 2>nul
del /Q *.exe 2>nul
del /Q *.~* 2>nul
del /Q *.dsk 2>nul
echo.
echo Clean build completed.
echo.
echo Now compile WarehouseSystem.dpr in Delphi IDE
pause