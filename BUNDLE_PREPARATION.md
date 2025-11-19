# Bundle Hazırlama Kılavuzu

Bu doküman, ONPREM (offline) kurulum için gerekli plugin ve tool bundle'ını hazırlamak için detaylı talimatlar içerir.

## 📋 Gereksinimler

Bundle hazırlamak için **İNTERNET BAĞLANTISI OLAN** bir Windows makinede:

- ✅ Windows 10/11
- ✅ PowerShell 5.1+
- ✅ Neovim 0.9.0+ (yüklü olmalı)
- ✅ Git 2.0+ (yüklü olmalı)
- ✅ **Aktif internet bağlantısı**
- ✅ En az 5 GB boş disk alanı

## 🚀 Hızlı Başlangıç

```powershell
# 1. Repo'yu clone'la veya indir
git clone https://github.com/your-repo/lazyvim-config.git
cd lazyvim-config

# 2. Bundle hazırlayıcı script'i çalıştır
.\prepare-bundle.ps1

# 3. Bekle (5-10 dakika)
# Script otomatik olarak:
# - LazyVim config'ini kuracak
# - Tüm plugin'leri indirecek
# - Mason tool'larını indirecek
# - Bundle oluşturacak
```

## 📦 Bundle İçeriği

Bundle hazırlandıktan sonra şunları içerecek:

### 1. LazyVim Plugin'leri (~800 MB - 1.2 GB)

**Plugin Kategorileri:**
- **Core**: lazy.nvim, LazyVim, plenary.nvim, nui.nvim
- **UI**: tokyonight, catppuccin, lualine, bufferline, noice, which-key
- **Editor**: telescope, fzf-lua, flash, grug-far
- **Completion**: blink.cmp, nvim-snippets
- **LSP**: nvim-lspconfig, mason.nvim, SchemaStore
- **Formatting**: conform.nvim
- **Linting**: nvim-lint
- **Treesitter**: nvim-treesitter + textobjects + autotag
- **Git**: gitsigns, lazygit
- **Debugging**: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
- **Java**: nvim-jdtls, spring-boot.nvim
- **Utilities**: mini.*, project.nvim, persistence, trouble, todo-comments

**Toplam**: 40-50 plugin

### 2. Mason Tool'ları (~200-500 MB)

**LSP Server'lar:**
- lua-language-server
- typescript-language-server
- astro-language-server
- vue-language-server
- tailwindcss-language-server
- css-lsp
- html-lsp
- json-lsp
- yaml-language-server
- docker-compose-language-service
- dockerfile-language-server
- emmet-ls
- jdtls (Java)

**Formatter'lar:**
- prettier
- stylua
- google-java-format

**Linter'lar:**
- eslint_d
- checkstyle (Java)

**Debug Adapter'ları:**
- java-debug-adapter
- java-test

**Toplam**: 20-30 tool

### 3. Treesitter Parser'ları (~50-100 MB)

Otomatik olarak derlenen dil parser'ları:
- lua, typescript, javascript, tsx, json, yaml, html, css
- markdown, markdown_inline, vim, vimdoc
- java, python, rust, go, c, cpp
- ve diğerleri

## 🔧 Detaylı Hazırlama Adımları

### Adım 1: Ortam Hazırlığı

```powershell
# Neovim versiyonunu kontrol et
nvim --version
# Minimum: NVIM v0.9.0

# Git versiyonunu kontrol et
git --version
# Minimum: git version 2.0

# İnternet bağlantısını test et
Test-Connection github.com -Count 1
```

### Adım 2: Temiz Kurulum (Opsiyonel)

Eğer mevcut LazyVim kurulumunuz varsa ve temiz başlamak istiyorsanız:

```powershell
# Temiz kurulum için -CleanInstall parametresi kullan
.\prepare-bundle.ps1 -CleanInstall
```

Bu komut:
- Mevcut `%LOCALAPPDATA%\nvim` klasörünü silecek
- Mevcut `%LOCALAPPDATA%\nvim-data` klasörünü silecek
- Sıfırdan yeni kurulum yapacak

⚠️ **DİKKAT**: Bu işlem geri alınamaz! Mevcut konfigürasyonunuzu yedekleyin.

### Adım 3: Bundle Oluşturma

```powershell
# Varsayılan (bundle klasörü: .\bundle)
.\prepare-bundle.ps1

# Özel output dizini belirt
.\prepare-bundle.ps1 -OutputDir "D:\my-bundle"
```

Script çalışma adımları:

