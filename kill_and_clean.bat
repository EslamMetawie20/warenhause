@echo off
echo Stopping WarehouseSystem processes...
taskkill //F //IM WarehouseSystem.exe 2>nul
echo.
echo Cleaning build files...
del /Q *.dcu 2>nul
del /Q *.exe 2>nul
del /Q *.~* 2>nul
del /Q *.dsk 2>nul
echo.
echo Ready for compilation!
echo Now open WarehouseSystem.dpr in Delphi and compile.
pause