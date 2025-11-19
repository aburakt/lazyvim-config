# ONPREM İndirme Linkleri

Bu doküman, ONPREM kurulum paketi için gerekli tüm installer'ların indirme linklerini içerir.

**ÖNEMLİ**: Bu installer'lar **İNTERNET BAĞLANTISI OLAN** bir makinede indirilmelidir!

## 📥 Zorunlu İndirmeler

### 1. Neovim (✅ ZORUNLU)

**Açıklama**: Modern Vim-based metin editörü, LazyVim'in temel bileşeni

**Minimum Versiyon**: 0.9.0
**Önerilen Versiyon**: 0.10.0+

**İndirme Linki**:
- **Windows (MSI)**: https://github.com/neovim/neovim/releases/latest
  - Dosya: `nvim-win64.msi` (~30 MB)

**Alternatif İndirme**:
- Scoop: `scoop install neovim`
- Chocolatey: `choco install neovim`
- WinGet: `winget install Neovim.Neovim`

**Doğrulama**:
```powershell
# Versiyon kontrol
nvim --version
# Beklenen: NVIM v0.10.0 veya üzeri
```

---

### 2. Git for Windows (✅ ZORUNLU)

**Açıklama**: Versiyon kontrol sistemi, plugin'leri clone'lamak için gerekli

**Minimum Versiyon**: 2.0
**Önerilen Versiyon**: 2.43.0+

**İndirme Linki**:
- **Windows (EXE)**: https://git-scm.com/download/win
  - Dosya: `Git-2.43.0-64-bit.exe` (~50 MB)
  - "64-bit Git for Windows Setup" seçeneğini indirin

**Alternatif İndirme**:
- GitHub direkt: https://github.com/git-for-windows/git/releases/latest
- Scoop: `scoop install git`
- Chocolatey: `choco install git`
- WinGet: `winget install Git.Git`

**Kurulum Önerileri**:
- ✅ "Git from the command line and also from 3rd-party software"
- ✅ "Use Windows' default console window"
- ✅ "Checkout as-is, commit as-is" (ONPREM için)

**Doğrulama**:
```powershell
git --version
# Beklenen: git version 2.43.0 veya üzeri
```

---

### 3. WezTerm (✅ ZORUNLU)

**Açıklama**: Modern, GPU-accelerated terminal emulator

**Minimum Versiyon**: 20230000+
**Önerilen Versiyon**: Latest stable

**İndirme Linki**:
- **Windows (EXE)**: https://github.com/wez/wezterm/releases/latest
  - Dosya: `WezTerm-windows-*-setup.exe` (~50 MB)
  - Windows 10/11 için "WezTerm-windows-*-setup.exe" seçin

**Alternatif İndirme**:
- Scoop: `scoop install wezterm`
- Chocolatey: `choco install wezterm`
- WinGet: `winget install wez.wezterm`

**Doğrulama**:
```powershell
wezterm --version
# Beklenen: wezterm 20240203-110809-xxxx
```

---

### 4. Nerd Font (✅ ZORUNLU)

**Açıklama**: Icon ve sembol desteği olan programlama fontu

**Önerilen Font**: CaskaydiaCove Nerd Font (Cascadia Code + Nerd Font patches)

**İndirme Linki**:
- **Nerd Fonts**: https://www.nerdfonts.com/font-downloads
  - Font: **"CascadiaCode"** (~20 MB)
  - Dosya: `CascadiaCode.zip`

**Direkt Link**:
- GitHub: https://github.com/ryanoasis/nerd-fonts/releases/latest
  - `CascadiaCode.zip` dosyasını indirin

**Alternatif Fontlar** (eğer CascadiaCode yoksa):
- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- Hack Nerd Font

**Kurulum**:
1. ZIP dosyasını çıkart
2. Tüm `.ttf` veya `.otf` dosyalarını seç
3. Sağ tık → "Install" veya "Install for all users"

**Doğrulama**:
```powershell
# Windows Font Settings'te kontrol et
# Fonts → "CaskaydiaCove Nerd Font" görünmeli
```

---

## 📦 Opsiyonel İndirmeler

### 5. PowerShell 7 (⚡ ÖNERİLİR)

**Açıklama**: Modern PowerShell, gelişmiş terminal özellikleri

**Minimum Versiyon**: 7.0
**Önerilen Versiyon**: 7.4.0+

**İndirme Linki**:
- **Windows (MSI)**: https://github.com/PowerShell/PowerShell/releases/latest
  - Dosya: `PowerShell-7.4.1-win-x64.msi` (~100 MB)

