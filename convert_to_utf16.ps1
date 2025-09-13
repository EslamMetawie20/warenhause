# تحويل الملفات إلى UTF-16
Write-Host "تحويل الملفات إلى UTF-16..." -ForegroundColor Green

# تحويل ملفات .pas
Get-ChildItem -Path "*.pas" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode)
    Write-Host "تم تحويل: $($_.Name)" -ForegroundColor Yellow
}

# تحويل ملفات .dfm
Get-ChildItem -Path "*.dfm" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode)
    Write-Host "تم تحويل: $($_.Name)" -ForegroundColor Yellow
}

# تحويل ملفات .dpr
Get-ChildItem -Path "*.dpr" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode)
    Write-Host "تم تحويل: $($_.Name)" -ForegroundColor Yellow
}

# تحويل ملفات .dproj
Get-ChildItem -Path "*.dproj" -ErrorAction SilentlyContinue | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::Unicode)
    Write-Host "تم تحويل: $($_.Name)" -ForegroundColor Yellow
}

Write-Host "تمت عملية التحويل بنجاح!" -ForegroundColor Green