#Requires -Version 5.1

<#
.SYNOPSIS
    ONPREM LazyVim + WezTerm Kurulum Script'i
.DESCRIPTION
    Bu script ONPREM (offline) ortamlar için hazırlanmıştır.
    Tüm gerekli araçları ve konfigürasyonları tamamen offline olarak kurar.

    Kurulum Paketi Yapısı:
    lazyvim-onprem-package/
    ├── 1-installers/          # Neovim, Git, WezTerm, vb. installer'lar
    ├── 2-config/              # Bu dizin (lazyvim-config)
    ├── 3-bundle/              # nvim-data bundle (plugin'ler, Mason tools)
    └── INSTALL_ONPREM.ps1     # Bu script

.PARAMETER SkipInstallers
    Installer'ları atlayıp sadece konfigürasyon kurulumunu yap
.PARAMETER UseOfflineConfigs
    Offline-optimized config dosyalarını kullan (auto-update kapalı)
.PARAMETER SkipBundle
    nvim-data bundle kopyalamayı atla
#>

param(
    [switch]$SkipInstallers = $false,
    [switch]$UseOfflineConfigs = $true,
    [switch]$SkipBundle = $false
)

# ============================================================================
# RENKLER VE YARDIMCI FONKSİYONLAR
# ============================================================================

function Write-Title {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] " -ForegroundColor Green -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[UYARI] " -ForegroundColor Yellow -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Error {
    param([string]$Message)
    Write-Host "[HATA] " -ForegroundColor Red -NoNewline
    Write-Host $Message -ForegroundColor White
}

# ============================================================================
# BAŞLANGIÇ
# ============================================================================

Clear-Host
Write-Title "ONPREM LazyVim + WezTerm Kurulum"

Write-Host "ONPREM Mode: Offline kurulum başlatılıyor..." -ForegroundColor Yellow
Write-Host "Paket konumu: $PSScriptRoot`n" -ForegroundColor Gray

# Ana dizinleri belirle
$packageRoot = Split-Path $PSScriptRoot -Parent
$installersDir = Join-Path $packageRoot "1-installers"
$configDir = Join-Path $packageRoot "2-config"
$bundleDir = Join-Path $packageRoot "3-bundle"

# Eğer script doğrudan config klasöründeyse, paket yapısını varsayılan konumlarda ara
if (-not (Test-Path $installersDir)) {
    $installersDir = Join-Path $PSScriptRoot "installers"
}
if (-not (Test-Path $configDir)) {
    $configDir = $PSScriptRoot
}
if (-not (Test-Path $bundleDir)) {
    $bundleDir = Join-Path $PSScriptRoot "bundle"
}

Write-Step "Paket dizinleri:"
Write-Host "  Installers: $installersDir" -ForegroundColor Gray
Write-Host "  Config    : $configDir" -ForegroundColor Gray
Write-Host "  Bundle    : $bundleDir" -ForegroundColor Gray
Write-Host ""

# ============================================================================
# ADIM 1: SİSTEM GEREKSİNİMLERİNİ KONTROL ET
# ============================================================================

Write-Title "Adım 1: Sistem Gereksinimleri Kontrolü"

$requirements = @{
    "Neovim" = @{
        Command = "nvim"
        Args = "--version"
        Pattern = "NVIM v"
        MinVersion = "0.9.0"
        Installer = "nvim-win64.msi"
    }
    "Git" = @{
        Command = "git"
        Args = "--version"
        Pattern = "git version"
        MinVersion = "2.0"
        Installer = "Git-*-64-bit.exe"
    }
    "WezTerm" = @{
        Command = "wezterm"
        Args = "--version"
        Pattern = "wezterm"
        MinVersion = "20230000"
        Installer = "WezTerm-*.exe"
        Optional = $true
    }
    "PowerShell 7" = @{
        Command = "pwsh"
        Args = "--version"
        Pattern = "PowerShell"
        MinVersion = "7.0"
        Installer = "PowerShell-*-win-x64.msi"
        Optional = $true
    }
}

$missingTools = @()

foreach ($tool in $requirements.Keys) {
    $req = $requirements[$tool]
    Write-Step "Kontrol ediliyor: $tool"

    try {
        $output = & $req.Command $req.Args 2>&1 | Out-String
        if ($output -match $req.Pattern) {
            Write-Success "$tool yüklü"
        } else {
            throw "Pattern eşleşmedi"
        }
    } catch {
        if ($req.Optional) {
            Write-Warning "$tool yüklü değil (opsiyonel)"
        } else {
            Write-Error "$tool yüklü değil!"
            $missingTools += $tool
        }
    }
}

