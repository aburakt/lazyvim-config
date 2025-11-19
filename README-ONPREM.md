# 🚀 LazyVim + WezTerm ONPREM Kurulum Paketi

**Tamamen Offline** Windows kurulum paketi - İnternet bağlantısı gerekmez!

## 📦 Bu Nedir?

Bu paket, **ONPREM (offline)** ortamlarda LazyVim ve WezTerm kurulumu için hazırlanmış, tamamen otomatik kurulum paketidir.

**İçindekiler**:
- ✅ **LazyVim**: Modern Neovim konfigürasyonu (46 plugin)
- ✅ **WezTerm**: GPU-accelerated terminal emulator
- ✅ **Plugin Bundle**: 40+ önceden indirilmiş plugin
- ✅ **Mason Tools**: 20+ LSP server, formatter, linter
- ✅ **Tüm Installer'lar**: Neovim, Git, WezTerm, Font, vb.
- ✅ **Offline Config**: Auto-update kapalı, tamamen offline çalışır

## ⚡ Hızlı Başlangıç

### Kurulum (3 Adım)

```powershell
# 1. PowerShell'i aç (Run as Administrator önerilir)

# 2. Paket dizinine git
cd C:\path\to\lazyvim-onprem-package

# 3. Kurulum script'ini çalıştır
.\INSTALL_ONPREM.ps1
```

**Hepsi bu kadar!** Script otomatik olarak:
1. ✅ Sistem gereksinimlerini kontrol eder
2. ✅ Eksik installer'ları yükler
3. ✅ Plugin bundle'ını kopyalar
4. ✅ Config dosyalarını kurar
5. ✅ Kurulumu doğrular

### İlk Kullanım

Kurulum tamamlandıktan sonra:

```bash
# 1. Neovim'i başlat
nvim

# 2. LazyVim dashboard'ı görünecek
# Tüm plugin'ler bundle'dan yüklü, internet gerekmez!

# 3. LSP'leri test et
:checkhealth

# 4. Plugin'leri kontrol et
:Lazy

# 5. Mason tool'ları kontrol et
:Mason
```

## 📋 Gereksinimler

### ONPREM Makinede
- Windows 10 1903+ veya Windows 11
- PowerShell 5.1+ (zaten yüklü)
- En az 5 GB boş disk alanı
- **İnternet bağlantısı GEREKMİYOR** ✨

### Paket Hazırlarken (İnternet Bağlantılı Makine)
- Bundle hazırlamak için internet gerekir
- prepare-bundle.ps1 ile otomatik

## 📁 Paket Yapısı

```
lazyvim-onprem-package/          [2-4 GB]
├── INSTALL_ONPREM.ps1           # ← BU SCRIPT'İ ÇALIŞTIR
├── README-ONPREM.md             # ← Bu dosya
│
├── 1-installers/                # Tüm installer'lar
│   ├── neovim/
│   ├── git/
│   ├── wezterm/
│   ├── fonts/
│   ├── powershell/
│   ├── compiler/
│   └── jdk/
│
├── 2-config/                    # LazyVim ve WezTerm config'leri
│   ├── init.lua
│   ├── lua/
│   ├── wezterm/
│   └── *.md (dokümantasyon)
│
└── 3-bundle/                    # Plugin'ler ve Mason tools
    ├── lazy/                    # 40+ plugin
    └── mason/                   # 20+ LSP tool
```

## 🎯 Özellikler

### LazyVim
- **46 Plugin**: Telescope, Treesitter, LSP, DAP, Git, vb.
- **Java/Spring Boot**: Full support (jdtls, spring-boot.nvim)
- **TypeScript/React**: Astro, Vue, Tailwind desteği
- **Offline Mode**: Auto-update kapalı, tamamen offline
- **Tokyo Night Tema**: Modern, göz yormayan

### WezTerm
- **Cross-Platform**: Windows/macOS/Linux config
- **GPU Accelerated**: Yüksek performans
- **Nerd Font**: Icon desteği
- **Vim-like Shortcuts**: `CTRL+H/J/K/L` split navigation

### PowerShell Profil (Opsiyonel)
- **Unix-like Komutlar**: `ls`, `grep`, `cat`, `which`, vb.
- **Git Shortcuts**: `gs`, `ga`, `gc`, `gp`
- **Syntax Highlighting**: PSReadLine ile

## 📚 Dokümantasyon

| Dosya | Açıklama |
|-------|----------|
| **README-ONPREM.md** | Bu dosya - Hızlı başlangıç |
| **INSTALLATION_CHECKLIST.md** | Adım adım kurulum kontrol listesi |
| **ONPREM_KURULUM.md** | Detaylı Türkçe kurulum rehberi (609 satır) |
| **BUNDLE_PREPARATION.md** | Bundle nasıl hazırlanır |
| **PACKAGE_STRUCTURE.md** | Paket yapısı detayları |
| **DOWNLOAD_LINKS.md** | Installer indirme linkleri |

## 🔧 Script'ler

| Script | Amaç |
|--------|------|
| **INSTALL_ONPREM.ps1** | Ana kurulum script'i (ÇALIŞTIR!) |
| **prepare-bundle.ps1** | Bundle hazırlayıcı (internet gerekli) |
| **verify-onprem.ps1** | Kurulum doğrulama |
| **install-windows.ps1** | Basit installer (online) |
| **verify-install.ps1** | Basit doğrulama |

