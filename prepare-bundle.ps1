#Requires -Version 5.1

<#
.SYNOPSIS
    ONPREM Paket Bundle Hazırlayıcı
.DESCRIPTION
    Bu script İNTERNET BAĞLANTISI OLAN bir makinede çalıştırılmalıdır.
    LazyVim plugin'lerini ve Mason tool'larını indirir ve ONPREM paketi için hazırlar.

    Kullanım Senaryosu:
    1. İnternet bağlantılı Windows makinesinde bu script'i çalıştır
    2. Script tüm plugin'leri ve tool'ları indirecek
    3. nvim-data klasörünü bundle klasörüne kopyalayacak
    4. Bu bundle'ı ONPREM pakete ekle
    5. ONPREM makinede INSTALL_ONPREM.ps1'i çalıştır

.PARAMETER OutputDir
    Bundle'ın kaydedileceği dizin (varsayılan: .\bundle)
.PARAMETER CleanInstall
    Mevcut nvim ve nvim-data'yı sil, temiz kurulum yap
#>

param(
    [string]$OutputDir = (Join-Path $PSScriptRoot "bundle"),
    [switch]$CleanInstall = $false
)

# ============================================================================
# YARDIMCI FONKSİYONLAR
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
Write-Title "ONPREM Bundle Hazırlayıcı"

Write-Host "Bu script İNTERNET BAĞLANTISI gerektirir!" -ForegroundColor Yellow
Write-Host "LazyVim plugin'leri ve Mason tool'ları indirilecek.`n" -ForegroundColor Yellow

$continue = Read-Host "Devam etmek istiyor musunuz? (Y/N)"
if ($continue -ne 'Y' -and $continue -ne 'y') {
    Write-Host "İptal edildi." -ForegroundColor Gray
    exit 0
}

# ============================================================================
# ADIM 1: GEREKSINIM KONTROLÜ
# ============================================================================

Write-Title "Adım 1: Gereksinim Kontrolü"

# Neovim kontrolü
Write-Step "Neovim kontrolü..."
try {
    $nvimVersion = nvim --version 2>&1 | Select-Object -First 1
    Write-Success "Neovim yüklü: $nvimVersion"
} catch {
    Write-Error "Neovim yüklü değil!"
    Write-Host "Lütfen önce Neovim'i yükleyin: https://github.com/neovim/neovim/releases`n" -ForegroundColor Yellow
    exit 1
}

# Git kontrolü
Write-Step "Git kontrolü..."
try {
    $gitVersion = git --version
    Write-Success "Git yüklü: $gitVersion"
} catch {
    Write-Error "Git yüklü değil!"
    Write-Host "Lütfen önce Git'i yükleyin: https://git-scm.com/download/win`n" -ForegroundColor Yellow
    exit 1
}

# İnternet kontrolü
Write-Step "İnternet bağlantısı kontrolü..."
try {
    $null = Test-Connection github.com -Count 1 -ErrorAction Stop
    Write-Success "İnternet bağlantısı mevcut"
} catch {
    Write-Error "İnternet bağlantısı yok!"
    Write-Host "Bu script internet bağlantısı gerektirir.`n" -ForegroundColor Yellow
    exit 1
}

# ============================================================================
# ADIM 2: TEMİZ KURULUM (Opsiyonel)
# ============================================================================

if ($CleanInstall) {
    Write-Title "Adım 2: Temiz Kurulum (Clean Install)"

    $nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
    $nvimData = Join-Path $env:LOCALAPPDATA "nvim-data"

    Write-Warning "Mevcut LazyVim kurulumu silinecek!"
    Write-Host "  Config: $nvimConfig" -ForegroundColor Gray
    Write-Host "  Data  : $nvimData" -ForegroundColor Gray

    $confirm = Read-Host "`nEmin misiniz? (Y/N)"
    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        if (Test-Path $nvimConfig) {
            Remove-Item $nvimConfig -Recurse -Force
            Write-Success "nvim config silindi"
        }
        if (Test-Path $nvimData) {
            Remove-Item $nvimData -Recurse -Force
            Write-Success "nvim-data silindi"
        }
    }
}