#### 3.1. Gereksinim Kontrolü
- ✅ Neovim yüklü mü?
- ✅ Git yüklü mü?
- ✅ İnternet bağlantısı var mı?

#### 3.2. LazyVim Config Kurulumu
- Config dosyalarını `%LOCALAPPDATA%\nvim` 'e kopyalar
- init.lua, lua/ klasörü, lazy-lock.json

#### 3.3. Plugin İndirme
```
nvim --headless "+Lazy! sync" +qa
```
- Tüm plugin'leri GitHub'dan clone'lar
- lazy-lock.json'daki kilitle belirtilen versiyonları kullanır
- 40-50 plugin indirilir
- **Süre**: 2-5 dakika (internet hızına bağlı)

#### 3.4. Mason Tool İndirme
```
nvim --headless "+MasonInstall <tool>" +qa
```
- Her Mason tool için ayrı komut çalıştırır
- LSP server'ları, formatter'ları, linter'ları indirir
- 20-30 tool indirilir
- **Süre**: 3-7 dakika (internet hızına bağlı)

#### 3.5. Bundle Oluşturma
- `%LOCALAPPDATA%\nvim-data` klasörünü bundle dizinine kopyalar
- Tüm plugin'leri içerir
- Tüm Mason tool'ları içerir
- Treesitter parser'ları içerir
- **Süre**: 1-2 dakika (disk hızına bağlı)

#### 3.6. Doğrulama
- Kritik dizinlerin varlığını kontrol eder
- Plugin sayısını sayar
- Mason tool sayısını sayar
- Bundle boyutunu hesaplar

### Adım 4: Bundle İstatistikleri

Script tamamlandığında özet gösterir:

```
Bundle İçeriği:
  Plugin'ler     : 46
  Mason tool'lar : 24
  Treesitter     : 18 parser
  Toplam Boyut   : 1247.52 MB (1.22 GB)
```

### Adım 5: Bundle Doğrulama

Manuel doğrulama:

```powershell
# Bundle dizinine git
cd bundle

# Kritik klasörleri kontrol et
dir lazy\lazy.nvim      # Plugin manager
dir lazy\LazyVim        # LazyVim framework
dir mason\packages      # Mason tools
```

Beklenen yapı:
```
bundle/
├── lazy/
│   ├── lazy.nvim/
│   ├── LazyVim/
│   ├── tokyonight.nvim/
│   ├── nvim-lspconfig/
│   └── ... (40+ plugin)
├── mason/
│   ├── bin/
│   └── packages/
│       ├── lua-language-server/
│       ├── typescript-language-server/
│       └── ... (20+ tool)
├── state/
└── ... (diğer nvim-data içeriği)
```

## 📤 Bundle'ı ONPREM Pakete Ekleme

### Yöntem 1: Manuel Kopyalama

```powershell
# ONPREM paket yapısı oluştur
mkdir lazyvim-onprem-package
mkdir lazyvim-onprem-package\3-bundle

# Bundle'ı kopyala
Copy-Item .\bundle\* -Destination .\lazyvim-onprem-package\3-bundle\ -Recurse
```

### Yöntem 2: Otomatik Paket Oluşturma

prepare-bundle.ps1 script'i bittiğinde sorar:

```
Tam ONPREM paketi oluşturmak istiyor musunuz?
ONPREM paketi oluştur? (Y/N):
```

**Y** seçerseniz:
- Otomatik olarak `lazyvim-onprem-package/` klasörü oluşturur
- Bundle'ı `3-bundle/` olarak ekler
- Config'leri `2-config/` olarak ekler
- Installer klasör yapısını oluşturur
- README-ONPREM.md oluşturur

## 🔄 Bundle Güncelleme

Zaman içinde yeni plugin'ler veya tool güncellemeleri isteyebilirsiniz:

### Tam Güncelleme

```powershell
# Temiz kurulum + yeni bundle
.\prepare-bundle.ps1 -CleanInstall
```

### Kısmi Güncelleme

1. Mevcut nvim-data'yı kullan
2. Sadece yeni plugin'leri ekle
3. Bundle'ı yeniden oluştur

```powershell
# Neovim'de plugin güncelle
nvim
:Lazy sync

# Mason tool güncelle
:Mason

# Yeni bundle oluştur
.\prepare-bundle.ps1
```

## 🐛 Sorun Giderme

### Plugin İndirme Başarısız

**Sorun**: "Failed to clone lazy.nvim" hatası

