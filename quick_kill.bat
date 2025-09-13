@echo off
echo Killing WarehouseSystem processes...
taskkill //F //IM WarehouseSystem.exe 2>nul
wmic process where "name='WarehouseSystem.exe'" delete 2>nul
del /Q WarehouseSystem.exe 2>nul
del /Q *.dcu 2>nul
echo Done! Ready for compilation.
timeout /t 2 >nul