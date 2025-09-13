# Build Instructions - Warehouse Management System

## System Requirements
- Delphi 10.3 or higher (Community Edition is free)
- Windows 7/8/10/11

## Project Structure
```
WarehouseSystem.dpr     - Main project file
uDatabase.pas          - Database module (simple file-based)
uLogin.pas/.dfm        - Login form
uMain.pas/.dfm         - Main form
uAddItem.pas/.dfm      - Add item form  
uReceipt.pas           - Receipt printing module
```

## Build Steps

1. **Open Project in Delphi**
   - Launch Delphi IDE
   - File → Open Project
   - Select `WarehouseSystem.dpr`

2. **Configure for Standalone EXE**
   - Project → Options
   - Building → Delphi Compiler → Linking
   - Set "Link with runtime packages" = **False**
   - Click OK

3. **Build the Project**
   - Project → Build WarehouseSystem
   - Or press Shift+F9

4. **Find the EXE**
   - The executable will be in:
     - `Win32\Debug\WarehouseSystem.exe` (Debug mode)
     - `Win32\Release\WarehouseSystem.exe` (Release mode)

## Release Build
For production deployment:
1. Project → Options → Building → Delphi Compiler
2. Set "Build Configuration" to **Release**
3. Project → Build WarehouseSystem

## Deployment
To deploy the application:
1. Copy `WarehouseSystem.exe` to target computer
2. The database file `warehouse.dat` will be created automatically on first run
3. No additional installation required

## Default Credentials
- Password: `qwer56qwer`

## Features
- Arabic interface with RTL support
- Search parts by ID
- Withdraw items with inventory tracking
- Add new parts
- Print receipts
- Simple file-based database (no SQL server needed)

## Troubleshooting

### If compilation fails:
1. Make sure all .pas and .dfm files are in the same directory
2. Check that Delphi version is 10.3 or higher
3. Verify all standard VCL units are available

### Common errors:
- "Unit not found": Check file paths in .dpr file
- "Form not found": Ensure .dfm files match .pas files
- "Identifier not found": Verify Delphi version compatibility