**Çözüm**:
```powershell
# Git proxy ayarlarını kontrol et
git config --global http.proxy
git config --global https.proxy

# Gerekirse proxy'yi kaldır
git config --global --unset http.proxy
git config --global --unset https.proxy

# SSH yerine HTTPS kullan
git config --global url."https://github.com/".insteadOf git@github.com:
```

### Mason Tool İndirme Başarısız

**Sorun**: Bazı Mason tool'lar indirilemedi

**Çözüm**:
```powershell
# Neovim'i manuel aç
nvim

# Mason'ı aç
:Mason

# Eksik tool'ları manuel yükle
# İlgili tool'un üzerine gel ve 'i' tuşuna bas
```

### Bundle Çok Büyük

**Sorun**: Bundle 2 GB'den büyük, taşımak zor

**Çözüm**:

#### Minimal Bundle Oluştur
```powershell
# lazy-lock.json'dan gereksiz plugin'leri kaldır
# Sadece core plugin'leri tut
```

#### Bundle'ı Sıkıştır
```powershell
# 7-Zip veya Windows Compress kullan
Compress-Archive -Path .\bundle -DestinationPath bundle.zip

# Sonuç: ~500-800 MB sıkıştırılmış
```

### İnternet Yavaş

**Sorun**: Bundle hazırlama çok uzun sürüyor (30+ dakika)

**Çözüm**:
- ☕ Kahve molası ver, script çalışsın
- Git shallow clone kullan (prepare-bundle.ps1 zaten kullanıyor)
- Daha hızlı internet bağlantısı olan bir makine kullan

## 📊 Bundle Boyut Optimizasyonu

### Gereksiz İçerikleri Çıkar

```powershell
# Bundle oluştuktan sonra temizlik yap
cd bundle

# Git dizinlerini sil (plugin'ler zaten clone'landı)
Get-ChildItem -Recurse -Directory -Filter ".git" | Remove-Item -Recurse -Force

# Test dosyalarını sil (opsiyonel)
Get-ChildItem -Recurse -Directory -Filter "tests" | Remove-Item -Recurse -Force

# Dokümantasyon dosyalarını sil (opsiyonel, önerilmez)
Get-ChildItem -Recurse -File -Filter "*.md" | Remove-Item -Force
```

⚠️ **DİKKAT**: .git klasörlerini silmek plugin güncellemelerini engelleyebilir.

### Sadece Gerekli Tool'ları Yükle

prepare-bundle.ps1'i düzenle:

```powershell
# Sadece bu tool'ları yükle
$masonTools = @(
    "lua-language-server",
    "typescript-language-server",
    "prettier",
    "stylua"
)
```

## 🎯 En İyi Pratikler

1. **Bundle'ı düzenli güncelle**
   - Ayda bir yeni bundle oluştur
   - Güvenlik güncellemeleri için önemli

2. **Bundle'ı versiyonla**
   ```
   bundle-2024-01-15/
   bundle-2024-02-15/
   bundle-2024-03-15/
   ```

3. **Bundle metadata'sı oluştur**
   ```powershell
   # bundle-info.txt
   Date: 2024-01-15
   LazyVim: latest
   Neovim: 0.10.0
   Plugins: 46
   Mason Tools: 24
   Size: 1.2 GB
   ```

4. **Hash kontrolü yap**
   ```powershell
   # Bundle'ın bütünlüğünü doğrula
   Get-FileHash -Path bundle.zip -Algorithm SHA256
   ```

5. **Test et**
   - Bundle oluştuktan sonra temiz bir makinede test et
   - ONPREM kurulum simülasyonu yap

## 📚 Referanslar

- **prepare-bundle.ps1**: Otomatik bundle hazırlayıcı script
- **INSTALLATION_CHECKLIST.md**: Kurulum adımları
- **PACKAGE_STRUCTURE.md**: ONPREM paket yapısı
- **ONPREM_KURULUM.md**: Detaylı kurulum rehberi

---

## ✅ Checklist

Bundle hazırlamadan önce:

- [ ] İnternet bağlantısı aktif
- [ ] Neovim yüklü
- [ ] Git yüklü
- [ ] En az 5 GB boş alan var
- [ ] prepare-bundle.ps1 mevcut

Bundle hazırlandıktan sonra:

- [ ] `bundle/` klasörü oluştu
- [ ] 40+ plugin var
- [ ] 20+ Mason tool var
- [ ] Doğrulama başarılı
- [ ] Boyut: 1-2 GB arası
- [ ] ONPREM pakete kopyalandı

---

**Bundle başarıyla hazırlandığında, ONPREM kurulum için hazırsınız!** 🎉
