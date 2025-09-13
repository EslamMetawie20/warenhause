# Convert Pascal files to UTF-16 LE encoding for proper Arabic text display

$filesToConvert = @(
    'uAddItem.pas',
    'uArabicTexts.pas', 
    'uDatabase.pas',
    'uLogin.pas',
    'uMain.pas',
    'uReceipt.pas',
    'WarehouseSystem.dpr'
)

foreach ($filename in $filesToConvert) {
    if (Test-Path $filename) {
        try {
            # Read with current encoding
            $content = Get-Content $filename -Raw -Encoding Default
            
            # Write as UTF-16 LE (Unicode)
            $content | Out-File -FilePath $filename -Encoding Unicode
            
            Write-Host "Converted: $filename" -ForegroundColor Green
        }
        catch {
            Write-Host "Error converting $filename : $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "File not found: $filename" -ForegroundColor Yellow
    }
}

Write-Host "Encoding conversion completed!" -ForegroundColor Cyan