# ============================================================================
# ADIM 3: LAZYVIM KONFIGÜRASYONUNU KOPYALA
# ============================================================================

Write-Title "Adım 3: LazyVim Konfigürasyonunu Kurma"

$nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
$configSource = $PSScriptRoot

# Config klasörünü kopyala (eğer henüz yoksa)
if (-not (Test-Path $nvimConfig)) {
    Write-Step "LazyVim config kopyalanıyor..."

    New-Item -ItemType Directory -Path $nvimConfig -Force | Out-Null

    # Ana dosyaları kopyala
    $excludeFiles = @('.gitignore', '*.ps1', '*.md', '.git', 'wezterm', 'bundle', 'installers')
    Get-ChildItem -Path $configSource -File | Where-Object {
        $name = $_.Name
        $exclude = $false
        foreach ($pattern in $excludeFiles) {
            if ($name -like $pattern) { $exclude = $true; break }
        }
        -not $exclude
    } | ForEach-Object {
        Copy-Item $_.FullName -Destination $nvimConfig -Force
    }

    # lua klasörünü kopyala
    $luaSource = Join-Path $configSource "lua"
    if (Test-Path $luaSource) {
        Copy-Item $luaSource -Destination $nvimConfig -Recurse -Force
    }

    Write-Success "LazyVim config kuruldu: $nvimConfig"
} else {
    Write-Success "LazyVim config zaten mevcut: $nvimConfig"
}

# ============================================================================
# ADIM 4: LAZYVIM PLUGIN'LERİNİ İNDİR
# ============================================================================

Write-Title "Adım 4: LazyVim Plugin'lerini İndirme"

Write-Host "Neovim açılıp tüm plugin'ler indirilecek." -ForegroundColor Yellow
Write-Host "Bu işlem birkaç dakika sürebilir...`n" -ForegroundColor Yellow

Write-Step "Neovim başlatılıyor ve plugin'ler indiriliyor..."
Write-Host "  Komut: nvim --headless '+Lazy! sync' +qa`n" -ForegroundColor Gray

# Headless modda Neovim'i başlat ve plugin'leri indir
$nvimOutput = nvim --headless "+Lazy! sync" +qa 2>&1

Write-Success "Plugin indirme tamamlandı"

# Plugin sayısını kontrol et
$nvimData = Join-Path $env:LOCALAPPDATA "nvim-data"
$lazyDir = Join-Path $nvimData "lazy"

if (Test-Path $lazyDir) {
    $plugins = Get-ChildItem $lazyDir -Directory
    Write-Success "$($plugins.Count) plugin indirildi"
} else {
    Write-Error "Plugin dizini bulunamadı: $lazyDir"
    exit 1
}

# ============================================================================
# ADIM 5: MASON TOOL'LARINI İNDİR
# ============================================================================

Write-Title "Adım 5: Mason Tool'larını İndirme"

Write-Host "Mason LSP server'ları, formatter'lar ve linter'lar indiriliyor..." -ForegroundColor Yellow
Write-Host "Bu işlem 5-10 dakika sürebilir.`n" -ForegroundColor Yellow

# Mason tool listesi (lsp.lua ve diğer plugin config'lerden)
$masonTools = @(
    # LSP Servers
    "lua-language-server",
    "typescript-language-server",
    "astro-language-server",
    "vue-language-server",
    "tailwindcss-language-server",
    "css-lsp",
    "html-lsp",
    "json-lsp",
    "yaml-language-server",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "emmet-ls",
    "jdtls",

    # Formatters
    "prettier",
    "stylua",
    "google-java-format",

    # Linters
    "eslint_d",

    # Debug Adapters
    "java-debug-adapter",
    "java-test"
)

