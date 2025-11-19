# ==============================================================================
# PowerShell Profil - Unix-like Komutlar ve Özelleştirmeler
# ==============================================================================
# Bu dosya WezTerm ile birlikte çalışmak üzere tasarlanmıştır
# Unix/Linux/macOS'tan gelen geliştiriciler için tanıdık komutlar sağlar
#
# Kurulum:
# 1. Bu dosyayı şu konuma kopyalayın:
#    %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#    veya
#    %USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#
# 2. Execution Policy ayarlayın (PowerShell'i yönetici olarak çalıştırın):
#    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# ==============================================================================

# ------------------------------------------------------------------------------
# 🎨 PSReadLine Konfigürasyonu (Otomatik Tamamlama ve Syntax Highlighting)
# ------------------------------------------------------------------------------

# PSReadLine modülünü import et (genellikle varsayılan olarak yüklüdür)
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

    # Prediction (Tahmin) ayarları - Fish shell benzeri otomatik tamamlama
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView

    # Syntax highlighting - komutlar, parametreler, hatalar için renklendirme
    Set-PSReadLineOption -Colors @{
        Command            = 'Green'
        Parameter          = 'Gray'
        Operator           = 'Magenta'
        Variable           = 'White'
        String             = 'Yellow'
        Number             = 'Blue'
        Type               = 'Cyan'
        Comment            = 'DarkGray'
    }

    # Geçmiş arama - Ctrl+R ile ters arama (bash gibi)
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -Function ReverseSearchHistory

    # Tab completion ayarları
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineOption -ShowToolTips
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
}

# ------------------------------------------------------------------------------
# 🌈 Prompt Özelleştirmesi (Basit ve Temiz)
# ------------------------------------------------------------------------------

function prompt {
    $currentPath = $PWD.Path.Replace($HOME, "~")
    $promptSymbol = if ($?) { "➜" } else { "✗" }
    $promptColor = if ($?) { "Green" } else { "Red" }

    Write-Host $currentPath -NoNewline -ForegroundColor Cyan
    Write-Host " $promptSymbol " -NoNewline -ForegroundColor $promptColor
    return " "
}

# ------------------------------------------------------------------------------
# 📁 Unix-like Dizin ve Dosya Komutları
# ------------------------------------------------------------------------------

# ls - Colorize ve detaylı listeleme
function ll { Get-ChildItem -Force | Format-Table -AutoSize }
function la { Get-ChildItem -Force -Hidden | Format-Table -AutoSize }
function ls { Get-ChildItem | Format-Table -AutoSize }

# pwd - Mevcut dizini göster (zaten var ama alias ekleyelim)
Set-Alias -Name pwd -Value Get-Location -Option AllScope

# cd shortcuts
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

# mkdir - Otomatik parent dizinler oluştur
function mkdir { param($path) New-Item -ItemType Directory -Path $path -Force }

# touch - Dosya oluştur veya timestamp güncelle
function touch {
    param($file)
    if (Test-Path $file) {
        (Get-Item $file).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

# rm - Remove işlemi
Set-Alias -Name rm -Value Remove-Item -Option AllScope

# cp - Copy işlemi
Set-Alias -Name cp -Value Copy-Item -Option AllScope

# mv - Move işlemi
Set-Alias -Name mv -Value Move-Item -Option AllScope

# ------------------------------------------------------------------------------
# 🔍 Arama ve Filtreleme Komutları
# ------------------------------------------------------------------------------

# grep - Metin arama (Select-String)
function grep {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Pattern,
        [Parameter(ValueFromPipeline=$true)]
        [string]$InputObject
    )

    if ($InputObject) {
        $InputObject | Select-String -Pattern $Pattern
    } else {
        Get-ChildItem -Recurse | Select-String -Pattern $Pattern
    }
}

# find - Dosya arama
function find {
    param(
        [string]$name,
        [string]$path = "."
    )
    Get-ChildItem -Path $path -Recurse -Filter $name -ErrorAction SilentlyContinue
}

# which - Komutun yolunu bul
function which {
    param($command)
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# ------------------------------------------------------------------------------
# 📄 Dosya İçeriği Gösterme
# ------------------------------------------------------------------------------

# cat - Dosya içeriğini göster
function cat {
    param($file)
    Get-Content $file
}

# head - Dosyanın ilk satırlarını göster
function head {
    param(
        [Parameter(Mandatory=$true)]
        [string]$file,
        [int]$n = 10
    )
    Get-Content $file -TotalCount $n
}

# tail - Dosyanın son satırlarını göster
function tail {
    param(
        [Parameter(Mandatory=$true)]
        [string]$file,
        [int]$n = 10
    )
    Get-Content $file -Tail $n
}

# ------------------------------------------------------------------------------
# 🔧 Sistem ve Process Komutları
# ------------------------------------------------------------------------------

# ps - Process listesi (Unix benzeri)
function ps { Get-Process }

# kill - Process sonlandır
function pkill {
    param($name)
    Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force
}

# df - Disk kullanımı
function df {
    Get-PSDrive -PSProvider FileSystem |
        Select-Object Name,
                      @{Name="Used(GB)";Expression={[math]::Round($_.Used/1GB,2)}},
                      @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}},
                      @{Name="Total(GB)";Expression={[math]::Round(($_.Used+$_.Free)/1GB,2)}}
}

# env - Ortam değişkenlerini göster
function env { Get-ChildItem Env: }

