# PowerShell profil dosyasını kontrol et
$profilePath = "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

if (Test-Path $profilePath) {
    Write-Host "Profil dosyasi: $profilePath" -ForegroundColor Cyan
    Write-Host ""

    # Sorunlu satırları bul
    $lines = Get-Content $profilePath
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        if ($line -match '<|>') {
            Write-Host "Satir $lineNum : $line" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "326. satir:" -ForegroundColor Yellow
    Write-Host $lines[325] -ForegroundColor White
} else {
    Write-Host "Profil dosyasi bulunamadi!" -ForegroundColor Red
}
