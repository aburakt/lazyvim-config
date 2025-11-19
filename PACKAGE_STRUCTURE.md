# ONPREM Paket Yapısı Dokümantasyonu

Bu doküman, LazyVim + WezTerm ONPREM kurulum paketinin detaylı yapısını ve her bir bileşenin amacını açıklar.

## 📦 Tam Paket Yapısı

```
lazyvim-onprem-package/                     # [2-4 GB] Ana paket dizini
│
├── INSTALL_ONPREM.ps1                      # [15 KB] Ana kurulum script'i (BU SCRIPT'İ ÇALIŞTIRIN!)
├── README-ONPREM.md                        # [5 KB] Hızlı başlangıç kılavuzu
│
├── 1-installers/                           # [500 MB - 2 GB] Tüm installer'lar
│   │
│   ├── neovim/                             # [~30 MB] Neovim installer
│   │   └── nvim-win64.msi                  # Neovim 0.10.0+ (önerilir)
│   │
│   ├── git/                                # [~50 MB] Git installer
│   │   └── Git-2.43.0-64-bit.exe           # Git for Windows
│   │
│   ├── wezterm/                            # [~50 MB] WezTerm installer
│   │   └── WezTerm-20240203-110809-windows-setup.exe
│   │
│   ├── fonts/                              # [~20 MB] Nerd Font
│   │   └── CascadiaCode.zip                # CaskaydiaCove Nerd Font
│   │
│   ├── powershell/                         # [~100 MB] PowerShell 7 (opsiyonel)
│   │   └── PowerShell-7.4.1-win-x64.msi
│   │
│   ├── compiler/                           # [~100 MB] MSYS2 (opsiyonel)
│   │   └── msys2-x86_64-20240113.exe       # C/C++ compiler (bazı plugin'ler için)
│   │
│   └── jdk/                                # [~150-300 MB] Java JDK (opsiyonel)
│       └── jdk-17_windows-x64_bin.msi      # Java development için
│
├── 2-config/                               # [~10 MB] LazyVim ve WezTerm konfigürasyonları
│   │
│   ├── init.lua                            # Neovim başlangıç dosyası
│   ├── lazy-lock.json                      # Plugin versiyon kilidi (46 plugin)
│   ├── lazyvim.json                        # LazyVim metadata
│   ├── .neoconf.json                       # Neoconf settings
│   │
│   ├── lua/                                # Lua konfigürasyon dizini
│   │   ├── config/                         # Core konfigürasyonlar
│   │   │   ├── autocmds.lua                # Auto komutlar
│   │   │   ├── keymaps.lua                 # Klavye kısayolları
│   │   │   ├── lazy.lua                    # Lazy.nvim config (online)
│   │   │   ├── lazy-offline.lua            # Lazy.nvim config (ONPREM)
│   │   │   └── options.lua                 # Neovim seçenekleri
│   │   │
│   │   └── plugins/                        # Plugin konfigürasyonları
│   │       ├── dashboard.lua               # Dashboard özelleştirmesi
│   │       ├── extras.lua                  # LazyVim extras
│   │       ├── lsp.lua                     # LSP konfigürasyonu
│   │       ├── java-dap.lua                # Java debugging
│   │       ├── lazygit.lua                 # Lazygit integration
│   │       └── spring-boot.lua             # Spring Boot tools
│   │
│   ├── wezterm/                            # WezTerm konfigürasyonları
│   │   ├── wezterm.lua                     # WezTerm config (online)
│   │   ├── wezterm-offline.lua             # WezTerm config (ONPREM)
│   │   ├── WEZTERM_SETUP.md                # WezTerm kurulum kılavuzu
│   │   │
│   │   └── powershell/                     # PowerShell profil (opsiyonel)
│   │       └── Microsoft.PowerShell_profile.ps1  # Unix-like komutlar
│   │
│   ├── ONPREM_KURULUM.md                   # Detaylı Türkçe kurulum rehberi
│   ├── INSTALLATION_CHECKLIST.md           # Kurulum kontrol listesi
│   ├── BUNDLE_PREPARATION.md               # Bundle hazırlama kılavuzu
│   ├── PACKAGE_STRUCTURE.md                # Bu dosya
│   ├── DOWNLOAD_LINKS.md                   # İndirme linkleri
│   │
│   ├── install-windows.ps1                 # Basit installer (online)
│   ├── quick-install.ps1                   # Hızlı installer (online)
│   ├── verify-install.ps1                  # Basit doğrulama
│   ├── verify-onprem.ps1                   # ONPREM doğrulama
│   ├── prepare-bundle.ps1                  # Bundle hazırlayıcı
│   └── check-profile.ps1                   # PowerShell profil kontrol
│
└── 3-bundle/                               # [1-2 GB] Önceden indirilmiş plugin ve tool'lar
    │
    ├── lazy/                               # LazyVim plugin'leri
    │   ├── lazy.nvim/                      # Plugin manager
    │   ├── LazyVim/                        # LazyVim framework
    │   ├── tokyonight.nvim/                # Tema
    │   ├── catppuccin/                     # Alternatif tema
    │   ├── nvim-lspconfig/                 # LSP konfigürasyon
    │   ├── mason.nvim/                     # Mason plugin
    │   ├── nvim-treesitter/                # Syntax parser
    │   ├── telescope.nvim/                 # Fuzzy finder
    │   ├── which-key.nvim/                 # Keybinding yardımcısı
    │   └── ... (40+ plugin daha)
    │
    ├── mason/                              # Mason tool'ları
    │   ├── bin/                            # Mason binary'ler
    │   └── packages/                       # Tool paketleri
    │       ├── lua-language-server/        # Lua LSP
    │       ├── typescript-language-server/ # TypeScript LSP
    │       ├── prettier/                   # Formatter
    │       ├── stylua/                     # Lua formatter
    │       ├── jdtls/                      # Java LSP
    │       └── ... (20+ tool daha)
    │
    ├── state/                              # Neovim state dosyaları
    │
    └── ... (diğer nvim-data içeriği)
```

