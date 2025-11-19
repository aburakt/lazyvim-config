# LazyVim ve Wezterm Windows Kurulum Scripti
# Bu script, LazyVim ve Wezterm konfigürasyonlarını Windows sistemine kurar

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "LazyVim ve Wezterm Kurulum Scripti" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. LazyVim konfigürasyonlarını kur
Write-Host "[1/4] LazyVim konfigürasyonlarını kurma..." -ForegroundColor Yellow

$nvimConfigPath = Join-Path $env:LOCALAPPDATA "nvim"
$currentPath = $PSScriptRoot

# Mevcut konfigürasyonu yedekle (varsa)
if (Test-Path $nvimConfigPath) {
    $backupPath = "$nvimConfigPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "  Mevcut konfigürasyon yedekleniyor: $backupPath" -ForegroundColor Gray
    Move-Item $nvimConfigPath $backupPath -Force
}

# Yeni konfigürasyonu kopyala
Write-Host "  Konfigürasyon dosyaları kopyalanıyor..." -ForegroundColor Gray
New-Item -ItemType Directory -Path $nvimConfigPath -Force | Out-Null

# Ana dizindeki dosyaları kopyala
Get-ChildItem -Path $currentPath -File | Where-Object { $_.Name -notin @('.gitignore', 'install-windows.ps1', 'ONPREM_KURULUM.md') } | ForEach-Object {
    Copy-Item $_.FullName -Destination $nvimConfigPath -Force
}

# lua klasörünü kopyala
if (Test-Path (Join-Path $currentPath "lua")) {
    Copy-Item (Join-Path $currentPath "lua") -Destination $nvimConfigPath -Recurse -Force
}

Write-Host "  LazyVim konfigürasyonu kuruldu: $nvimConfigPath" -ForegroundColor Green
Write-Host ""

# 2. Wezterm konfigürasyonunu kur
Write-Host "[2/4] Wezterm konfigürasyonunu kurma..." -ForegroundColor Yellow

$weztermConfigSource = Join-Path $currentPath "wezterm\wezterm.lua"
$weztermConfigDest = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermConfigSource) {
    # Mevcut konfigürasyonu yedekle (varsa)
    if (Test-Path $weztermConfigDest) {
        $backupPath = "$weztermConfigDest.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Host "  Mevcut Wezterm konfigürasyonu yedekleniyor: $backupPath" -ForegroundColor Gray
        Move-Item $weztermConfigDest $backupPath -Force
    }

    Copy-Item $weztermConfigSource -Destination $weztermConfigDest -Force
    Write-Host "  Wezterm konfigürasyonu kuruldu: $weztermConfigDest" -ForegroundColor Green
} else {
    Write-Host "  UYARI: Wezterm konfigürasyon dosyası bulunamadı!" -ForegroundColor Red
}
Write-Host ""

# 3. PowerShell profil dosyasını kur
Write-Host "[3/4] PowerShell profil dosyasını kurma (Unix-like komutlar)..." -ForegroundColor Yellow

$psProfileSource = Join-Path $currentPath "wezterm\powershell\Microsoft.PowerShell_profile.ps1"
$psProfileDest = $PROFILE

if (Test-Path $psProfileSource) {
    # Profil dizinini oluştur (yoksa)
    $profileDir = Split-Path $psProfileDest -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        Write-Host "  PowerShell profil dizini oluşturuldu: $profileDir" -ForegroundColor Gray
    }

    # Mevcut profili yedekle (varsa)
    if (Test-Path $psProfileDest) {
        $backupPath = "$psProfileDest.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Host "  Mevcut PowerShell profili yedekleniyor: $backupPath" -ForegroundColor Gray
        Move-Item $psProfileDest $backupPath -Force
    }

    Copy-Item $psProfileSource -Destination $psProfileDest -Force
    Write-Host "  PowerShell profili kuruldu: $psProfileDest" -ForegroundColor Green
    Write-Host "  Unix-like komutlar (ls, grep, cat, vb.) artık kullanılabilir!" -ForegroundColor Green
} else {
    Write-Host "  UYARI: PowerShell profil dosyası bulunamadı!" -ForegroundColor Red
}
Write-Host ""

# 4. Execution Policy kontrolü
Write-Host "[4/4] PowerShell Execution Policy kontrol ediliyor..." -ForegroundColor Yellow

$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "Undefined") {
    Write-Host "  Execution Policy şu anda: $currentPolicy" -ForegroundColor Gray
    Write-Host "  PowerShell profilinin çalışması için Execution Policy değiştirilmeli." -ForegroundColor Yellow
    Write-Host "  Şu komutu çalıştırın (Yönetici PowerShell'de):" -ForegroundColor Yellow
    Write-Host "    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Cyan
} else {
    Write-Host "  Execution Policy uygun: $currentPolicy" -ForegroundColor Green
}
Write-Host ""

# Özet
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Kurulum Tamamlandı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sonraki Adımlar:" -ForegroundColor Yellow
Write-Host "1. Neovim'i başlatın:" -ForegroundColor White
Write-Host "   nvim" -ForegroundColor Cyan
Write-Host "   (İlk açılışta eklentiler otomatik yüklenecek)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Wezterm'i başlatın:" -ForegroundColor White
Write-Host "   wezterm" -ForegroundColor Cyan
Write-Host "   (Klavye kısayolları: CTRL+T=yeni tab, CTRL+D=split)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. PowerShell profilini yükleyin:" -ForegroundColor White
Write-Host "   Yeni bir PowerShell penceresi açın veya mevcut pencerede:" -ForegroundColor Gray
Write-Host "   . `$PROFILE" -ForegroundColor Cyan
Write-Host ""
Write-Host "Daha fazla bilgi için README.md dosyasına bakın." -ForegroundColor Gray
Write-Host ""
