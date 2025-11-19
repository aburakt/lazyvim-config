# Kurulum Dogrulama Scripti

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Kurulum Dogrulama" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$allOk = $true

# 1. LazyVim
Write-Host "[1] LazyVim Konfigurasyon" -ForegroundColor Yellow
$nvimPath = Join-Path $env:LOCALAPPDATA "nvim"
$nvimInit = Join-Path $nvimPath "init.lua"

if (Test-Path $nvimInit) {
    Write-Host "    OK   $nvimInit" -ForegroundColor Green
    $fileCount = (Get-ChildItem $nvimPath -Recurse -File).Count
    Write-Host "         Toplam $fileCount dosya kuruldu" -ForegroundColor Gray
} else {
    Write-Host "    HATA Bulunamadi!" -ForegroundColor Red
    $allOk = $false
}
Write-Host ""

# 2. Wezterm
Write-Host "[2] Wezterm Konfigurasyon" -ForegroundColor Yellow
$weztermPath = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermPath) {
    Write-Host "    OK   $weztermPath" -ForegroundColor Green
    $size = (Get-Item $weztermPath).Length
    Write-Host "         Dosya boyutu: $([math]::Round($size/1KB, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "    HATA Bulunamadi!" -ForegroundColor Red
    $allOk = $false
}
Write-Host ""

# 3. PowerShell Profil
Write-Host "[3] PowerShell Profil" -ForegroundColor Yellow
$profilePath = $PROFILE

if (Test-Path $profilePath) {
    Write-Host "    OK   $profilePath" -ForegroundColor Green

    # Profili test et
    try {
        . $profilePath
        Write-Host "         Profil basariyla yuklendi" -ForegroundColor Gray
    } catch {
        Write-Host "         UYARI: Profil yuklenirken hata: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "    HATA Bulunamadi!" -ForegroundColor Red
    $allOk = $false
}
Write-Host ""

# 4. Execution Policy
Write-Host "[4] PowerShell Execution Policy" -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "RemoteSigned" -or $policy -eq "Unrestricted") {
    Write-Host "    OK   $policy" -ForegroundColor Green
} else {
    Write-Host "    UYARI $policy (RemoteSigned olarak ayarlanmali)" -ForegroundColor Yellow
    Write-Host "         Komutu calistirin: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
}
Write-Host ""

# Ozet
Write-Host "=====================================" -ForegroundColor Cyan
if ($allOk) {
    Write-Host " Kurulum Basarili!" -ForegroundColor Green
} else {
    Write-Host " Kurulum Tamamlanmadi!" -ForegroundColor Red
}
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Sonraki Adimlar:" -ForegroundColor Yellow
Write-Host "  1. Yeni PowerShell penceresi acin (profil otomatik yuklenecek)"
Write-Host "  2. 'nvim' yazarak Neovim'i baslatin (ilk acilista eklentiler yuklenecek)"
Write-Host "  3. 'wezterm' yazarak WezTerm'i baslatin"
Write-Host ""
Write-Host "Unix-like Komutlar:" -ForegroundColor Yellow
Write-Host "  ls, ll, cat, grep, which, touch, ... (PowerShell'de kullanilabilir)"
Write-Host "  Tam liste icin: show-aliases"
Write-Host ""