# export - Ortam değişkeni ayarla (geçici, sadece bu oturum için)
function export {
    param(
        [Parameter(Mandatory=$true)]
        [string]$var
    )

    if ($var -match '^([^=]+)=(.*)$') {
        $name = $matches[1]
        $value = $matches[2]
        Set-Item -Path "Env:$name" -Value $value
        Write-Host "Exported: $name=$value" -ForegroundColor Green
    } else {
        Write-Host "Usage: export VAR=value" -ForegroundColor Red
    }
}

# clear - Terminal ekranını temizle (zaten var ama alias ekleyelim)
Set-Alias -Name clear -Value Clear-Host -Option AllScope

# ------------------------------------------------------------------------------
# 🔗 Git Kısayolları (Hızlı Git Kullanımı)
# ------------------------------------------------------------------------------

function gs { git status }
function ga { git add $args }
function gc { git commit -m $args }
function gp { git push }
function gl { git pull }
function glog { git log --oneline --graph --decorate --all }
function gd { git diff }
function gco { git checkout $args }
function gb { git branch }

# ------------------------------------------------------------------------------
# 🌐 Ağ ve İnternet Komutları
# ------------------------------------------------------------------------------

# curl - Web request (Invoke-WebRequest alias)
Set-Alias -Name curl -Value Invoke-WebRequest -Option AllScope

# wget - Dosya indir
function wget {
    param($url, $output)
    if ($output) {
        Invoke-WebRequest -Uri $url -OutFile $output
    } else {
        Invoke-WebRequest -Uri $url
    }
}

# ping - Bağlantı testi (zaten var ama alias ekleyelim)
Set-Alias -Name ping -Value Test-Connection -Option AllScope

# ------------------------------------------------------------------------------
# 📦 Hızlı Navigasyon Kısayolları
# ------------------------------------------------------------------------------

# Sık kullanılan dizinler için kısayollar
function cddev { Set-Location ~/Development }
function cddocs { Set-Location ~/Documents }
function cddown { Set-Location ~/Downloads }
function cddesk { Set-Location ~/Desktop }

# ------------------------------------------------------------------------------
# 🎯 Faydalı Utility Fonksiyonlar
# ------------------------------------------------------------------------------

# Dosya/dizin sayısını say
function count {
    param($path = ".")
    (Get-ChildItem -Path $path | Measure-Object).Count
}

# Dizin boyutunu hesapla
function dirsize {
    param($path = ".")
    $size = (Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum

    if ($size -gt 1GB) {
        "{0:N2} GB" -f ($size / 1GB)
    } elseif ($size -gt 1MB) {
        "{0:N2} MB" -f ($size / 1MB)
    } elseif ($size -gt 1KB) {
        "{0:N2} KB" -f ($size / 1KB)
    } else {
        "{0:N2} bytes" -f $size
    }
}

# System bilgisi (uname benzeri)
function sysinfo {
    Write-Host "Sistem Bilgileri:" -ForegroundColor Cyan
    Write-Host "OS: $([System.Environment]::OSVersion.VersionString)"
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
    Write-Host "Hostname: $env:COMPUTERNAME"
    Write-Host "User: $env:USERNAME"
    Write-Host "Home: $HOME"
}

# Reload profile - Profili yeniden yükle
function reload {
    . $PROFILE
    Write-Host "PowerShell profili yeniden yüklendi!" -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 📚 Yardım ve Alias Listesi
# ------------------------------------------------------------------------------

function show-aliases {
    Write-Host "`n🎯 Unix-like Komutlar:" -ForegroundColor Cyan
    Write-Host "  ls, ll, la          - Dosya listele"
    Write-Host "  cd, .., ..., ....   - Dizin değiştir"
    Write-Host "  pwd                 - Mevcut dizin"
    Write-Host "  mkdir, touch        - Dosya/dizin oluştur"
    Write-Host "  rm, cp, mv          - Dosya işlemleri"
    Write-Host "  cat, head, tail     - Dosya içeriği"
    Write-Host "  grep, find, which   - Arama"
    Write-Host "  ps, kill, df        - Sistem"
    Write-Host "  env, export         - Ortam değişkenleri"
    Write-Host "`n🔗 Git Kısayolları:" -ForegroundColor Cyan
    Write-Host "  gs, ga, gc, gp, gl  - Git komutları"
    Write-Host "  glog, gd, gco, gb   - Git yardımcıları"
    Write-Host "`n🎨 Yardımcı Komutlar:" -ForegroundColor Cyan
    Write-Host "  reload              - Profili yeniden yükle"
    Write-Host "  sysinfo             - Sistem bilgileri"
    Write-Host "  dirsize             - Dizin boyutu"
    Write-Host "  count               - Dosya sayısı"
    Write-Host "`nDaha fazla bilgi: Get-Help <komut>`n"
}

# ------------------------------------------------------------------------------
# 🚀 Başlangıç Mesajı
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "🚀 PowerShell Unix-like Profil Yüklendi!" -ForegroundColor Green
Write-Host "   Komut listesi için: " -NoNewline
Write-Host "show-aliases" -ForegroundColor Yellow
Write-Host ""

# ==============================================================================
# NOTLAR
# ==============================================================================
#
# 1. PSReadLine modülü yoksa yükleyin:
#    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
#
# 2. Posh-Git (Git entegrasyonu) için:
#    Install-Module -Name posh-git -Force
#    Import-Module posh-git
#
# 3. Oh-My-Posh (Tema desteği) için:
#    Install-Module -Name oh-my-posh -Force
#
# 4. Onprem ortamlar için:
#    - Tüm komutlar offline çalışır
#    - PSReadLine modülü yoksa bazı özellikler devre dışı kalır
#    - Internet gerektiren sadece: curl, wget komutları
#
# ==============================================================================