# ============================================================================
# ADIM 2: EKSİK ARAÇLARI YÜKLE
# ============================================================================

if ($missingTools.Count -gt 0 -and -not $SkipInstallers) {
    Write-Title "Adım 2: Eksik Araçları Yükleme"

    if (-not (Test-Path $installersDir)) {
        Write-Error "Installer dizini bulunamadı: $installersDir"
        Write-Host "Lütfen installer'ları manuel olarak yükleyin:" -ForegroundColor Yellow
        foreach ($tool in $missingTools) {
            Write-Host "  - $tool" -ForegroundColor White
        }
        $continue = Read-Host "`nDevam etmek istiyor musunuz? (Y/N)"
        if ($continue -ne 'Y' -and $continue -ne 'y') {
            exit 1
        }
    } else {
        foreach ($tool in $missingTools) {
            $req = $requirements[$tool]
            Write-Step "Yükleniyor: $tool"

            # Installer dosyasını bul
            $installerPattern = Join-Path $installersDir "*" $req.Installer
            $installerFiles = Get-ChildItem $installerPattern -Recurse -ErrorAction SilentlyContinue

            if ($installerFiles.Count -eq 0) {
                Write-Warning "$tool installer'ı bulunamadı: $($req.Installer)"
                continue
            }

            $installer = $installerFiles[0].FullName
            Write-Host "  Installer: $installer" -ForegroundColor Gray

            # Installer'ı çalıştır
            try {
                if ($installer -like "*.msi") {
                    Start-Process msiexec -ArgumentList "/i `"$installer`" /qb" -Wait -NoNewWindow
                } elseif ($installer -like "*.exe") {
                    Start-Process $installer -ArgumentList "/SILENT" -Wait -NoNewWindow
                }
                Write-Success "$tool yüklendi"
            } catch {
                Write-Error "$tool yüklenemedi: $_"
            }
        }

        Write-Host "`nInstaller'lar tamamlandı. Lütfen yeni bir PowerShell oturumu açın." -ForegroundColor Yellow
        Write-Host "Ardından bu script'i tekrar çalıştırın.`n" -ForegroundColor Yellow
        Read-Host "Devam etmek için Enter'a basın"
    }
} else {
    Write-Success "Tüm gerekli araçlar yüklü!"
}

# ============================================================================
# ADIM 3: NVIM-DATA BUNDLE'INI KOPYALA
# ============================================================================

if (-not $SkipBundle) {
    Write-Title "Adım 3: Plugin ve Mason Tool Bundle'ını Kopyalama"

    $nvimDataDest = Join-Path $env:LOCALAPPDATA "nvim-data"

    if (Test-Path $bundleDir) {
        Write-Step "Bundle bulundu: $bundleDir"

        # Mevcut nvim-data'yı yedekle
        if (Test-Path $nvimDataDest) {
            $backupPath = "$nvimDataDest-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Write-Step "Mevcut nvim-data yedekleniyor: $backupPath"
            Move-Item $nvimDataDest $backupPath -Force -ErrorAction SilentlyContinue
        }

        # Bundle'ı kopyala
        Write-Step "Bundle kopyalanıyor... (Bu işlem birkaç dakika sürebilir)"
        Copy-Item $bundleDir -Destination $nvimDataDest -Recurse -Force
        Write-Success "Bundle kopyalandı: $nvimDataDest"

        # Bundle içeriğini göster
        $lazyPlugins = Get-ChildItem (Join-Path $nvimDataDest "lazy") -Directory -ErrorAction SilentlyContinue
        $masonPackages = Get-ChildItem (Join-Path $nvimDataDest "mason\packages") -Directory -ErrorAction SilentlyContinue

        Write-Host "`nBundle İçeriği:" -ForegroundColor Cyan
        Write-Host "  Plugin sayısı : $($lazyPlugins.Count)" -ForegroundColor Gray
        Write-Host "  Mason tool'lar: $($masonPackages.Count)" -ForegroundColor Gray
    } else {
        Write-Warning "Bundle dizini bulunamadı: $bundleDir"
        Write-Host "Plugin'ler ilk Neovim açılışında indirilecek (internet gerekli)" -ForegroundColor Yellow
    }
} else {
    Write-Step "Bundle kopyalama atlandı (--SkipBundle)"
}

# ============================================================================
# ADIM 4: LAZYVIM KONFIGÜRASYONUNU KOPYALA
# ============================================================================

Write-Title "Adım 4: LazyVim Konfigürasyonunu Kurma"

$nvimConfigDest = Join-Path $env:LOCALAPPDATA "nvim"

# Mevcut konfigürasyonu yedekle
if (Test-Path $nvimConfigDest) {
    $backupPath = "$nvimConfigDest-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Step "Mevcut konfigürasyon yedekleniyor: $backupPath"
    Move-Item $nvimConfigDest $backupPath -Force
}

# Yeni konfigürasyonu kopyala
Write-Step "LazyVim konfigürasyonu kopyalanıyor..."
New-Item -ItemType Directory -Path $nvimConfigDest -Force | Out-Null

# Ana dizindeki dosyaları kopyala (script'leri hariç tut)
$excludeFiles = @('.gitignore', '*.ps1', '*.md', '.git', 'wezterm', 'bundle', 'installers')
Get-ChildItem -Path $configDir -File | Where-Object {
    $name = $_.Name
    $exclude = $false
    foreach ($pattern in $excludeFiles) {
        if ($name -like $pattern) { $exclude = $true; break }
    }
    -not $exclude
} | ForEach-Object {
    Copy-Item $_.FullName -Destination $nvimConfigDest -Force
}

# lua klasörünü kopyala
$luaSource = Join-Path $configDir "lua"
if (Test-Path $luaSource) {
    Copy-Item $luaSource -Destination $nvimConfigDest -Recurse -Force
    Write-Success "lua/ klasörü kopyalandı"
}

# Offline config kullanılacak mı?
if ($UseOfflineConfigs) {
    $offlineLazy = Join-Path $configDir "lua\config\lazy-offline.lua"
    if (Test-Path $offlineLazy) {
        Write-Step "Offline-optimized lazy.nvim config kullanılıyor..."
        Copy-Item $offlineLazy -Destination (Join-Path $nvimConfigDest "lua\config\lazy.lua") -Force
        Write-Success "Offline lazy config aktif (auto-update kapalı)"
    }
}

Write-Success "LazyVim konfigürasyonu kuruldu: $nvimConfigDest"

# ============================================================================
# ADIM 5: WEZTERM KONFIGÜRASYONUNU KOPYALA
# ============================================================================

Write-Title "Adım 5: WezTerm Konfigürasyonunu Kurma"

$weztermSource = if ($UseOfflineConfigs) {
    Join-Path $configDir "wezterm\wezterm-offline.lua"
} else {
    Join-Path $configDir "wezterm\wezterm.lua"
}

$weztermDest = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermSource) {
    # Mevcut config'i yedekle
    if (Test-Path $weztermDest) {
        $backupPath = "$weztermDest.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Step "Mevcut WezTerm config yedekleniyor: $backupPath"
        Move-Item $weztermDest $backupPath -Force
    }

    Copy-Item $weztermSource -Destination $weztermDest -Force
    $configType = if ($UseOfflineConfigs) { "Offline" } else { "Online" }
    Write-Success "WezTerm konfigürasyonu kuruldu ($configType mode): $weztermDest"
} else {
    Write-Warning "WezTerm konfigürasyon dosyası bulunamadı!"
}

# ============================================================================
# ADIM 6: POWERSHELL PROFIL (Opsiyonel)
# ============================================================================

Write-Title "Adım 6: PowerShell Profil (Opsiyonel)"

$psProfileSource = Join-Path $configDir "wezterm\powershell\Microsoft.PowerShell_profile.ps1"

if (Test-Path $psProfileSource) {
    $install = Read-Host "PowerShell Unix-like komutlar profilini yüklemek istiyor musunuz? (Y/N)"

    if ($install -eq 'Y' -or $install -eq 'y') {
        $psProfileDest = $PROFILE
        $profileDir = Split-Path $psProfileDest -Parent

        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }

        if (Test-Path $psProfileDest) {
            $backupPath = "$psProfileDest.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Move-Item $psProfileDest $backupPath -Force
        }

        Copy-Item $psProfileSource -Destination $psProfileDest -Force
        Write-Success "PowerShell profili kuruldu (ls, grep, cat komutları aktif)"
    }
} else {
    Write-Step "PowerShell profil dosyası bulunamadı (atlandı)"
}

# ============================================================================
# ADIM 7: EXECUTION POLICY KONTROLÜ
# ============================================================================

Write-Title "Adım 7: PowerShell Execution Policy"

$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "Undefined") {
    Write-Warning "Execution Policy: $currentPolicy"
    Write-Host "PowerShell script'lerinin çalışması için policy değiştirilmeli.`n" -ForegroundColor Yellow

    $change = Read-Host "Execution Policy'yi şimdi değiştirmek istiyor musunuz? (Y/N)"
    if ($change -eq 'Y' -or $change -eq 'y') {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Success "Execution Policy değiştirildi: RemoteSigned"
        } catch {
            Write-Error "Policy değiştirilemedi: $_"
        }
    }
} else {
    Write-Success "Execution Policy uygun: $currentPolicy"
}

