param($filename)
$content = Get-Content $filename -Raw
$utf16 = [System.Text.Encoding]::Unicode
[System.IO.File]::WriteAllText($filename, $content, $utf16)
Write-Host "Converted: $filename"