Write-Step "Toplam $($masonTools.Count) Mason tool indirilecek"

# Mason komutlarını oluştur
$masonCommands = $masonTools | ForEach-Object { "MasonInstall $_" }
$masonCmd = ($masonCommands -join " | ") + " | qa"

Write-Host "  Komut: nvim --headless '+$masonCmd'`n" -ForegroundColor Gray

# Mason tool'larını indir
try {
    foreach ($tool in $masonTools) {
        Write-Step "İndiriliyor: $tool"
        $output = nvim --headless "+MasonInstall $tool" +qa 2>&1
        Start-Sleep -Seconds 2  # Rate limiting
    }
    Write-Success "Mason tool'lar indirme tamamlandı"
} catch {
    Write-Warning "Bazı Mason tool'lar indirilememiş olabilir: $_"
}

# Mason tool sayısını kontrol et
$masonPackagesDir = Join-Path $nvimData "mason\packages"
if (Test-Path $masonPackagesDir) {
    $packages = Get-ChildItem $masonPackagesDir -Directory
    Write-Success "$($packages.Count) Mason tool indirildi"
} else {
    Write-Warning "Mason packages dizini bulunamadı"
}

# ============================================================================
# ADIM 6: NVIM-DATA BUNDLE'INI OLUŞTUR
# ============================================================================

Write-Title "Adım 6: Bundle Oluşturma"

Write-Step "Bundle dizini oluşturuluyor: $OutputDir"