**Alternatif İndirme**:
- Microsoft Store: "PowerShell" araması
- WinGet: `winget install Microsoft.PowerShell`
- Chocolatey: `choco install powershell-core`

**Doğrulama**:
```powershell
pwsh --version
# Beklenen: PowerShell 7.4.1 veya üzeri
```

---

### 6. C/C++ Compiler (🔧 MSYS2)

**Açıklama**: Bazı plugin'lerin (özellikle Treesitter parser'ları) derlenmesi için gerekli

**Önerilen**: MSYS2 (MinGW-w64 compiler içerir)

**İndirme Linki**:
- **MSYS2**: https://www.msys2.org/
  - Dosya: `msys2-x86_64-20240113.exe` (~100 MB)

**Alternatif**: Visual Studio Build Tools
- **Build Tools**: https://visualstudio.microsoft.com/downloads/
  - "Build Tools for Visual Studio 2022" (~3-5 GB, daha ağır)
  - "Desktop development with C++" workload seçin

**MSYS2 Kurulum Sonrası**:
```bash
# MSYS2 terminal'de
pacman -S mingw-w64-x86_64-gcc
```

**Doğrulama**:
```powershell
# MSYS2 kuruluysa
gcc --version

# Veya Visual Studio Build Tools
cl
```

**Not**: Compiler olmadan da LazyVim çalışır, ama bazı Treesitter parser'ları pre-compiled binary kullanır.

---

### 7. Java JDK (☕ Java Development için)

**Açıklama**: Java/Spring Boot development için gerekli

**Minimum Versiyon**: JDK 17
**Önerilen Versiyon**: JDK 21 (LTS)

**İndirme Linkleri**:

#### Seçenek 1: Eclipse Temurin (Önerilir - Açık Kaynak)
- **Temurin**: https://adoptium.net/
  - Dosya: `OpenJDK21U-jdk_x64_windows_hotspot_*.msi` (~150-200 MB)
  - "JDK 21 (LTS)" → "Windows" → "x64" → ".msi"

#### Seçenek 2: Oracle JDK
- **Oracle JDK**: https://www.oracle.com/java/technologies/downloads/
  - Dosya: `jdk-21_windows-x64_bin.exe` (~150-180 MB)
  - "Java 21" → "Windows" → "x64 Installer"

#### Seçenek 3: Microsoft Build of OpenJDK
- **Microsoft**: https://learn.microsoft.com/en-us/java/openjdk/download
  - Dosya: `microsoft-jdk-21.*-windows-x64.msi` (~150-200 MB)

**Alternatif İndirme**:
- Scoop: `scoop install openjdk`
- Chocolatey: `choco install openjdk`
- WinGet: `winget install EclipseAdoptium.Temurin.21.JDK`

**Kurulum Önerileri**:
- ✅ "Set JAVA_HOME variable" seçeneğini aktif et
- ✅ "Add to PATH" seçeneğini aktif et

**Doğrulama**:
```powershell
java -version
# Beklenen: openjdk version "21" veya üzeri

echo $env:JAVA_HOME
# Beklenen: C:\Program Files\Eclipse Adoptium\jdk-21.*
```

---

## 📂 İndirme Klasör Yapısı

İndirdiğiniz dosyaları şu yapıda organize edin:

```
lazyvim-onprem-package/
└── 1-installers/
    ├── neovim/
    │   └── nvim-win64.msi
    │
    ├── git/
    │   └── Git-2.43.0-64-bit.exe
    │
    ├── wezterm/
    │   └── WezTerm-windows-20240203-110809-setup.exe
    │
    ├── fonts/
    │   └── CascadiaCode.zip
    │
    ├── powershell/          # Opsiyonel
    │   └── PowerShell-7.4.1-win-x64.msi
    │
    ├── compiler/            # Opsiyonel
    │   └── msys2-x86_64-20240113.exe
    │
    └── jdk/                 # Opsiyonel
        └── OpenJDK21U-jdk_x64_windows_hotspot.msi
```

---

## 🎯 Hızlı İndirme Checklist

Aşağıdaki dosyaları indirin:

### Zorunlu
- [ ] `nvim-win64.msi` (~30 MB) - Neovim
- [ ] `Git-*-64-bit.exe` (~50 MB) - Git
- [ ] `WezTerm-*.exe` (~50 MB) - WezTerm
- [ ] `CascadiaCode.zip` (~20 MB) - Nerd Font

### Opsiyonel (Önerilir)
- [ ] `PowerShell-*-win-x64.msi` (~100 MB) - PowerShell 7