## ⚙️ Kurulum Seçenekleri

### Varsayılan Kurulum
```powershell
.\INSTALL_ONPREM.ps1
```
- Tüm installer'ları yükler
- Bundle'ı kopyalar
- Offline config kullanır

### Sadece Config Kurulumu
```powershell
.\INSTALL_ONPREM.ps1 -SkipInstallers
```
- Installer'ları atla (zaten yüklüyse)
- Sadece config dosyalarını kopyala

### Bundle'sız Kurulum
```powershell
.\INSTALL_ONPREM.ps1 -SkipBundle
```
- Bundle kopyalamayı atla
- İlk Neovim açılışında plugin'ler indirilecek (internet gerekir)

## 🐛 Sorun Giderme

### Kurulum Başarısız

**Sorun**: "Access Denied" hatası

**Çözüm**:
```powershell
# PowerShell'i yönetici olarak çalıştır
# Sağ tık → "Run as Administrator"
```

### Execution Policy Hatası

**Sorun**: "...cannot be loaded because running scripts is disabled"

**Çözüm**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Plugin'ler Yüklenmiyor

**Sorun**: Neovim'de plugin'ler yok

**Çözüm**:
```bash
# Neovim'de
:Lazy sync

# veya bundle'ı kontrol et
cd %LOCALAPPDATA%\nvim-data\lazy
dir
```

### Font İkonları Görünmüyor

**Sorun**: Semboller garip görünüyor

**Çözüm**:
1. Nerd Font yüklenmiş mi kontrol et
2. WezTerm config'de font doğru mu kontrol et
3. Terminal'i yeniden başlat

### Daha Fazla Yardım

```powershell
# Detaylı doğrulama
.\verify-onprem.ps1

# Dokümantasyona bak
notepad ONPREM_KURULUM.md
```

## 🎓 Sonraki Adımlar

Kurulum tamamlandıktan sonra:

### 1. LazyVim Öğren
```vim
" Vim tutor'ı çalıştır
:Tutor

" LazyVim yardım
:help LazyVim

" Keybinding'leri gör
<Space>  (leader key, menü açılır)
```

### 2. Konfigürasyonu Özelleştir
```
%LOCALAPPDATA%\nvim\lua\plugins\
```
Bu dizine kendi plugin'lerini ekle.

### 3. Java/Spring Boot Development
```vim
" Java dosyası aç
nvim MyApp.java

" LSP otomatik başlar (jdtls)
" :LspInfo ile kontrol et
```

### 4. Git Workflow
```bash
# WezTerm'de
<Space>gg   # Lazygit açar
```

## 📊 Sistem Gereksinimleri

| Bileşen | Minimum | Önerilen |
|---------|---------|----------|
| **OS** | Windows 10 1903 | Windows 11 |
| **RAM** | 4 GB | 8 GB+ |
| **Disk** | 5 GB boş alan | 10 GB+ |
| **CPU** | Dual-core | Quad-core+ |
| **GPU** | Integrated | Dedicated (WezTerm için) |

## 🔐 Güvenlik

- ✅ Tüm installer'lar resmi kaynaklardan
- ✅ GitHub release'lerden indirilebilir
- ✅ Hash kontrolü yapılabilir
- ✅ Açık kaynak yazılımlar

## 📈 Versiyon Bilgisi

**Paket Versiyonu**: 1.0.0
**Oluşturulma Tarihi**: 2024-01-15

**İçerik**:
- LazyVim: latest (lazy-lock.json'da kilitli)
- Neovim: 0.10.0+
- Git: 2.43.0+
- WezTerm: latest
- Plugin'ler: 46 adet
- Mason Tools: 24 adet

## 🤝 Katkıda Bulunma

Bu paket açık kaynak bir projedir. Katkılarınızı bekliyoruz!

**Geri bildirim**:
- GitHub Issues
- Pull Request
- Dokümantasyon iyileştirmeleri

## 📜 Lisans

Bu konfigürasyon MIT lisansı altındadır.

**Bağımlılıklar**:
- LazyVim: Apache 2.0
- Neovim: Apache 2.0
- WezTerm: MIT-like
- Plugin'ler: Çeşitli açık kaynak lisanslar

## 🙏 Teşekkürler

- **LazyVim**: folke/LazyVim
- **Neovim**: neovim/neovim
- **WezTerm**: wez/wezterm
- **Tüm plugin yazarları**: Amazing work!

---

## ✅ Kurulum Özeti

1. **Paketi taşı**: USB/Network drive ile ONPREM makineye
2. **Script'i çalıştır**: `.\INSTALL_ONPREM.ps1`
3. **Bekle**: 5-10 dakika (bundle kopyalanması)
4. **Neovim'i başlat**: `nvim`
5. **Tadını çıkar**: Modern development environment!

---

## 🚀 Başlamak İçin Hazır mısın?

```powershell
cd lazyvim-onprem-package
.\INSTALL_ONPREM.ps1
```

**Soruların mı var?** Dokümantasyona bak:
- 📖 `ONPREM_KURULUM.md` - Detaylı rehber
- ✅ `INSTALLATION_CHECKLIST.md` - Adım adım checklist
- 📦 `PACKAGE_STRUCTURE.md` - Paket yapısı
- 📥 `DOWNLOAD_LINKS.md` - İndirme linkleri

**İyi çalışmalar!** 💻✨

---

*Bu paket tamamen offline çalışır. İnternet bağlantısı gerekmez!*