## 📊 Boyut Dağılımı

| Bileşen | Boyut | Açıklama |
|---------|-------|----------|
| **1-installers/** | 500 MB - 2 GB | Zorunlu + opsiyonel installer'lar |
| • Neovim | ~30 MB | Zorunlu |
| • Git | ~50 MB | Zorunlu |
| • WezTerm | ~50 MB | Zorunlu |
| • Nerd Font | ~20 MB | Zorunlu |
| • PowerShell 7 | ~100 MB | Opsiyonel |
| • MSYS2 | ~100 MB | Opsiyonel |
| • JDK | ~150-300 MB | Opsiyonel |
| **2-config/** | ~10 MB | Config dosyaları ve dokümantasyon |
| **3-bundle/** | 1-2 GB | Plugin'ler + Mason tools |
| • lazy/ | ~800 MB - 1.2 GB | 40-50 plugin |
| • mason/ | ~200-500 MB | 20-30 tool |
| **TOPLAM** | **2-4 GB** | Seçilen opsiyonlara bağlı |

## 🗂️ Bileşen Detayları

### 1. INSTALL_ONPREM.ps1 (Ana Script)

**Amaç**: Tüm kurulum sürecini otomatikleştiren master script

**Fonksiyonlar**:
- Sistem gereksinimlerini kontrol eder
- Eksik installer'ları yükler
- Bundle'ı nvim-data'ya kopyalar
- Config dosyalarını doğru konumlara kopyalar
- Offline config'leri seçme seçeneği sunar
- Kurulum doğrulaması yapar

**Kullanım**:
```powershell
.\INSTALL_ONPREM.ps1                    # Varsayılan
.\INSTALL_ONPREM.ps1 -SkipInstallers    # Installer'ları atla
.\INSTALL_ONPREM.ps1 -SkipBundle        # Bundle'ı atla
```

### 2. Installer Klasörü (1-installers/)

**Amaç**: Tüm gerekli yazılım installer'larını içerir

**Zorunlu Installer'lar**:
1. **Neovim** (nvim-win64.msi)
   - Modern Vim-based editor
   - LazyVim'in çalışması için gerekli
   - Minimum: 0.9.0, Önerilen: 0.10.0+

2. **Git** (Git-*-64-bit.exe)
   - Versiyon kontrol sistemi
   - Plugin'leri clone'lamak için gerekli
   - Minimum: 2.0+

3. **WezTerm** (WezTerm-*.exe)
   - Modern, GPU-accelerated terminal
   - Cross-platform, Lua config desteği
   - En iyi LazyVim deneyimi için önerilir

4. **Nerd Font** (CascadiaCode.zip)
   - Icon ve sembol desteği
   - LazyVim UI için gerekli
   - CaskaydiaCove Nerd Font önerilir

**Opsiyonel Installer'lar**:
5. **PowerShell 7** (PowerShell-*.msi)
   - Modern PowerShell
   - Unix-like komutlar için
   - Windows PowerShell 5.1 yeterli ama 7 daha iyi

6. **MSYS2** (msys2-*.exe)
   - MinGW-w64 compiler
   - Bazı plugin'lerin derlenmesi için
   - Treesitter parser derleme

7. **JDK** (jdk-*.msi)
   - Java Development Kit
   - Java/Spring Boot development için
   - jdtls LSP server gerektirir

### 3. Config Klasörü (2-config/)

**Amaç**: LazyVim ve WezTerm konfigürasyon dosyaları

**Ana Dosyalar**:
- `init.lua`: Neovim başlangıç noktası
- `lazy-lock.json`: Plugin versiyonları (46 plugin)
- `lua/config/`: Core konfigürasyonlar
- `lua/plugins/`: Plugin özelleştirmeleri

**Özel ONPREM Dosyaları**:
- `lua/config/lazy-offline.lua`: Offline-optimized lazy config
- `wezterm/wezterm-offline.lua`: Offline-optimized wezterm config

**Dokümantasyon**:
- `ONPREM_KURULUM.md`: Türkçe detaylı rehber (609 satır)
- `INSTALLATION_CHECKLIST.md`: Adım adım checklist
- `BUNDLE_PREPARATION.md`: Bundle hazırlama
- `PACKAGE_STRUCTURE.md`: Bu dosya
- `DOWNLOAD_LINKS.md`: İndirme linkleri

**Script'ler**:
- `INSTALL_ONPREM.ps1`: Ana installer
- `prepare-bundle.ps1`: Bundle hazırlayıcı
- `verify-onprem.ps1`: ONPREM doğrulama
- `install-windows.ps1`: Basit installer
- `verify-install.ps1`: Basit doğrulama

### 4. Bundle Klasörü (3-bundle/)

**Amaç**: Offline kullanım için önceden indirilmiş plugin ve tool'lar

**İçerik**:
- **lazy/**: LazyVim plugin repository'leri
  - Her plugin ayrı klasör
  - Git clone edilmiş hali
  - lazy-lock.json'daki versiyonlar

- **mason/packages/**: Mason tool'ları
  - LSP server'lar (language server protocol)
  - Formatter'lar (prettier, stylua, vb.)
  - Linter'lar (eslint_d, vb.)
  - Debug adapter'ları (DAP)

- **state/**: Neovim state ve cache
  - Plugin metadata
  - Lazy.nvim cache

**Oluşturma**:
prepare-bundle.ps1 ile otomatik:
```powershell
.\prepare-bundle.ps1
```

## 🔄 Kurulum Akışı

```
┌─────────────────────────────────────────┐
│  ONPREM Paket (USB/Network Drive)      │
│  lazyvim-onprem-package/                │
└─────────┬───────────────────────────────┘
          │
          ├─> 1. INSTALL_ONPREM.ps1 çalıştır
          │
          ├─> 2. Sistem kontrolü
          │   • Neovim yüklü mü?
          │   • Git yüklü mü?
          │   • WezTerm yüklü mü?
          │
          ├─> 3. Eksik installer'ları yükle
          │   • 1-installers/ klasöründen
          │   • .msi / .exe dosyaları çalıştır
          │
          ├─> 4. Bundle kopyala
          │   • 3-bundle/ → %LOCALAPPDATA%\nvim-data\
          │   • ~1-2 GB veri kopyalanır
          │
          ├─> 5. Config kopyala
          │   • 2-config/ → %LOCALAPPDATA%\nvim\
          │   • Offline config seçeneği
          │
          ├─> 6. WezTerm config kopyala
          │   • wezterm.lua → %USERPROFILE%\.wezterm.lua
          │
          ├─> 7. PowerShell profil (opsiyonel)
          │   • Unix-like komutlar
          │
          └─> 8. Doğrulama
              • verify-onprem.ps1
              • Tüm kontroller başarılı

┌─────────────────────────────────────────┐
│  Kurulum Tamamlandı!                    │
│  • Neovim kullanıma hazır               │
│  • WezTerm yapılandırıldı               │
│  • Tüm plugin'ler offline çalışıyor     │
└─────────────────────────────────────────┘
```

## 📁 Hedef Kurulum Konumları

Kurulum sonrası dosyalar şu konumlara kopyalanır:

| Kaynak | Hedef | Açıklama |
|--------|-------|----------|
| `2-config/*.lua` | `%LOCALAPPDATA%\nvim\` | LazyVim config |
| `2-config/lua/` | `%LOCALAPPDATA%\nvim\lua\` | Lua dizini |
| `3-bundle/` | `%LOCALAPPDATA%\nvim-data\` | Plugin bundle |
| `wezterm/wezterm.lua` | `%USERPROFILE%\.wezterm.lua` | WezTerm config |
| `powershell/*.ps1` | `$PROFILE` | PowerShell profil |

**Örnek Yollar** (Windows):
```
C:\Users\YourName\AppData\Local\nvim\           # LazyVim config
C:\Users\YourName\AppData\Local\nvim-data\      # Plugin bundle
C:\Users\YourName\.wezterm.lua                  # WezTerm config
C:\Users\YourName\Documents\PowerShell\Microsoft.PowerShell_profile.ps1  # PS profil
```

## 🎯 Minimal vs Full Paket

### Minimal Paket (~1 GB)

Sadece zorunlu bileşenler:
```
lazyvim-onprem-package-minimal/
├── 1-installers/
│   ├── neovim/
│   ├── git/
│   ├── wezterm/
│   └── fonts/
├── 2-config/
├── 3-bundle/  (Sadece core plugin'ler)
└── INSTALL_ONPREM.ps1
```

### Full Paket (~4 GB)

Tüm opsiyonel bileşenler dahil:
```
lazyvim-onprem-package-full/
├── 1-installers/
│   ├── neovim/
│   ├── git/
│   ├── wezterm/
│   ├── fonts/
│   ├── powershell/
│   ├── compiler/
│   └── jdk/
├── 2-config/
├── 3-bundle/  (Tüm plugin'ler + tüm Mason tools)
└── INSTALL_ONPREM.ps1
```

## 🔐 Güvenlik ve Bütünlük

### Hash Kontrolü

Paket bütünlüğünü doğrulamak için:

```powershell
# Bundle hash'i oluştur
Get-FileHash -Path "3-bundle" -Algorithm SHA256 | Export-Csv bundle-hash.csv

# Hedef makinede doğrula
Compare-Object (Import-Csv bundle-hash.csv) (Get-FileHash -Path "3-bundle" -Algorithm SHA256)
```

### Virüs Taraması

Kurulumdan önce:
```powershell
# Windows Defender ile tara
Start-MpScan -ScanPath "C:\path\to\lazyvim-onprem-package" -ScanType QuickScan
```

## 📝 Notlar

- **Windows 10/11**: Bu paket Windows için optimize edilmiştir
- **Portable Değil**: Kurulum sistem klasörlerine yapılır (%LOCALAPPDATA%)
- **İnternet Yok**: Bundle sayesinde tamamen offline çalışır
- **Güncellemeler**: Auto-update kapalı (offline mode)
- **Özelleştirme**: Config dosyaları tamamen düzenlenebilir

## ❓ Sık Sorulan Sorular

**S: Paket boyutu neden bu kadar büyük?**
A: Plugin'ler ve LSP tool'ları toplam 1-2 GB. Installer'lar 500 MB - 2 GB ekstra.

**S: Paket ne kadar yer kaplar kurulduktan sonra?**
A: ~1.5-2.5 GB (installer'lar silinebilir, sadece bundle kalır).

**S: Minimal paket yeterli mi?**
A: Java/Spring Boot development yapmıyorsan evet. Sadece core araçlar yeter.

**S: Bundle güncellemesi nasıl yapılır?**
A: İnternet bağlantılı makinede prepare-bundle.ps1'i tekrar çalıştır.

**S: ONPREM paketi network drive'da olabilir mi?**
A: Evet, ama kurulum lokal disk'e kopyalama yapar. Network'ten direk çalışmaz.

---

**ONPREM paket yapısı hakkında sorularınız için dokümantasyona başvurun!**
