#Requires -Version 5.1

<#
.SYNOPSIS
    ONPREM Kurulum Doğrulama Script'i
.DESCRIPTION
    ONPREM LazyVim + WezTerm kurulumunun başarılı olup olmadığını detaylı şekilde kontrol eder.
    - Config dosyalarının varlığı
    - Plugin bundle'ının kopyalanması
    - Mason tool'larının varlığı
    - Offline mode ayarları
    - Sistem gereksinimleri
#>

# ============================================================================
# YARDIMCI FONKSİYONLAR
# ============================================================================

function Write-Title {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Check {
    param([string]$Name)
    Write-Host "[$Name] " -ForegroundColor Yellow -NoNewline
}

function Write-OK {
    param([string]$Message)
    Write-Host "OK  " -ForegroundColor Green -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Fail {
    param([string]$Message)
    Write-Host "FAIL" -ForegroundColor Red -NoNewline
    Write-Host " $Message" -ForegroundColor White
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARN" -ForegroundColor Yellow -NoNewline
    Write-Host " $Message" -ForegroundColor White
}

function Write-Info {
    param([string]$Message)
    Write-Host "     $Message" -ForegroundColor Gray
}

# ============================================================================
# BAŞLANGIÇ
# ============================================================================

Clear-Host
Write-Title "ONPREM Kurulum Doğrulama"

$script:allOk = $true
$script:warnings = 0
$script:errors = 0

# ============================================================================
# 1. SİSTEM GEREKSİNİMLERİ
# ============================================================================

Write-Title "1. Sistem Gereksinimleri"

# Neovim
Write-Check "Neovim"
try {
    $nvimVersion = (nvim --version 2>&1 | Select-Object -First 1) -replace "NVIM v", ""
    Write-OK "v$nvimVersion yüklü"
} catch {
    Write-Fail "Yüklü değil!"
    $script:errors++
    $script:allOk = $false
}

# Git
Write-Check "Git"
try {
    $gitVersion = (git --version) -replace "git version ", ""
    Write-OK "v$gitVersion yüklü"
} catch {
    Write-Fail "Yüklü değil!"
    $script:errors++
    $script:allOk = $false
}

# WezTerm (opsiyonel)
Write-Check "WezTerm"
try {
    $weztermVersion = wezterm --version 2>&1 | Out-String
    Write-OK "Yüklü"
} catch {
    Write-Warn "Yüklü değil (opsiyonel)"
    $script:warnings++
}

# PowerShell 7 (opsiyonel)
Write-Check "PowerShell 7"
try {
    $pwshVersion = pwsh --version 2>&1
    Write-OK "$pwshVersion yüklü"
} catch {
    Write-Warn "Yüklü değil (opsiyonel)"
    $script:warnings++
}

# ============================================================================
# 2. LAZYVIM KONFIGÜRASYONU
# ============================================================================

Write-Title "2. LazyVim Konfigürasyon Dosyaları"

$nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"

# init.lua
Write-Check "init.lua"
$initLua = Join-Path $nvimConfig "init.lua"
if (Test-Path $initLua) {
    Write-OK $initLua
} else {
    Write-Fail "Bulunamadı!"
    $script:errors++
    $script:allOk = $false
}

# lazy.lua
Write-Check "lazy.lua"
$lazyLua = Join-Path $nvimConfig "lua\config\lazy.lua"
if (Test-Path $lazyLua) {
    Write-OK $lazyLua

    # Offline mode kontrolü
    $lazyContent = Get-Content $lazyLua -Raw
    if ($lazyContent -match 'checker\s*=\s*\{[^}]*enabled\s*=\s*false') {
        Write-Info "Offline mode: Aktif (checker.enabled = false)"
    } elseif ($lazyContent -match 'ONPREM') {
        Write-Info "Offline mode: Aktif (ONPREM config)"
    } else {
        Write-Info "Offline mode: Pasif (auto-update açık olabilir)"
    }
} else {
    Write-Fail "Bulunamadı!"
    $script:errors++
    $script:allOk = $false
}

# lua klasörü
Write-Check "lua/ dizini"
$luaDir = Join-Path $nvimConfig "lua"
if (Test-Path $luaDir) {
    $luaFiles = (Get-ChildItem $luaDir -Recurse -File).Count
    Write-OK "$luaFiles dosya mevcut"
} else {
    Write-Fail "Bulunamadı!"
    $script:errors++
    $script:allOk = $false
}

# lazy-lock.json
Write-Check "lazy-lock.json"
$lazyLock = Join-Path $nvimConfig "lazy-lock.json"
if (Test-Path $lazyLock) {
    $lockContent = Get-Content $lazyLock -Raw | ConvertFrom-Json
    $pluginCount = ($lockContent.PSObject.Properties | Measure-Object).Count
    Write-OK "$pluginCount plugin kilidi mevcut"
} else {
    Write-Warn "Bulunamadı (ilk çalıştırmada oluşacak)"
    $script:warnings++
}

# ============================================================================
# 3. PLUGIN BUNDLE
# ============================================================================

Write-Title "3. Plugin Bundle (nvim-data)"

$nvimData = Join-Path $env:LOCALAPPDATA "nvim-data"

# nvim-data dizini
Write-Check "nvim-data"
if (Test-Path $nvimData) {
    Write-OK $nvimData
} else {
    Write-Fail "Bulunamadı! Bundle kopyalanmamış olabilir."
    $script:errors++
    $script:allOk = $false
}

# lazy.nvim
Write-Check "lazy.nvim"
$lazyNvim = Join-Path $nvimData "lazy\lazy.nvim"
if (Test-Path $lazyNvim) {
    Write-OK "Plugin manager mevcut"
} else {
    Write-Fail "Bulunamadı!"
    $script:errors++
    $script:allOk = $false
}

# Plugin'ler
Write-Check "Plugin'ler"
$lazyPluginsDir = Join-Path $nvimData "lazy"
if (Test-Path $lazyPluginsDir) {
    $plugins = Get-ChildItem $lazyPluginsDir -Directory
    if ($plugins.Count -gt 5) {
        Write-OK "$($plugins.Count) plugin yüklü"
        Write-Info "LazyVim, tokyonight, lualine, telescope, nvim-treesitter, vb."
    } else {
        Write-Warn "Sadece $($plugins.Count) plugin bulundu (beklenenden az)"
        $script:warnings++
    }
} else {
    Write-Fail "lazy/ dizini bulunamadı!"
    $script:errors++
    $script:allOk = $false
}

# ============================================================================
# 4. MASON TOOLS
# ============================================================================

Write-Title "4. Mason Tools (LSP, Formatter, Linter)"

$masonDir = Join-Path $nvimData "mason"

# Mason dizini
Write-Check "Mason"
if (Test-Path $masonDir) {
    Write-OK $masonDir
} else {
    Write-Warn "Mason dizini bulunamadı (ilk çalıştırmada oluşacak)"
    $script:warnings++
}

# Mason packages
Write-Check "Mason Packages"
$masonPackages = Join-Path $masonDir "packages"
if (Test-Path $masonPackages) {
    $packages = Get-ChildItem $masonPackages -Directory
    if ($packages.Count -gt 0) {
        Write-OK "$($packages.Count) tool yüklü"

        # Önemli tool'ları kontrol et
        $criticalTools = @(
            "lua-language-server",
            "typescript-language-server",
            "prettier",
            "stylua"
        )

        foreach ($tool in $criticalTools) {
            $toolPath = Join-Path $masonPackages $tool
            if (Test-Path $toolPath) {
                Write-Info "$tool: OK"
            }
        }
    } else {
        Write-Warn "Hiç Mason tool bulunamadı"
        Write-Info "Mason tool'ları manuel yüklenmeli: :Mason"
        $script:warnings++
    }
} else {
    Write-Warn "Mason packages bulunamadı"
    Write-Info "İlk Neovim çalıştırmasında Mason tool'ları yüklenebilir"
    $script:warnings++
}

# ============================================================================
# 5. WEZTERM KONFIGÜRASYONU
# ============================================================================

Write-Title "5. WezTerm Konfigürasyonu"

Write-Check ".wezterm.lua"
$weztermConfig = Join-Path $env:USERPROFILE ".wezterm.lua"
if (Test-Path $weztermConfig) {
    $size = (Get-Item $weztermConfig).Length
    $sizeKB = [math]::Round($size / 1KB, 2)
    Write-OK "$weztermConfig ($sizeKB KB)"

    # Offline mode kontrolü
    $weztermContent = Get-Content $weztermConfig -Raw
    if ($weztermContent -match 'check_for_updates\s*=\s*false') {
        Write-Info "Offline mode: Aktif (check_for_updates = false)"
    } elseif ($weztermContent -match 'ONPREM') {
        Write-Info "Offline mode: Aktif (ONPREM config)"
    } else {
        Write-Info "Offline mode: Pasif (auto-update açık olabilir)"
    }
} else {
    Write-Warn "Bulunamadı (opsiyonel)"
    $script:warnings++
}

# ============================================================================
# 6. POWERSHELL PROFIL
# ============================================================================

Write-Title "6. PowerShell Profil (Opsiyonel)"

Write-Check "PowerShell Profile"
$profilePath = $PROFILE
if (Test-Path $profilePath) {
    $size = (Get-Item $profilePath).Length
    $sizeKB = [math]::Round($size / 1KB, 2)
    Write-OK "$profilePath ($sizeKB KB)"

    # Profil test et
    Write-Check "Profil Test"
    try {
        . $profilePath
        Write-OK "Profil başarıyla yüklendi"
        Write-Info "Unix-like komutlar aktif: ls, grep, cat, vb."
    } catch {
        Write-Fail "Profil yüklenirken hata: $($_.Exception.Message)"
        $script:errors++
        $script:allOk = $false
    }
} else {
    Write-Warn "Bulunamadı (opsiyonel)"
    Write-Info "Unix-like komutlar olmayacak"
    $script:warnings++
}

# ============================================================================
# 7. POWERSHELL EXECUTION POLICY
# ============================================================================

Write-Title "7. PowerShell Execution Policy"

Write-Check "Execution Policy"
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "RemoteSigned" -or $policy -eq "Unrestricted") {
    Write-OK "$policy (uygun)"
} else {
    Write-Warn "$policy (RemoteSigned önerilir)"
    Write-Info "Komut: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    $script:warnings++
}

# ============================================================================
# 8. TREESITTER PARSERS
# ============================================================================

Write-Title "8. Treesitter Parsers (Syntax Highlighting)"

Write-Check "Treesitter"
$treesitterDir = Join-Path $nvimData "lazy\nvim-treesitter"
if (Test-Path $treesitterDir) {
    Write-OK "nvim-treesitter yüklü"

    # Parser'ları kontrol et
    $parserDir = Join-Path $treesitterDir "parser"
    if (Test-Path $parserDir) {
        $parsers = Get-ChildItem $parserDir -File -Filter "*.dll" -ErrorAction SilentlyContinue
        if ($parsers.Count -eq 0) {
            $parsers = Get-ChildItem $parserDir -File -Filter "*.so" -ErrorAction SilentlyContinue
        }
        Write-Info "$($parsers.Count) parser mevcut"
    } else {
        Write-Warn "Parser dizini bulunamadı"
        Write-Info "İlk Neovim çalıştırmasında parser'lar derlenecek"
        $script:warnings++
    }
} else {
    Write-Warn "nvim-treesitter bulunamadı"
    $script:warnings++
}

# ============================================================================
# 9. ONPREM ÖZET
# ============================================================================

Write-Title "Kurulum Doğrulama Özeti"

Write-Host "Sonuçlar:" -ForegroundColor Cyan
if ($script:errors -eq 0 -and $script:warnings -eq 0) {
    Write-Host "  Durum    : " -NoNewline -ForegroundColor Gray
    Write-Host "Mükemmel! Tüm kontroller başarılı." -ForegroundColor Green
} elseif ($script:errors -eq 0) {
    Write-Host "  Durum    : " -NoNewline -ForegroundColor Gray
    Write-Host "İyi! Bazı uyarılar var ama kullanılabilir." -ForegroundColor Yellow
    Write-Host "  Uyarılar : $($script:warnings)" -ForegroundColor Yellow
} else {
    Write-Host "  Durum    : " -NoNewline -ForegroundColor Gray
    Write-Host "Sorunlu! Bazı kritik dosyalar eksik." -ForegroundColor Red
    Write-Host "  Hatalar  : $($script:errors)" -ForegroundColor Red
    Write-Host "  Uyarılar : $($script:warnings)" -ForegroundColor Yellow
}

Write-Host ""

if ($script:allOk) {
    Write-Host "Tebrikler! ONPREM kurulumu başarılı." -ForegroundColor Green
    Write-Host ""

    Write-Host "Sonraki Adımlar:" -ForegroundColor Yellow
    Write-Host "1. Yeni terminal penceresi açın (WezTerm önerilir)" -ForegroundColor Gray
    Write-Host "2. Neovim'i başlatın:" -ForegroundColor Gray
    Write-Host "   nvim" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. LazyVim sağlık kontrolü yapın:" -ForegroundColor Gray
    Write-Host "   :checkhealth" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. Plugin'leri kontrol edin:" -ForegroundColor Gray
    Write-Host "   :Lazy" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "5. Mason tool'larını kontrol edin:" -ForegroundColor Gray
    Write-Host "   :Mason" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "Kurulumda sorunlar var. Lütfen yukarıdaki hataları düzeltin." -ForegroundColor Red
    Write-Host ""
    Write-Host "Öneriler:" -ForegroundColor Yellow
    Write-Host "1. INSTALL_ONPREM.ps1'i tekrar çalıştırın" -ForegroundColor Gray
    Write-Host "2. Bundle'ın doğru kopyalandığından emin olun" -ForegroundColor Gray
    Write-Host "3. ONPREM_KURULUM.md dokümantasyonunu okuyun" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "Detaylı log için bu script'i transcript ile çalıştırabilirsiniz:" -ForegroundColor Gray
Write-Host "  Start-Transcript -Path verify-log.txt" -ForegroundColor Cyan
Write-Host "  .\verify-onprem.ps1" -ForegroundColor Cyan
Write-Host "  Stop-Transcript" -ForegroundColor Cyan
Write-Host ""

# Özet istatistikleri
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "Kontrol Sayısı: " -NoNewline -ForegroundColor Gray
Write-Host "20+" -ForegroundColor White
Write-Host "Hatalar       : " -NoNewline -ForegroundColor Gray
Write-Host $script:errors -ForegroundColor $(if ($script:errors -eq 0) { "Green" } else { "Red" })
Write-Host "Uyarılar      : " -NoNewline -ForegroundColor Gray
Write-Host $script:warnings -ForegroundColor $(if ($script:warnings -eq 0) { "Green" } else { "Yellow" })
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""

# Return code
if ($script:allOk) {
    exit 0
} else {
    exit 1
}
