# On-Premise (Offline) Windows Kurulum Rehberi

Bu doküman, internet erişimi kısıtlı veya olmayan kurumsal Windows ortamlarında LazyVim ve Wezterm konfigürasyonlarının nasıl kurulacağını adım adım açıklar.

## İçindekiler

1. [Ön Hazırlık (İnternet Erişimi Olan Bilgisayarda)](#1-ön-hazırlık-i̇nternet-erişimi-olan-bilgisayarda)
2. [Onprem Ortamda Kurulum](#2-onprem-ortamda-kurulum)
3. [Konfigürasyon Kurulumu](#3-konfigürasyon-kurulumu)
4. [Sorun Giderme](#4-sorun-giderme)

---

## 1. Ön Hazırlık (İnternet Erişimi Olan Bilgisayarda)

### 1.1. Gerekli Dosyaları İndirme

Aşağıdaki dosyaları bir USB bellek veya ağ paylaşımına kaydedin:

#### A) Neovim
- **İndirme Linki**: https://github.com/neovim/neovim/releases/latest
- **Dosya Adı**: `nvim-win64.msi` veya `nvim-win64.zip`
- **Dosya Boyutu**: ~30 MB
- **Not**: Stable release'i indirin (örnek: v0.10.0)

#### B) Git for Windows
- **İndirme Linki**: https://git-scm.com/download/win
- **Dosya Adı**: `Git-*-64-bit.exe` (örnek: `Git-2.43.0-64-bit.exe`)
- **Dosya Boyutu**: ~50 MB
- **Kurulum Notu**: "Git from the command line and also from 3rd-party software" seçeneğini işaretleyin

#### C) WezTerm Terminal Emulator
- **İndirme Linki**: https://github.com/wez/wezterm/releases/latest
- **Dosya Adı**: `WezTerm-windows-*-setup.exe` veya `.zip`
- **Dosya Boyutu**: ~50 MB

#### D) PowerShell 7 (Opsiyonel, Önerilir)
- **İndirme Linki**: https://github.com/PowerShell/PowerShell/releases/latest
- **Dosya Adı**: `PowerShell-*-win-x64.msi`
- **Dosya Boyutu**: ~100 MB
- **Not**: Mevcut Windows PowerShell 5.1 de çalışır, ancak PowerShell 7 daha modern

#### E) Nerd Font
- **İndirme Linki**: https://www.nerdfonts.com/font-downloads
- **Önerilen Fontlar**:
  - **CaskaydiaCove Nerd Font** (varsayılan konfigürasyonda kullanılır)
  - JetBrainsMono Nerd Font
  - FiraCode Nerd Font
- **Dosya Adı**: `CascadiaCode.zip` (veya tercih ettiğiniz font)
- **Dosya Boyutu**: ~20-50 MB

#### F) Bu Konfigürasyon Reposu
```bash
# İnternet olan bilgisayarda:
git clone https://github.com/KULLANICI_ADINIZ/lazyvim-config.git
cd lazyvim-config

# Veya GitHub'dan ZIP olarak indirin:
# https://github.com/KULLANICI_ADINIZ/lazyvim-config/archive/refs/heads/master.zip
```

#### G) C/C++ Compiler (Opsiyonel, Bazı Eklentiler İçin Gerekli)

**Seçenek 1: MSYS2 (Önerilir)**
- **İndirme Linki**: https://www.msys2.org/
- **Dosya Adı**: `msys2-x86_64-*.exe`
- **Dosya Boyutu**: ~100 MB
- **Kurulum Sonrası**: MSYS2 terminal'de `pacman -S mingw-w64-x86_64-gcc`

**Seçenek 2: Visual Studio Build Tools**
- **İndirme Linki**: https://visualstudio.microsoft.com/downloads/
- **"Build Tools for Visual Studio 2022"** seçeneğini indirin
- **Dosya Boyutu**: ~3-5 GB (tam kurulum)

### 1.2. USB/Ağ Sürücüsüne Organize Etme

Dosyaları şu şekilde düzenleyin:

```
USB_VEYA_DISK/
├── neovim/
│   └── nvim-win64.msi
├── git/
│   └── Git-2.43.0-64-bit.exe
├── wezterm/
│   └── WezTerm-windows-*-setup.exe
├── powershell/
│   └── PowerShell-7.x.x-win-x64.msi
├── fonts/
│   └── CascadiaCode.zip
├── compiler/ (opsiyonel)
│   └── msys2-x86_64-*.exe
└── lazyvim-config/
    ├── install-windows.ps1
    ├── README.md
    ├── ONPREM_KURULUM.md (bu dosya)
    ├── lua/
    ├── wezterm/
    └── ... (diğer dosyalar)
```

---

## 2. Onprem Ortamda Kurulum

### 2.1. Uygulamaları Kurma

Onprem bilgisayarda, USB/ağ sürücüsünden sırasıyla kurun:

#### A) Git for Windows
```powershell
# Yönetici PowerShell'de:
Start-Process -FilePath "E:\git\Git-2.43.0-64-bit.exe" -Wait

# Veya çift tıklayarak kurulum sihirbazını başlatın
# Önemli: "Git from the command line and also from 3rd-party software" seçeneğini işaretleyin
```

Kurulum sonrası kontrol:
```powershell
git --version
# Git version 2.43.0.windows.1 gibi bir çıktı görmeli
```

#### B) Neovim
```powershell
# Yönetici PowerShell'de:
Start-Process -FilePath "E:\neovim\nvim-win64.msi" -Wait

# Veya çift tıklayarak kurulum sihirbazını başlatın
```

Kurulum sonrası kontrol:
```powershell
nvim --version
# NVIM v0.10.0 gibi bir çıktı görmeli
```

#### C) WezTerm
```powershell
# Yönetici PowerShell'de:
Start-Process -FilePath "E:\wezterm\WezTerm-windows-*-setup.exe" -Wait

# Veya çift tıklayarak kurulum sihirbazını başlatın
```

Kurulum sonrası kontrol:
```powershell
wezterm --version
# wezterm 20231204-061859-fd4c3ce4 gibi bir çıktı görmeli
```

#### D) PowerShell 7 (Opsiyonel)
```powershell
# Yönetici PowerShell'de:
Start-Process -FilePath "E:\powershell\PowerShell-7.x.x-win-x64.msi" -Wait

# Kurulum sonrası kontrol:
pwsh --version
# PowerShell 7.4.0 gibi bir çıktı görmeli
```

#### E) Nerd Font
```powershell
# Font dosyalarını yüklemek için:
# 1. E:\fonts\CascadiaCode.zip dosyasını masaüstüne çıkarın
# 2. Tüm .ttf veya .otf dosyalarını seçin
# 3. Sağ tıklayıp "Tüm kullanıcılar için yükle" seçeneğini seçin

# PowerShell ile otomatik kurulum (Windows 10/11):
$fontSource = "E:\fonts\CascadiaCode.zip"
$fontDest = "$env:TEMP\CascadiaCode"
Expand-Archive -Path $fontSource -DestinationPath $fontDest -Force

$fonts = Get-ChildItem -Path $fontDest -Filter *.ttf
$FONTS = 0x14
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)

foreach ($font in $fonts) {
    $objFolder.CopyHere($font.FullName, 0x10)
    Write-Host "Font kuruldu: $($font.Name)" -ForegroundColor Green
}
```

Font kurulumu sonrası **sistemi yeniden başlatın** (önemli).

#### F) C/C++ Compiler (Opsiyonel)

**MSYS2 ile:**
```powershell
# Yönetici PowerShell'de:
Start-Process -FilePath "E:\compiler\msys2-x86_64-*.exe" -Wait

# Kurulum sonrası, MSYS2 MINGW64 terminal'i açın ve:
pacman -Syu  # Sistem güncelleme (internet gerektirir, onprem'de atlayabilirsiniz)
pacman -S mingw-w64-x86_64-gcc  # Compiler kurulumu
```

### 2.2. Ortam Değişkenlerini Ayarlama (Gerekirse)

Eğer kurulumlar sırasında PATH'e eklenmemişse, manuel olarak ekleyin:

```powershell
# Yönetici PowerShell'de:
# Neovim
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\Neovim\bin', [System.EnvironmentVariableTarget]::Machine)

# Git
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\Git\cmd', [System.EnvironmentVariableTarget]::Machine)

# WezTerm
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\WezTerm', [System.EnvironmentVariableTarget]::Machine)

# PowerShell 7
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\PowerShell\7', [System.EnvironmentVariableTarget]::Machine)

# MSYS2 (eğer kullanıyorsanız)
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\msys64\mingw64\bin', [System.EnvironmentVariableTarget]::Machine)
```

Değişikliklerin yürürlüğe girmesi için yeni bir PowerShell penceresi açın.

---

## 3. Konfigürasyon Kurulumu

### 3.1. Konfigürasyon Dosyalarını Kopyalama

USB/ağ sürücüsünden lazyvim-config klasörünü bilgisayarınıza kopyalayın:

```powershell
# Örnek: USB E: sürücüsünden kopyalama
Copy-Item -Path "E:\lazyvim-config" -Destination "C:\Users\$env:USERNAME\Documents\" -Recurse -Force
```

### 3.2. Otomatik Kurulum Scriptini Çalıştırma

```powershell
# Konfigürasyon dizinine gidin
cd "C:\Users\$env:USERNAME\Documents\lazyvim-config"

# Kurulum scriptini çalıştırın
powershell.exe -ExecutionPolicy Bypass -File .\install-windows.ps1
```

Script şunları yapacak:
1. Mevcut Neovim konfigürasyonunu yedekler (varsa)
2. LazyVim konfigürasyonlarını `%LOCALAPPDATA%\nvim` dizinine kopyalar
3. Wezterm konfigürasyonunu `%USERPROFILE%\.wezterm.lua` konumuna kopyalar
4. PowerShell profil dosyasını kurar (Unix-like komutlar için)
5. Execution Policy'yi kontrol eder

### 3.3. Manuel Kurulum (Alternatif)

Script kullanmak istemiyorsanız, manuel olarak kopyalayın:

```powershell
# 1. LazyVim konfigürasyonları
$nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
New-Item -ItemType Directory -Path $nvimConfig -Force
Copy-Item -Path "C:\Users\$env:USERNAME\Documents\lazyvim-config\*" -Destination $nvimConfig -Recurse -Force -Exclude @('.git', 'wezterm', 'install-windows.ps1')

# 2. Wezterm konfigürasyonu
Copy-Item -Path "C:\Users\$env:USERNAME\Documents\lazyvim-config\wezterm\wezterm.lua" -Destination "$env:USERPROFILE\.wezterm.lua" -Force

# 3. PowerShell profili
$profileDir = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Path $profileDir -Force
Copy-Item -Path "C:\Users\$env:USERNAME\Documents\lazyvim-config\wezterm\powershell\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
```

### 3.4. PowerShell Execution Policy Ayarlama

PowerShell profilinin çalışabilmesi için:

```powershell
# Mevcut policy'yi kontrol edin
Get-ExecutionPolicy

# Eğer "Restricted" ise, değiştirin (Yönetici PowerShell gerekmez):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 4. İlk Kullanım ve Doğrulama

### 4.1. Neovim İlk Açılış

```powershell
# Neovim'i başlatın
nvim
```

**İlk açılışta olacaklar:**
1. LazyVim otomatik olarak `lazy.nvim` plugin manager'ı kuracak
2. Ardından tüm eklentileri indirmeye çalışacak
3. **ÖNEMLİ**: Onprem ortamda internet yoksa bazı eklentiler kurulamayabilir
4. Neovim yine de çalışacak, ancak bazı özellikler eksik olabilir

**Offline ortamda eklenti kurulumu için:**
- Önceden başka bir bilgisayarda `%LOCALAPPDATA%\nvim-data` klasörünü yedekleyin
- Bu klasörü onprem bilgisayara kopyalayın
- Veya sadece temel eklentilerle çalışın (çoğu zaten konfigürasyonda mevcut)

### 4.2. Wezterm İlk Açılış

```powershell
# Wezterm'i başlatın
wezterm
```

**Kontrol listesi:**
- Font düzgün görünüyor mu? (iconlar göründüğünden emin olun)
- Klavye kısayolları çalışıyor mu? (`CTRL+T` yeni tab açmalı)
- PowerShell profili yüklendi mi? (başlangıçta mesaj görmeli)

**Test komutları:**
```powershell
# Unix-like komutları test edin
ls          # Dosya listele
ll          # Detaylı liste
which git   # Git'in konumunu bul
show-aliases  # Tüm alias'ları göster
```

### 4.3. LSP ve Araçları Kurma (Onprem İçin Özel)

Neovim içinde `:Mason` komutuyla LSP ve araçları yönetebilirsiniz. Ancak onprem ortamda internet erişimi olmadığı için:

**Çözüm 1: Önceden Hazırlanmış Paket**
İnternet olan bilgisayarda:
```powershell
# Mason cache'ini kopyalayın
cd %LOCALAPPDATA%\nvim-data
# mason/ klasörünü USB'ye kopyalayın

# Onprem bilgisayarda:
# USB'den %LOCALAPPDATA%\nvim-data\mason\ dizinine yapıştırın
```

**Çözüm 2: Minimal Konfigürasyon**
- `lua/plugins/` altındaki bazı eklentileri devre dışı bırakın
- Sadece temel editing özellikleriyle çalışın
- LSP'siz de Neovim kullanılabilir

---

## 5. Onprem İçin Özel Ayarlar

### 5.1. WezTerm Otomatik Güncelleme Kontrolünü Kapatma

`.wezterm.lua` dosyasını düzenleyin:

```lua
-- Satır ~298'de değiştirin:
config.check_for_updates = false  -- true'dan false'a değiştirin
```

### 5.2. LazyVim Otomatik Güncelleme Kontrolünü Kapatma

`lua/config/lazy.lua` dosyasını düzenleyin:

```lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = false },  -- Otomatik güncelleme kontrolünü kapat
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

---

## 6. Sorun Giderme

### 6.1. Neovim Eklentileri Yüklenmiyor

**Sorun:** `:Lazy` komutuyla eklentiler yüklenemiyor, hata veriyor.

**Çözüm:**
```powershell
# Cache'i temizleyin
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim-data\lazy"

# Neovim'i yeniden başlatın
nvim
```

Eğer hala internet gerekiyorsa:
- Başka bir bilgisayarda eklentileri yükleyin
- `%LOCALAPPDATA%\nvim-data\lazy` klasörünü kopyalayın
- Onprem bilgisayara yapıştırın

### 6.2. PowerShell Profili Çalışmıyor

**Sorun:** Unix-like komutlar (`ls`, `grep`, vb.) çalışmıyor.

**Çözüm:**
```powershell
# Profil dosyasının konumunu kontrol edin
echo $PROFILE

# Dosya var mı?
Test-Path $PROFILE

# Execution Policy'yi kontrol edin
Get-ExecutionPolicy

# Profili manuel yükleyin
. $PROFILE
```

### 6.3. WezTerm Font Bozuk Görünüyor

**Sorun:** Iconlar ve özel karakterler düzgün görünmüyor.

**Çözüm:**
1. Nerd Font'un doğru kurulduğundan emin olun
2. Sistemi yeniden başlatın (font yüklemesi sonrası gerekli)
3. `.wezterm.lua` dosyasında font adını kontrol edin:
   ```lua
   config.font = wezterm.font('CaskaydiaCove Nerd Font')
   ```
4. Yüklü fontları listeleyin:
   ```powershell
   wezterm ls-fonts --list-system
   ```

### 6.4. Git Çalışmıyor

**Sorun:** `git` komutu tanınmıyor.

**Çözüm:**
```powershell
# Git'in PATH'de olup olmadığını kontrol edin
$env:PATH -split ';' | Select-String -Pattern 'Git'

# Manuel olarak PATH'e ekleyin (Yönetici PowerShell):
[System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\Git\cmd', [System.EnvironmentVariableTarget]::Machine)

# Yeni PowerShell penceresi açın ve kontrol edin
git --version
```

### 6.5. Java/Spring Boot LSP Çalışmıyor

**Sorun:** Java dosyaları açıldığında LSP başlamıyor.

**Çözüm:**
1. **JDK kurulumu kontrol edin:**
   ```powershell
   java -version
   echo $env:JAVA_HOME
   ```

2. **JAVA_HOME ayarlayın (yoksa):**
   ```powershell
   # Yönetici PowerShell'de:
   [System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Java\jdk-17', [System.EnvironmentVariableTarget]::Machine)
   ```

3. **Mason ile jdtls kurulumu:**
   - İnternet olan bilgisayarda `:MasonInstall jdtls`
   - `%LOCALAPPDATA%\nvim-data\mason\packages\jdtls` klasörünü kopyalayın
   - Onprem bilgisayara yapıştırın

Daha fazla bilgi için `JAVA_FIX_INSTRUCTIONS.md` ve `JAVA_SPRING_BOOT_SETUP.md` dosyalarına bakın.

---

## 7. Yedekleme ve Taşınabilirlik

### 7.1. Tüm Konfigürasyonu Yedekleme

```powershell
# Backup scripti
$backupDate = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = "C:\Backup\LazyVim-Wezterm-$backupDate"

# Konfigürasyon dosyaları
New-Item -ItemType Directory -Path $backupPath -Force
Copy-Item "$env:LOCALAPPDATA\nvim" -Destination "$backupPath\nvim" -Recurse
Copy-Item "$env:LOCALAPPDATA\nvim-data" -Destination "$backupPath\nvim-data" -Recurse
Copy-Item "$env:USERPROFILE\.wezterm.lua" -Destination "$backupPath\.wezterm.lua"
Copy-Item $PROFILE -Destination "$backupPath\Microsoft.PowerShell_profile.ps1"

Write-Host "Yedekleme tamamlandı: $backupPath" -ForegroundColor Green
```

### 7.2. Başka Bir Bilgisayara Taşıma

Yukarıdaki backup klasörünü USB ile alıp, başka bilgisayarda:

```powershell
# Restore scripti
$backupPath = "E:\LazyVim-Wezterm-20250119-095000"

Copy-Item "$backupPath\nvim" -Destination "$env:LOCALAPPDATA\" -Recurse -Force
Copy-Item "$backupPath\nvim-data" -Destination "$env:LOCALAPPDATA\" -Recurse -Force
Copy-Item "$backupPath\.wezterm.lua" -Destination "$env:USERPROFILE\" -Force

$profileDir = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Path $profileDir -Force
Copy-Item "$backupPath\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force

Write-Host "Geri yükleme tamamlandı!" -ForegroundColor Green
```

---

## 8. Ek Kaynaklar ve Notlar

### 8.1. Offline Ortamda Eksik Olabilecek Özellikler

- **LSP sunucuları** (jdtls, lua-language-server, vb.) - önceden kurulmalı
- **Treesitter parsers** - `:TSInstall` ile kurulur, internet gerektirir
- **Mason tools** - `:Mason` ile kurulur, internet gerektirir
- **Plugin güncellemeleri** - `:Lazy update` internet gerektirir

### 8.2. Minimal Çalışma Modu

Eğer hiçbir ek araç kurulamazsa, yine de şunlar çalışır:
- Vim editing (temel özellikleri)
- Syntax highlighting (built-in)
- File navigation
- Wezterm split/tab özellikleri
- PowerShell Unix-like komutları

### 8.3. Güncelleme Stratejisi (Onprem)

1. **Ayda bir kez** internet olan bilgisayarda:
   ```powershell
   cd %LOCALAPPDATA%\nvim
   git pull
   nvim  # :Lazy update çalıştırın
   ```

2. **Güncellenmiş dosyaları USB'ye kopyalayın**

3. **Onprem bilgisayarda restore edin**

---

## 9. Hızlı Referans Komutları

### Neovim
```vim
:checkhealth           " Sağlık kontrolü
:Lazy                  " Plugin yöneticisi
:Mason                 " LSP/tool yöneticisi
:LspInfo               " LSP durumu
:TSUpdate              " Treesitter güncelle
```

### PowerShell (Unix-like)
```powershell
show-aliases           # Tüm alias'ları göster
ll                     # Detaylı liste
which <komut>          # Komut konumu
gs                     # git status
ga .                   # git add .
gc "mesaj"             # git commit
```

### Wezterm Klavye Kısayolları
```
CTRL+T                 Yeni tab
CTRL+W                 Tab/Pane kapat
CTRL+D                 Dikey split
CTRL+SHIFT+D           Yatay split
CTRL+H/J/K/L           Split'ler arası gezin
CTRL+P                 Komut paleti
```

---

## Destek ve İletişim

Bu konfigürasyon dosyaları açık kaynak olup, kişisel kullanım içindir. Sorularınız için:

- GitHub Issues: https://github.com/KULLANICI_ADINIZ/lazyvim-config/issues
- README.md dosyasına bakın
- WezTerm Doküman: https://wezfurlong.org/wezterm/
- LazyVim Doküman: https://lazyvim.github.io/

---

## 10. Otomatik ONPREM Kurulum Script'leri

**YENİ!** ONPREM kurulumu tamamen otomatikleştiren script'ler eklendi.

### 10.1. INSTALL_ONPREM.ps1 - Ana Kurulum Script'i

**Amaç**: Tüm ONPREM kurulum sürecini otomatikleştirir

**Kullanım**:
```powershell
# Varsayılan kurulum (önerilir)
.\INSTALL_ONPREM.ps1

# Sadece config kurulumu (installer'lar zaten yüklüyse)
.\INSTALL_ONPREM.ps1 -SkipInstallers

# Bundle olmadan kurulum
.\INSTALL_ONPREM.ps1 -SkipBundle

# Online config kullan (auto-update açık)
.\INSTALL_ONPREM.ps1 -UseOfflineConfigs:$false
```

**Özellikler**:
- ✅ Sistem gereksinimlerini kontrol eder
- ✅ Eksik installer'ları otomatik yükler
- ✅ Plugin bundle'ını kopyalar
- ✅ Config dosyalarını kurar
- ✅ Offline config seçeneği
- ✅ Kurulum doğrulaması yapar

### 10.2. prepare-bundle.ps1 - Bundle Hazırlayıcı

**Amaç**: İnternet bağlantılı makinede plugin ve tool bundle'ı oluşturur

**Kullanım**:
```powershell
# İNTERNET BAĞLANTILI MAKİNEDE ÇALIŞTIRIN!

# Varsayılan bundle oluşturma
.\prepare-bundle.ps1

# Temiz kurulum + bundle
.\prepare-bundle.ps1 -CleanInstall

# Özel output dizini
.\prepare-bundle.ps1 -OutputDir "D:\my-bundle"
```

**Ne Yapar**:
1. LazyVim config'ini kurar
2. Tüm plugin'leri indirir (40+ plugin)
3. Mason tool'larını indirir (20+ tool)
4. nvim-data'yı bundle klasörüne kopyalar
5. ONPREM paket yapısı oluşturur (opsiyonel)

**Çıktı**: `bundle/` klasörü (~1-2 GB)

### 10.3. verify-onprem.ps1 - Kurulum Doğrulama

**Amaç**: ONPREM kurulumunu detaylıca doğrular

**Kullanım**:
```powershell
.\verify-onprem.ps1
```

**Kontrol Edilen**:
- ✅ Sistem gereksinimleri (Neovim, Git, WezTerm)
- ✅ LazyVim config dosyaları
- ✅ Plugin bundle (40+ plugin)
- ✅ Mason tools (20+ tool)
- ✅ WezTerm config
- ✅ PowerShell profil (opsiyonel)
- ✅ Execution Policy
- ✅ Treesitter parsers
- ✅ Offline mode ayarları

**Çıktı Örneği**:
```
========================================
ONPREM Kurulum Doğrulama
========================================

1. Sistem Gereksinimleri
[Neovim] OK  v0.10.0 yüklü
[Git] OK  v2.43.0 yüklü
[WezTerm] OK  Yüklü

2. LazyVim Konfigürasyon Dosyaları
[init.lua] OK  C:\Users\...\nvim\init.lua
[lazy.lua] OK  C:\Users\...\nvim\lua\config\lazy.lua
     Offline mode: Aktif (checker.enabled = false)
...

Sonuçlar:
  Durum: Mükemmel! Tüm kontroller başarılı.
```

### 10.4. Offline Config Dosyaları

**Yeni Dosyalar**:
- `lua/config/lazy-offline.lua` - Offline-optimized lazy.nvim config
- `wezterm/wezterm-offline.lua` - Offline-optimized WezTerm config

**Farklar (Offline vs Online)**:

| Özellik | Online Config | Offline Config |
|---------|---------------|----------------|
| Auto-update | Aktif | Kapalı |
| Plugin check | Günlük | Kapalı |
| Git clone | Otomatik | Bundle'dan |
| WezTerm update | Günlük | Kapalı |

**Manuel Kullanım**:
```powershell
# Lazy.nvim offline config
Copy-Item lua\config\lazy-offline.lua -Destination $env:LOCALAPPDATA\nvim\lua\config\lazy.lua

# WezTerm offline config
Copy-Item wezterm\wezterm-offline.lua -Destination $env:USERPROFILE\.wezterm.lua
```

### 10.5. ONPREM Paket Yapısı

**Yeni Önerilen Yapı**:
```
lazyvim-onprem-package/              [2-4 GB]
│
├── INSTALL_ONPREM.ps1               # ← ANA SCRIPT (BUNU ÇALIŞTIR!)
├── README-ONPREM.md                 # Hızlı başlangıç kılavuzu
│
├── 1-installers/                    # Tüm installer'lar
│   ├── neovim/
│   ├── git/
│   ├── wezterm/
│   ├── fonts/
│   ├── powershell/
│   ├── compiler/
│   └── jdk/
│
├── 2-config/                        # Bu repo
│   ├── init.lua
│   ├── lua/
│   ├── wezterm/
│   ├── ONPREM_KURULUM.md
│   └── *.ps1 (script'ler)
│
└── 3-bundle/                        # Önceden indirilmiş plugin'ler
    ├── lazy/                        # 40+ plugin
    └── mason/                       # 20+ Mason tool
```

### 10.6. Yeni Dokümantasyon

| Dosya | Açıklama |
|-------|----------|
| **README-ONPREM.md** | Hızlı başlangıç kılavuzu |
| **INSTALLATION_CHECKLIST.md** | Adım adım kurulum kontrol listesi |
| **BUNDLE_PREPARATION.md** | Bundle nasıl hazırlanır |
| **PACKAGE_STRUCTURE.md** | Paket yapısı detayları |
| **DOWNLOAD_LINKS.md** | Güncel indirme linkleri |

### 10.7. Kurulum Akışı (Yeni Yöntem)

**İnternet Bağlantılı Makinede**:
```powershell
# 1. Bundle hazırla
.\prepare-bundle.ps1

# 2. Installer'ları indir (DOWNLOAD_LINKS.md'ye bakın)

# 3. ONPREM paket yapısını oluştur
# prepare-bundle.ps1 script'i bittiğinde soracak:
# "ONPREM paketi oluştur? (Y/N):"
# Y'ye basın, otomatik oluşturulur
```

**ONPREM Makinede**:
```powershell
# 1. Paketi USB/Network drive'dan kopyala

# 2. Ana script'i çalıştır
cd lazyvim-onprem-package
.\INSTALL_ONPREM.ps1

# 3. Kurulum tamamlanacak (5-10 dakika)

# 4. Doğrulama
.\2-config\verify-onprem.ps1

# 5. Neovim'i başlat
nvim
```

### 10.8. Eski vs Yeni Yöntem

**Eski Yöntem** (Manuel):
1. ❌ Her dosyayı manuel indirme
2. ❌ Manuel kopyalama (%LOCALAPPDATA%)
3. ❌ Manuel config düzenleme
4. ❌ Manuel doğrulama
5. ⏱️ Süre: 30-60 dakika

**Yeni Yöntem** (Otomatik):
1. ✅ prepare-bundle.ps1 çalıştır
2. ✅ INSTALL_ONPREM.ps1 çalıştır
3. ✅ Otomatik kurulum
4. ✅ Otomatik doğrulama
5. ⏱️ Süre: 10-15 dakika

### 10.9. Sorun Giderme (Script'ler)

**Sorun**: prepare-bundle.ps1 hatası

**Çözüm**:
```powershell
# İnternet kontrolü
Test-Connection github.com

# Neovim versiyonu
nvim --version  # Minimum: 0.9.0

# Git kontrolü
git --version
```

**Sorun**: INSTALL_ONPREM.ps1 "Access Denied"

**Çözüm**:
```powershell
# PowerShell'i yönetici olarak çalıştır
# Sağ tık → "Run as Administrator"
```

**Sorun**: verify-onprem.ps1 hataları gösteriyor

**Çözüm**:
```powershell
# Hangi hatalar var kontrol et
.\verify-onprem.ps1 | Out-File -FilePath verify-log.txt

# Log'u incele
notepad verify-log.txt

# INSTALL_ONPREM.ps1'i tekrar çalıştır
.\INSTALL_ONPREM.ps1
```

### 10.10. Script Parametreleri Özeti

**INSTALL_ONPREM.ps1**:
```powershell
-SkipInstallers      # Installer'ları atla
-UseOfflineConfigs   # Offline config kullan (varsayılan: $true)
-SkipBundle          # Bundle kopyalamayı atla
```

**prepare-bundle.ps1**:
```powershell
-OutputDir <path>    # Bundle çıktı dizini
-CleanInstall        # Temiz kurulum (mevcut nvim'i sil)
```

**verify-onprem.ps1**:
```powershell
# Parametre yok, direkt çalıştır
```

### 10.11. Offline Mode Özellikleri

**Offline Config ile**:
- 🚫 Auto-update kapalı (LazyVim, WezTerm)
- 🚫 Plugin update check kapalı
- ✅ Bundle'dan plugin kullanımı
- ✅ Tamamen offline çalışır
- ✅ ONPREM uyarı mesajları

**Online Config ile**:
- ✅ Auto-update açık
- ✅ Plugin update check açık
- ⚠️ İnternet gerekebilir

**Öneri**: ONPREM ortamlar için **Offline Config** kullanın.

---

## 11. Ek Notlar

### 11.1. Script'ler Hakkında

- ✅ Tüm script'ler PowerShell 5.1+ ile uyumlu
- ✅ Windows 10/11 için optimize edilmiş
- ✅ İmzasız script'ler (RemoteSigned policy gerekli)
- ✅ Açık kaynak (MIT Lisansı)

### 11.2. Bundle Boyutu

| İçerik | Boyut |
|--------|-------|
| Plugin'ler (lazy/) | 800 MB - 1.2 GB |
| Mason tools (mason/) | 200 MB - 500 MB |
| **Toplam Bundle** | **1-2 GB** |

### 11.3. Güncelleme Stratejisi (Otomatik)

```powershell
# Ayda bir internet bağlantılı makinede:
.\prepare-bundle.ps1 -CleanInstall

# Yeni bundle'ı ONPREM pakete ekle
# ONPREM makinede INSTALL_ONPREM.ps1'i tekrar çalıştır
```

---

**Son Güncelleme:** 2025-01-19
**Sürüm:** 2.0 (Otomatik ONPREM Script'leri Eklendi)
**Uyumluluk:** Windows 10/11, PowerShell 5.1/7+

**Yeni Özellikler**:
- ✅ Otomatik kurulum script'i (INSTALL_ONPREM.ps1)
- ✅ Bundle hazırlayıcı (prepare-bundle.ps1)
- ✅ Gelişmiş doğrulama (verify-onprem.ps1)
- ✅ Offline config dosyaları
- ✅ 5 yeni dokümantasyon dosyası