### Opsiyonel (İhtiyaca Göre)
- [ ] `msys2-*.exe` (~100 MB) - Compiler
- [ ] `OpenJDK-*.msi` (~150-200 MB) - Java JDK

**Toplam Boyut**:
- Minimal: ~150 MB (sadece zorunlu)
- Önerilen: ~250 MB (zorunlu + PowerShell)
- Full: ~500-650 MB (tümü)

---

## 🔄 Otomatik İndirme Script'i (Opsiyonel)

İndirmeyi otomatikleştirmek için PowerShell script'i:

```powershell
# download-installers.ps1

$downloads = @{
    "Neovim" = @{
        Url = "https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-win64.msi"
        Output = "1-installers\neovim\nvim-win64.msi"
    }
    "Git" = @{
        Url = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
        Output = "1-installers\git\Git-2.43.0-64-bit.exe"
    }
    # WezTerm ve diğerleri için linkleri ekleyin
}

foreach ($tool in $downloads.Keys) {
    $item = $downloads[$tool]
    Write-Host "İndiriliyor: $tool" -ForegroundColor Yellow

    $dir = Split-Path $item.Output -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    Invoke-WebRequest -Uri $item.Url -OutFile $item.Output -UseBasicParsing
    Write-Host "  Tamamlandı: $($item.Output)" -ForegroundColor Green
}
```

**Kullanım**:
```powershell
.\download-installers.ps1
```

**Not**: Bu script yalnızca sabit linkleri kullanır. Latest release için manuel kontrol edin.

---

## 🔐 Güvenlik Kontrolleri

İndirilen dosyaların güvenliğini doğrulayın:

### SHA256 Hash Kontrolü

```powershell
# Örnek: Neovim MSI hash kontrolü
Get-FileHash -Path "1-installers\neovim\nvim-win64.msi" -Algorithm SHA256

# Hash'i GitHub release sayfasındaki hash ile karşılaştırın
```

### Dijital İmza Kontrolü

```powershell
# Windows dosya özelliklerinden kontrol et
# Sağ tık → Properties → Digital Signatures

# PowerShell ile
Get-AuthenticodeSignature -FilePath "1-installers\git\Git-2.43.0-64-bit.exe"
```

---

## ❓ Sorun Giderme

### Link Çalışmıyor

**Sorun**: GitHub release linki 404 hatası veriyor

**Çözüm**:
1. https://github.com/neovim/neovim/releases adresine git
2. En son "Latest" release'i bul
3. Assets kısmından `nvim-win64.msi` dosyasını indir

### İndirme Yavaş

**Sorun**: İndirme hızı çok düşük

**Çözüm**:
- GitHub'ın CDN'i kullanın (otomatik)
- Proxy veya VPN kullanmayı deneyin
- Daha hızlı internet bağlantısı olan bir ağ kullanın

### Dosya Bulunamadı

**Sorun**: Belirtilen dosya adı mevcut değil

**Çözüm**:
- Versiyon numarası değişmiş olabilir
- Latest release sayfasından güncel dosya adını bulun
- Benzer isme sahip dosyayı indirin (örn: `nvim-win64-v0.10.1.msi`)

---

## 📝 Notlar

- **Versiyonlar Değişebilir**: Bu dokümandaki versiyon numaraları örnek içindir. Her zaman en son stable sürümü indirin.
- **Latest vs Specific**: Production ONPREM için specific versiyon önerilir (reproducibility için).
- **Boyutlar Yaklaşık**: Dosya boyutları versiyona göre değişebilir.
- **İnternet Gerekli**: Tüm bu indirmeler internet bağlantısı gerektirir.
- **Lisanslar**: Tüm yazılımlar açık kaynak veya ücretsiz lisanslıdır.

---

## 🎁 Bonus: Tüm Linklerin Listesi

**Hızlı Erişim**:

| Araç | Link |
|------|------|
| Neovim | https://github.com/neovim/neovim/releases/latest |
| Git | https://git-scm.com/download/win |
| WezTerm | https://github.com/wez/wezterm/releases/latest |
| Nerd Fonts | https://www.nerdfonts.com/font-downloads |
| PowerShell 7 | https://github.com/PowerShell/PowerShell/releases/latest |
| MSYS2 | https://www.msys2.org/ |
| JDK (Temurin) | https://adoptium.net/ |

---

**Tüm dosyaları indirdikten sonra PACKAGE_STRUCTURE.md'ye bakarak paket yapısını oluşturun!**