# Mevcut bundle'ı temizle
if (Test-Path $OutputDir) {
    Write-Warning "Mevcut bundle siliniyor..."
    Remove-Item $OutputDir -Recurse -Force
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

# nvim-data'yı bundle'a kopyala
Write-Step "nvim-data kopyalanıyor... (Bu işlem birkaç dakika sürebilir)"
Write-Host "  Kaynak: $nvimData" -ForegroundColor Gray
Write-Host "  Hedef : $OutputDir`n" -ForegroundColor Gray

Copy-Item $nvimData\* -Destination $OutputDir -Recurse -Force

Write-Success "Bundle oluşturuldu: $OutputDir"

# ============================================================================
# ADIM 7: BUNDLE İSTATİSTİKLERİ
# ============================================================================

Write-Title "Bundle İstatistikleri"

# Boyut hesapla
$bundleSize = (Get-ChildItem $OutputDir -Recurse | Measure-Object -Property Length -Sum).Sum
$bundleSizeMB = [math]::Round($bundleSize / 1MB, 2)
$bundleSizeGB = [math]::Round($bundleSize / 1GB, 2)

Write-Host "Bundle İçeriği:" -ForegroundColor Cyan

# Plugin sayısı
$bundleLazyDir = Join-Path $OutputDir "lazy"
if (Test-Path $bundleLazyDir) {
    $bundlePlugins = Get-ChildItem $bundleLazyDir -Directory
    Write-Host "  Plugin'ler     : $($bundlePlugins.Count)" -ForegroundColor Gray
}

# Mason tool sayısı
$bundleMasonDir = Join-Path $OutputDir "mason\packages"
if (Test-Path $bundleMasonDir) {
    $bundleMasonTools = Get-ChildItem $bundleMasonDir -Directory
    Write-Host "  Mason tool'lar : $($bundleMasonTools.Count)" -ForegroundColor Gray
}

# Treesitter parser'ları
$bundleTreesitterDir = Join-Path $OutputDir "lazy\nvim-treesitter\parser"
if (Test-Path $bundleTreesitterDir) {
    $parsers = Get-ChildItem $bundleTreesitterDir -File
    Write-Host "  Treesitter     : $($parsers.Count) parser" -ForegroundColor Gray
}

Write-Host "  Toplam Boyut   : $bundleSizeMB MB ($bundleSizeGB GB)" -ForegroundColor Gray
Write-Host ""

# ============================================================================
# ADIM 8: BUNDLE DOĞRULAMA
# ============================================================================

Write-Title "Adım 8: Bundle Doğrulama"

$criticalDirs = @(
    "lazy\lazy.nvim",
    "lazy\LazyVim",
    "mason\packages",
    "state"
)

$allOk = $true
foreach ($dir in $criticalDirs) {
    $fullPath = Join-Path $OutputDir $dir
    if (Test-Path $fullPath) {
        Write-Success "$dir mevcut"
    } else {
        Write-Error "$dir EKSIK!"
        $allOk = $false
    }
}

if ($allOk) {
    Write-Success "`nBundle doğrulama başarılı!"
} else {
    Write-Error "`nBundle doğrulama başarısız! Bazı kritik dosyalar eksik."
    exit 1
}

# ============================================================================
# ADIM 9: ONPREM PAKET YAPISI OLUŞTURMA (Opsiyonel)
# ============================================================================

Write-Title "Adım 9: ONPREM Paket Yapısı"

Write-Host "Tam ONPREM paketi oluşturmak istiyor musunuz?" -ForegroundColor Yellow
Write-Host "Bu, installer klasörü ve dokümantasyonla birlikte hazır paket oluşturur.`n" -ForegroundColor Gray

$createPackage = Read-Host "ONPREM paketi oluştur? (Y/N)"

if ($createPackage -eq 'Y' -or $createPackage -eq 'y') {
    $packageRoot = Join-Path $PSScriptRoot "lazyvim-onprem-package"

    Write-Step "Paket yapısı oluşturuluyor: $packageRoot"

    # Dizinleri oluştur
    $packageDirs = @(
        "1-installers\neovim",
        "1-installers\git",
        "1-installers\wezterm",
        "1-installers\powershell",
        "1-installers\fonts",
        "1-installers\compiler",
        "1-installers\jdk",
        "2-config",
        "3-bundle"
    )

    foreach ($dir in $packageDirs) {
        $fullPath = Join-Path $packageRoot $dir
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }

    # Config dosyalarını kopyala
    Write-Step "Config dosyaları kopyalanıyor..."
    Copy-Item $PSScriptRoot\* -Destination (Join-Path $packageRoot "2-config") -Recurse -Force

    # Bundle'ı kopyala
    Write-Step "Bundle kopyalanıyor..."
    Copy-Item $OutputDir\* -Destination (Join-Path $packageRoot "3-bundle") -Recurse -Force

    # INSTALL_ONPREM.ps1'i root'a kopyala
    $installScript = Join-Path $PSScriptRoot "INSTALL_ONPREM.ps1"
    if (Test-Path $installScript) {
        Copy-Item $installScript -Destination $packageRoot -Force
    }

    # README oluştur
    $readmePath = Join-Path $packageRoot "README-ONPREM.md"
    @"
# LazyVim + WezTerm ONPREM Kurulum Paketi

Bu paket tamamen offline kurulum için hazırlanmıştır.

## Paket İçeriği

\`\`\`
lazyvim-onprem-package/
├── 1-installers/          # Gerekli installer'lar (manuel indirmelisiniz)
│   ├── neovim/           # nvim-win64.msi
│   ├── git/              # Git-*-64-bit.exe
│   ├── wezterm/          # WezTerm-*.exe
│   ├── powershell/       # PowerShell-7.*.msi
│   ├── fonts/            # CascadiaCode.zip
│   ├── compiler/         # MSYS2 veya Visual Studio Build Tools
│   └── jdk/              # JDK 17+ (opsiyonel)
│
├── 2-config/              # LazyVim ve WezTerm konfigürasyonları
│   ├── init.lua
│   ├── lua/
│   ├── wezterm/
│   └── *.ps1 script'ler
│
├── 3-bundle/              # Önceden indirilmiş plugin'ler ve Mason tool'lar
│   ├── lazy/             # LazyVim plugin'leri ($($bundlePlugins.Count) adet)
│   └── mason/            # LSP, formatter, linter ($($bundleMasonTools.Count) adet)
│
├── INSTALL_ONPREM.ps1     # Ana kurulum script'i (BU SCRIPT'İ ÇALIŞTIRIN)
└── README-ONPREM.md       # Bu dosya
\`\`\`

## Kurulum Adımları

### 1. Installer'ları İndirin (İnternet bağlantılı makinede)

\`DOWNLOAD_LINKS.md\` dosyasındaki linkleri kullanarak tüm installer'ları indirin
ve ilgili klasörlere yerleştirin.

### 2. Paketi ONPREM Makineye Taşıyın

Tüm \`lazyvim-onprem-package\` klasörünü USB veya network drive ile hedef makineye kopyalayın.

### 3. Kurulum Script'ini Çalıştırın

PowerShell'i açın ve:

\`\`\`powershell
cd lazyvim-onprem-package
.\INSTALL_ONPREM.ps1
\`\`\`

### 4. Neovim'i Başlatın

\`\`\`bash
nvim
\`\`\`

Tüm plugin'ler ve LSP tool'lar bundle'dan yüklenecek, internet gerekmez!

## Bundle Bilgileri

- **Oluşturulma:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- **Plugin Sayısı:** $($bundlePlugins.Count)
- **Mason Tool Sayısı:** $($bundleMasonTools.Count)
- **Toplam Boyut:** $bundleSizeMB MB ($bundleSizeGB GB)

## Sorun Giderme

Detaylı dokümantasyon için:
- \`2-config/ONPREM_KURULUM.md\`
- \`2-config/INSTALLATION_CHECKLIST.md\`
- \`2-config/BUNDLE_PREPARATION.md\`

## Notlar

- Bu paket Windows 10/11 için hazırlanmıştır
- Minimum gereksinim: Windows 10 1903+
- PowerShell 5.1+ gereklidir
"@ | Set-Content $readmePath -Encoding UTF8

    Write-Success "ONPREM paketi oluşturuldu: $packageRoot"
    Write-Host ""
    Write-Host "Sonraki Adımlar:" -ForegroundColor Yellow
    Write-Host "1. DOWNLOAD_LINKS.md'deki linkleri kullanarak installer'ları indirin" -ForegroundColor Gray
    Write-Host "2. Installer'ları 1-installers/ altındaki ilgili klasörlere yerleştirin" -ForegroundColor Gray
    Write-Host "3. Tüm paketi ONPREM makineye kopyalayın" -ForegroundColor Gray
    Write-Host "4. INSTALL_ONPREM.ps1'i çalıştırın`n" -ForegroundColor Gray
}

# ============================================================================
# ÖZET
# ============================================================================

Write-Title "Bundle Hazırlık Tamamlandı!"

Write-Host "Özet:" -ForegroundColor Cyan
Write-Host "  Bundle konumu  : $OutputDir" -ForegroundColor Gray
Write-Host "  Plugin sayısı  : $($bundlePlugins.Count)" -ForegroundColor Gray
Write-Host "  Mason tool'lar : $($bundleMasonTools.Count)" -ForegroundColor Gray
Write-Host "  Toplam boyut   : $bundleSizeMB MB ($bundleSizeGB GB)" -ForegroundColor Gray
Write-Host ""

Write-Host "Bu bundle'ı ONPREM pakete eklemek için:" -ForegroundColor Yellow
Write-Host "1. Bundle'ı \`3-bundle\` klasörü olarak ONPREM pakete kopyalayın" -ForegroundColor Gray
Write-Host "2. INSTALL_ONPREM.ps1 script'i bundle'ı otomatik olarak kullanacak`n" -ForegroundColor Gray

Write-Host "Bundle başarıyla hazırlandı! 🎉" -ForegroundColor Green
Write-Host ""
