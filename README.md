# LazyVim Konfigürasyonları

Bu repo, kişisel LazyVim konfigürasyonlarımı içermektedir. Java Spring Boot geliştirme için optimize edilmiş ayarlar ve eklentiler bulunmaktadır.

## Özellikler

- Java ve Spring Boot desteği
- LSP (Language Server Protocol) entegrasyonu
- DAP (Debug Adapter Protocol) ile debugging
- Lazygit entegrasyonu
- Dashboard özelleştirmeleri
- Özel keymaps ve autocmds
- **WezTerm terminal emülatör konfigürasyonu** (Windows, macOS, Linux)
  - PowerShell Unix-like komutlar desteği
  - Cross-platform çalışan Lua konfigürasyonu
  - Onprem/offline ortamlar için optimize edilmiş

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
lazyvim-config/
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
├── wezterm/
│   ├── wezterm.lua         # WezTerm terminal konfigürasyonu
│   ├── powershell/
│   │   └── Microsoft.PowerShell_profile.ps1  # Unix-like komutlar
│   └── WEZTERM_SETUP.md    # WezTerm kurulum rehberi
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

---

## WezTerm Terminal Emülatör Kurulumu

Bu repo, modern ve güçlü bir terminal emülatörü olan **WezTerm** için cross-platform konfigürasyon içermektedir.

### Özellikler

- **Cross-platform**: Windows, macOS ve Linux'ta çalışır
- **GPU hızlandırmalı**: Yüksek performans
- **Unix-like komutlar**: Windows PowerShell'de `ls`, `grep`, `cat`, `touch` gibi komutlar
- **Split ve Tab desteği**: Tmux/Screen benzeri özellikler, ek araç gerekmez
- **Nerd Font desteği**: Icon ve özel karakter desteği
- **Onprem uyumlu**: Kısıtlı internet ortamlarında çalışır

### Hızlı Kurulum

#### Windows

```powershell
# WezTerm kurulumu (WinGet ile)
winget install wez.wezterm

# Config dosyasını kopyalayın
Copy-Item wezterm/wezterm.lua $env:USERPROFILE\.wezterm.lua

# PowerShell profil dosyasını kurun (Unix-like komutlar için)
$profilePath = "$env:USERPROFILE\Documents\PowerShell"
New-Item -ItemType Directory -Path $profilePath -Force
Copy-Item wezterm/powershell/Microsoft.PowerShell_profile.ps1 $profilePath\Microsoft.PowerShell_profile.ps1

# Execution Policy ayarlayın (Yönetici PowerShell'de)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### macOS

```bash
# WezTerm kurulumu
brew install --cask wezterm

# Config dosyasını kopyalayın (symlink önerilir)
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua

# Nerd Font kurulumu
brew tap homebrew/cask-fonts
brew install --cask font-caskaydia-cove-nerd-font
```

#### Linux

```bash
# Ubuntu/Debian için WezTerm kurulumu
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install wezterm

# Config dosyasını kopyalayın
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua
```

### Detaylı Kurulum ve Özelleştirme

Tüm detaylar için **[wezterm/WEZTERM_SETUP.md](wezterm/WEZTERM_SETUP.md)** dosyasına bakın. Bu dokümanda şunları bulabilirsiniz:

- Adım adım kurulum talimatları (Windows, macOS, Linux)
- Onprem/offline ortamlar için özel kurulum
- PowerShell profil kurulumu (Unix-like komutlar)
- Nerd Font kurulumu ve yapılandırması
- Tema ve görünüm özelleştirme
- Klavye kısayolları
- Sorun giderme

### Klavye Kısayolları (WezTerm)

| Windows/Linux | macOS | Açıklama |
|---------------|-------|----------|
| `CTRL+T` | `CMD+T` | Yeni tab aç |
| `CTRL+D` | `CMD+D` | Dikey split |
| `CTRL+SHIFT+D` | `CMD+SHIFT+D` | Yatay split |
| `CTRL+H/J/K/L` | `CMD+H/J/K/L` | Split'ler arası gezinme (Vim tarzı) |
| `CTRL+W` | `CMD+W` | Tab/Pane kapat |
| `CTRL+1/2/3` | `CMD+1/2/3` | İlgili tab'a git |

### Unix-like PowerShell Komutları (Windows)

PowerShell profilimiz sayesinde Windows'ta şu Unix komutlarını kullanabilirsiniz:

```powershell
ls, ll, la      # Dosya listele
cd, .., ...     # Dizin değiştir
mkdir, touch    # Dosya/dizin oluştur
rm, cp, mv      # Dosya işlemleri
cat, head, tail # Dosya içeriği
grep, find      # Arama
which           # Komut yolu
ps, kill        # Process yönetimi
env, export     # Ortam değişkenleri
gs, ga, gc, gp  # Git kısayolları
```

Komut listesi için PowerShell'de `show-aliases` yazın.

---

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

### Neovim & LazyVim
- [LazyVim Dokümantasyonu](https://lazyvim.github.io/)
- [Neovim Dokümantasyonu](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)

### WezTerm
- [WezTerm Resmi Dokümantasyon](https://wezfurlong.org/wezterm/)
- [WezTerm Color Schemes](https://wezfurlong.org/wezterm/colorschemes/)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [PowerShell Dokümantasyonu](https://docs.microsoft.com/en-us/powershell/)