# ============================================================================
# ADIM 8: DOĞRULAMA
# ============================================================================

Write-Title "Adım 8: Kurulum Doğrulama"

$verifyScript = Join-Path $configDir "verify-onprem.ps1"
if (Test-Path $verifyScript) {
    Write-Step "Doğrulama script'i çalıştırılıyor..."
    & $verifyScript
} else {
    Write-Warning "verify-onprem.ps1 bulunamadı, manuel doğrulama yapılmalı"

    # Basit doğrulama
    $checks = @(
        @{ Path = (Join-Path $env:LOCALAPPDATA "nvim\init.lua"); Name = "LazyVim init.lua" },
        @{ Path = (Join-Path $env:LOCALAPPDATA "nvim\lua\config\lazy.lua"); Name = "lazy.nvim config" },
        @{ Path = (Join-Path $env:USERPROFILE ".wezterm.lua"); Name = "WezTerm config" }
    )

    foreach ($check in $checks) {
        if (Test-Path $check.Path) {
            Write-Success "$($check.Name) mevcut"
        } else {
            Write-Error "$($check.Name) eksik!"
        }
    }
}

# ============================================================================
# ÖZET VE SONRAKİ ADIMLAR
# ============================================================================

Write-Title "Kurulum Tamamlandı!"

Write-Host "ONPREM Kurulum Özeti:" -ForegroundColor Cyan
Write-Host "  LazyVim config  : $nvimConfigDest" -ForegroundColor Gray
Write-Host "  WezTerm config  : $weztermDest" -ForegroundColor Gray
if (-not $SkipBundle -and (Test-Path (Join-Path $env:LOCALAPPDATA "nvim-data"))) {
    Write-Host "  Plugin bundle   : Kopyalandı" -ForegroundColor Gray
}
Write-Host "  Offline mode    : " -NoNewline -ForegroundColor Gray
Write-Host $(if ($UseOfflineConfigs) { "Aktif" } else { "Pasif" }) -ForegroundColor $(if ($UseOfflineConfigs) { "Green" } else { "Yellow" })
Write-Host ""

