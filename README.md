# LazyVim Konfigürasyonları

Bu repo, kişisel LazyVim konfigürasyonlarımı içermektedir. Java Spring Boot geliştirme için optimize edilmiş ayarlar ve eklentiler bulunmaktadır.

## Özellikler

- Java ve Spring Boot desteği
- LSP (Language Server Protocol) entegrasyonu
- DAP (Debug Adapter Protocol) ile debugging
- Lazygit entegrasyonu
- Dashboard özelleştirmeleri
- Özel keymaps ve autocmds

## Windows On-Premise Kurulum

### Ön Gereksinimler

1. **Neovim (v0.9.0 veya üzeri)**
   - [Neovim releases](https://github.com/neovim/neovim/releases) sayfasından Windows installer'ı indirin
   - `nvim-win64.msi` dosyasını çalıştırarak kurulumu tamamlayın
   - Kurulum sonrası PowerShell'de `nvim --version` komutuyla kontrol edin

2. **Git**
   - [Git for Windows](https://git-scm.com/download/win) sitesinden indirin ve kurun
   - Kurulum sırasında "Git from the command line and also from 3rd-party software" seçeneğini işaretleyin

3. **C Compiler (gcc/mingw veya MSVC)**
   - [MSYS2](https://www.msys2.org/) kullanarak MinGW kurulumu önerilir:
     ```bash
     # MSYS2 terminal'de
     pacman -S mingw-w64-x86_64-gcc
     ```
   - Veya [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/) kurabilirsiniz

4. **Nerd Font**
   - [Nerd Fonts](https://www.nerdfonts.com/font-downloads) sitesinden bir font indirin (önerilen: JetBrainsMono Nerd Font)
   - Font dosyalarını sağ tıklayıp "Tüm kullanıcılar için yükle" seçeneğiyle kurun
   - Terminal uygulamanızda (Windows Terminal, PowerShell, vb.) font ayarlarını yapın

### Kurulum Adımları

1. **Eski Neovim konfigürasyonlarını yedekleyin (varsa)**

   PowerShell'de:
   ```powershell
   # Backup yapın
   Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
   Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
   ```

2. **Bu repoyu klonlayın**

   ```powershell
   git clone https://github.com/KULLANICI_ADINIZ/lazyvim-config.git $env:LOCALAPPDATA\nvim
   ```

3. **Neovim'i başlatın**

   ```powershell
   nvim
   ```

   İlk açılışta LazyVim otomatik olarak eklentileri yükleyecektir. Bu işlem birkaç dakika sürebilir.

4. **Mason ile LSP, Linter ve Formatter kurulumu**

   Neovim içinde:
   ```
   :Mason
   ```

   Açılan pencerede ihtiyacınız olan araçları yükleyin:
   - Java için: `jdtls`, `java-debug-adapter`, `java-test`
   - Diğer diller için gerekli LSP'leri yükleyin

### Java Geliştirme İçin Ek Ayarlar

1. **JDK kurulumu**
   - [Eclipse Temurin](https://adoptium.net/) veya [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) kurun
   - `JAVA_HOME` ortam değişkenini ayarlayın
   - `PATH` değişkenine JDK'nın bin klasörünü ekleyin

2. **Maven/Gradle kurulumu**
   - [Maven](https://maven.apache.org/download.cgi) veya [Gradle](https://gradle.org/install/) kurun
   - PATH değişkenine ekleyin

### Konfigürasyon Yapısı

```
nvim/
├── init.lua                 # Ana başlangıç dosyası
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Otomatik komutlar
│   │   ├── keymaps.lua     # Klavye kısayolları
│   │   ├── lazy.lua        # Lazy.nvim plugin manager ayarları
│   │   └── options.lua     # Neovim seçenekleri
│   └── plugins/
│       ├── dashboard.lua   # Dashboard özelleştirmeleri
│       ├── java-dap.lua    # Java debugging ayarları
│       ├── lazygit.lua     # Lazygit entegrasyonu
│       ├── lsp.lua         # LSP ayarları
│       ├── spring-boot.lua # Spring Boot desteği
│       └── extras.lua      # Ekstra eklentiler
├── lazy-lock.json          # Plugin versiyonları
└── lazyvim.json           # LazyVim ayarları
```

### Önemli Klavye Kısayolları

- `<leader>` = Space (boşluk tuşu)
- `<leader>ff` - Dosya ara
- `<leader>fg` - Metin ara (grep)
- `<leader>gg` - Lazygit'i aç
- `<leader>e` - Dosya gezginini aç
- `<F5>` - Debug başlat
- `<F10>` - Step over (debug)
- `<F11>` - Step into (debug)

### Sorun Giderme

**Eklentiler yüklenmiyor:**
```powershell
# Lazy.nvim cache'ini temizleyin
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data\lazy
nvim
```

**LSP çalışmıyor:**
- `:LspInfo` komutuyla LSP durumunu kontrol edin
- `:Mason` ile gerekli LSP'lerin kurulu olduğundan emin olun

**Java LSP hataları:**
- `JAVA_HOME` ortam değişkeninin doğru ayarlandığından emin olun
- `JAVA_FIX_INSTRUCTIONS.md` ve `JAVA_SPRING_BOOT_SETUP.md` dosyalarına bakın

## Güncelleme

Konfigürasyonları güncellemek için:

```powershell
cd $env:LOCALAPPDATA\nvim
git pull
```

Neovim içinde eklentileri güncellemek için:
```
:Lazy update
```

## Katkıda Bulunma

Bu kişisel bir konfigürasyon reposu olmakla birlikte, önerilerinizi issue açarak paylaşabilirsiniz.

## Lisans

MIT License - Detaylar için `LICENSE` dosyasına bakın.

## Kaynaklar

- [LazyVim Dokümantasyonu](https://lazyvim.github.io/)
- [Neovim Dokümantasyonu](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