Write-Host "Sonraki Adımlar:" -ForegroundColor Yellow
Write-Host "1. " -NoNewline -ForegroundColor White
Write-Host "Yeni bir terminal penceresi açın (WezTerm önerilir)" -ForegroundColor Gray
Write-Host ""

Write-Host "2. " -NoNewline -ForegroundColor White
Write-Host "Neovim'i başlatın:" -ForegroundColor Gray
Write-Host "   nvim" -ForegroundColor Cyan
if (-not $SkipBundle) {
    Write-Host "   (Plugin'ler bundle'dan yüklü, otomatik indirilmeyecek)" -ForegroundColor Gray
} else {
    Write-Host "   (İlk açılışta plugin'ler indirilecek - internet gerekli)" -ForegroundColor Gray
}
Write-Host ""

Write-Host "3. " -NoNewline -ForegroundColor White
Write-Host "LazyVim sağlık kontrolü yapın:" -ForegroundColor Gray
Write-Host "   :checkhealth" -ForegroundColor Cyan
Write-Host ""

Write-Host "4. " -NoNewline -ForegroundColor White
Write-Host "Mason tool'ları kontrol edin:" -ForegroundColor Gray
Write-Host "   :Mason" -ForegroundColor Cyan
Write-Host ""

Write-Host "Dokümantasyon:" -ForegroundColor Yellow
Write-Host "  ONPREM_KURULUM.md     : Detaylı kurulum rehberi" -ForegroundColor Gray
Write-Host "  INSTALLATION_CHECKLIST.md : Kurulum kontrol listesi" -ForegroundColor Gray
Write-Host ""

Write-Host "Kurulum loglarını saklamak ister misiniz? (kayıt için)" -ForegroundColor Yellow
$saveLog = Read-Host "(Y/N)"
if ($saveLog -eq 'Y' -or $saveLog -eq 'y') {
    $logPath = Join-Path $env:USERPROFILE "lazyvim-onprem-install-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    Start-Transcript -Path $logPath
    Write-Success "Log kaydedildi: $logPath"
}

Write-Host "`nİyi çalışmalar! 🚀" -ForegroundColor Green
Write-Host ""
