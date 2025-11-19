# WezTerm Kurulum ve Konfigürasyon Rehberi

Bu rehber, WezTerm terminal emülatörünün kurulumunu ve bu repo'daki konfigürasyonun kullanımını adım adım anlatır. Cross-platform (Windows, macOS, Linux) ve onprem/offline ortamlar için optimize edilmiştir.

## İçindekiler

- [WezTerm Nedir?](#wezterm-nedir)
- [Windows Kurulum](#windows-kurulum)
- [macOS Kurulum](#macos-kurulum)
- [Linux Kurulum](#linux-kurulum)
- [Onprem/Offline Ortamlar](#onpremoffline-ortamlar)
- [Konfigürasyon Özelleştirme](#konfigürasyon-özelleştirme)
- [Sorun Giderme](#sorun-giderme)

---

## WezTerm Nedir?

WezTerm, modern bir GPU-hızlandırmalı terminal emülatörüdür. Öne çıkan özellikleri:

- **Cross-platform**: Windows, macOS, Linux desteği
- **Lua ile konfigürasyon**: Güçlü ve esnek ayarlar
- **GPU hızlandırma**: Yüksek performans
- **Ligature desteği**: Programlama fontları için icon ve bağlı karakter desteği
- **Split ve Tab yönetimi**: Tmux/Screen benzeri özellikler, ek araç gerekmez
- **Multiplexing**: SSH üzerinden bile split ve tab kullanımı

---

## Windows Kurulum

### 1. Ön Gereksinimler

#### a) WezTerm Kurulumu

1. **İnternet erişimi varsa:**
   ```powershell
   # WinGet ile (Windows 10/11)
   winget install wez.wezterm

   # Veya Chocolatey ile
   choco install wezterm
   ```

2. **Manuel kurulum (Onprem ortamlar için):**
   - [WezTerm Releases](https://github.com/wez/wezterm/releases) sayfasından en son `.zip` veya `.msi` dosyasını indirin
   - `.msi` dosyasını çalıştırarak kurulum yapın
   - Veya `.zip` dosyasını bir klasöre çıkarıp `PATH` değişkenine ekleyin

3. **Kurulumu kontrol edin:**
   ```powershell
   wezterm --version
   ```

#### b) PowerShell 7 Kurulumu (Önerilir)

PowerShell 7, daha modern ve Unix benzeri özelliklere sahiptir.

1. **İnternet erişimi varsa:**
   ```powershell
   winget install Microsoft.PowerShell
   ```

2. **Manuel kurulum:**
   - [PowerShell GitHub Releases](https://github.com/PowerShell/PowerShell/releases) sayfasından `.msi` dosyasını indirin
   - Kurulum yapın

3. **Kontrol:**
   ```powershell
   pwsh --version
   ```

> **Not**: PowerShell 7 yoksa, mevcut Windows PowerShell (5.1) de çalışır.

#### c) Nerd Font Kurulumu

WezTerm'de iconlar ve özel karakterler için Nerd Font gereklidir.

1. **Font indirme:**
   - [Nerd Fonts İndirme Sayfası](https://www.nerdfonts.com/font-downloads)
   - Önerilen fontlar:
     - **CaskaydiaCove Nerd Font** (varsayılan config'de kullanılır)
     - **JetBrainsMono Nerd Font**
     - **FiraCode Nerd Font**

2. **Font kurulumu:**
   - İndirilen `.zip` dosyasını açın
   - Tüm `.ttf` veya `.otf` dosyalarını seçin
   - Sağ tıklayın ve **"Tüm kullanıcılar için yükle"** seçeneğini seçin

3. **Alternatif: Scoop ile kurulum (internet varsa)**
   ```powershell
   scoop bucket add nerd-fonts
   scoop install CascadiaCode-NF
   ```

### 2. Konfigürasyon Dosyalarını Yerleştirme

#### a) WezTerm Config

1. **Bu repo'yu klonlayın veya dosyaları indirin:**
   ```powershell
   git clone https://github.com/KULLANICI_ADINIZ/lazyvim-config.git
   cd lazyvim-config
   ```

2. **WezTerm config dosyasını kopyalayın:**
   ```powershell
   # Ana dizine kopyalama (önerilir)
   Copy-Item wezterm/wezterm.lua $env:USERPROFILE\.wezterm.lua

   # Veya .config klasörüne (alternatif)
   New-Item -ItemType Directory -Path $env:USERPROFILE\.config\wezterm -Force
   Copy-Item wezterm/wezterm.lua $env:USERPROFILE\.config\wezterm\wezterm.lua
   ```

#### b) PowerShell Profil Dosyası (Unix-like Komutlar)

1. **PowerShell profil dizinini oluşturun:**
   ```powershell
   # PowerShell 7 için
   $profilePath = "$env:USERPROFILE\Documents\PowerShell"
   New-Item -ItemType Directory -Path $profilePath -Force

   # Windows PowerShell 5.1 için (alternatif)
   $profilePath = "$env:USERPROFILE\Documents\WindowsPowerShell"
   New-Item -ItemType Directory -Path $profilePath -Force
   ```

2. **Profil dosyasını kopyalayın:**
   ```powershell
   Copy-Item wezterm/powershell/Microsoft.PowerShell_profile.ps1 $profilePath\Microsoft.PowerShell_profile.ps1
   ```

3. **Execution Policy ayarlayın** (Yönetici PowerShell'de):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### 3. İlk Çalıştırma ve Test

1. **WezTerm'i başlatın** (Başlat menüsünden veya `wezterm` komutuyla)

2. **PowerShell profilinin yüklendiğini kontrol edin:**
   ```powershell
   # Başlangıç mesajını görmelisiniz: "🚀 PowerShell Unix-like Profil Yüklendi!"

   # Komut listesini görün
   show-aliases
   ```

3. **Unix-like komutları test edin:**
   ```powershell
   ls          # Dosya listele
   ll          # Detaylı liste
   pwd         # Mevcut dizin
   touch test.txt   # Dosya oluştur
   cat test.txt     # Dosya içeriği
   rm test.txt      # Dosya sil
   which git        # Git'in yolunu bul
   ```

4. **WezTerm klavye kısayollarını deneyin:**
   - `CTRL+T`: Yeni tab
   - `CTRL+D`: Dikey split
   - `CTRL+SHIFT+D`: Yatay split
   - `CTRL+H/J/K/L`: Split'ler arası gezinme
   - `CTRL+W`: Tab/Pane kapat

---

## macOS Kurulum

### 1. WezTerm Kurulumu

```bash
# Homebrew ile (önerilir)
brew install --cask wezterm

# Manuel kurulum için
# https://github.com/wez/wezterm/releases adresinden .dmg dosyasını indirin
```

### 2. Nerd Font Kurulumu

```bash
# Homebrew ile
brew tap homebrew/cask-fonts
brew install --cask font-caskaydia-cove-nerd-font

# Veya manuel olarak nerdfonts.com'dan indirin
```

### 3. Konfigürasyon

```bash
# Repo'yu klonlayın
git clone https://github.com/KULLANICI_ADINIZ/lazyvim-config.git
cd lazyvim-config

# Symlink oluşturun (önerilir)
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua

# Veya kopyalayın
cp wezterm/wezterm.lua ~/.wezterm.lua
```

### 4. Test

```bash
# WezTerm'i başlatın
wezterm

# Klavye kısayolları (macOS'ta MOD = CMD)
# CMD+T: Yeni tab
# CMD+D: Dikey split
# CMD+SHIFT+D: Yatay split
```

---

## Linux Kurulum

### 1. WezTerm Kurulumu

**Ubuntu/Debian:**
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm
```

**Fedora:**
```bash
sudo dnf copr enable wezfurlong/wezterm-nightly
sudo dnf install wezterm
```

**Arch:**
```bash
yay -S wezterm
# veya
paru -S wezterm
```

### 2. Nerd Font Kurulumu

```bash
# Ubuntu/Debian
sudo apt install fonts-cascadia-code

# Arch
yay -S ttf-cascadia-code-nerd

# Manuel kurulum
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip
fc-cache -fv
```

### 3. Konfigürasyon

```bash
# Repo'yu klonlayın
git clone https://github.com/KULLANICI_ADINIZ/lazyvim-config.git
cd lazyvim-config

# Symlink oluşturun
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua
```

---

## Onprem/Offline Ortamlar

Kısıtlı internet erişimi olan kurumsal ortamlar için özel talimatlar.

### 1. Offline Kurulum Paketi Hazırlama

İnternet erişimi olan bir bilgisayarda:

```powershell
# 1. WezTerm installer'ı indirin
# https://github.com/wez/wezterm/releases/latest/download/WezTerm-windows-*-setup.exe

# 2. PowerShell 7 installer'ı indirin (opsiyonel)
# https://github.com/PowerShell/PowerShell/releases/latest/download/PowerShell-*-win-x64.msi

# 3. Nerd Font'u indirin
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip

# 4. Bu repo'yu zip olarak indirin
# github.com/KULLANICI_ADINIZ/lazyvim-config/archive/refs/heads/master.zip
```

### 2. Onprem Ortamda Kurulum

1. **USB/ağ sürücüsünden dosyaları kopyalayın**

2. **Kurulumları yapın:**
   ```powershell
   # WezTerm
   .\WezTerm-windows-*-setup.exe

   # PowerShell 7 (opsiyonel)
   .\PowerShell-*-win-x64.msi

   # Nerd Font
   # CascadiaCode.zip dosyasını açın, .ttf dosyalarını "Tüm kullanıcılar için yükle"
   ```

3. **Konfigürasyon dosyalarını yerleştirin:**
   ```powershell
   # Repo'yu USB'den kopyalayın
   Copy-Item -Recurse E:\lazyvim-config C:\Users\$env:USERNAME\

   # WezTerm config
   Copy-Item C:\Users\$env:USERNAME\lazyvim-config\wezterm\wezterm.lua $env:USERPROFILE\.wezterm.lua

   # PowerShell profil
   $profilePath = "$env:USERPROFILE\Documents\PowerShell"
   New-Item -ItemType Directory -Path $profilePath -Force
   Copy-Item C:\Users\$env:USERNAME\lazyvim-config\wezterm\powershell\Microsoft.PowerShell_profile.ps1 $profilePath\
   ```

4. **Otomatik güncelleme kontrolünü kapatın:**

   `.wezterm.lua` dosyasını açın ve şu satırı uncomment edin:
   ```lua
   config.check_for_updates = false
   ```

### 3. PSReadLine Manuel Kurulum (Offline)

PSReadLine modülü genellikle PowerShell ile gelir, ancak yoksa:

1. **İnternet erişimi olan bilgisayarda:**
   ```powershell
   Save-Module -Name PSReadLine -Path C:\PSModules
   ```

2. **Onprem bilgisayarda:**
   ```powershell
   Copy-Item -Recurse C:\PSModules\PSReadLine "$env:USERPROFILE\Documents\PowerShell\Modules\"
   Import-Module PSReadLine
   ```

---

## Konfigürasyon Özelleştirme

### Renk Teması Değiştirme

`.wezterm.lua` dosyasında:

```lua
-- Mevcut: Tokyo Night Storm
config.color_scheme = 'Tokyo Night Storm'

-- Diğer öneriler:
-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Dracula'
-- config.color_scheme = 'Nord'
-- config.color_scheme = 'Gruvbox Dark'
```

Tüm temalar için: [WezTerm Color Schemes](https://wezfurlong.org/wezterm/colorschemes/)

### Font Değiştirme

```lua
-- Mevcut: CaskaydiaCove Nerd Font
config.font = wezterm.font('CaskaydiaCove Nerd Font', {
  weight = 'Regular',
  style = 'Normal',
})

-- JetBrainsMono ile:
config.font = wezterm.font('JetBrainsMono Nerd Font', {
  weight = 'Regular',
  style = 'Normal',
})

-- Font boyutu
config.font_size = 15.0  -- Varsayılan, isteğe göre 12-18 arası değiştirin
```

### Şeffaflık Ayarları

```lua
-- Şeffaflık (0.0 = tamamen şeffaf, 1.0 = opak)
config.window_background_opacity = 0.95

-- Şeffaflığı kapatmak için
config.window_background_opacity = 1.0
```

### PowerShell Prompt Özelleştirme

Daha gelişmiş prompt için `Oh-My-Posh` kullanabilirsiniz:

```powershell
# İnternet varsa
winget install JanDeDobbeleer.OhMyPosh

# PowerShell profiline ekleyin
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
```

---

## Sorun Giderme

### Problem: WezTerm açılmıyor veya hata veriyor

**Çözüm:**
```powershell
# Config dosyasını syntax kontrol et
wezterm --config-file $env:USERPROFILE\.wezterm.lua ls-fonts

# Hata varsa, config dosyasını yeniden indirin/kopyalayın
```

### Problem: PowerShell profili yüklenmiyor

**Çözüm:**
```powershell
# Profil dosyasının varlığını kontrol edin
Test-Path $PROFILE
Get-Content $PROFILE

# Execution Policy'yi kontrol edin
Get-ExecutionPolicy

# RemoteSigned olmalı
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Profili manuel yükleyin
. $PROFILE
```

### Problem: Unix komutları çalışmıyor (Windows)

**Çözüm:**
```powershell
# PowerShell profilinin doğru yere kopyalandığından emin olun
$PROFILE  # Bu komut profil dosyasının konumunu gösterir

# Dosya orada mı?
Test-Path $PROFILE

# Yoksa, yeniden kopyalayın
Copy-Item wezterm/powershell/Microsoft.PowerShell_profile.ps1 $PROFILE
```

### Problem: Fontlar düzgün görünmüyor, iconlar bozuk

**Çözüm:**
1. Nerd Font'un doğru kurulduğundan emin olun
2. WezTerm'i tamamen kapatıp yeniden açın
3. Config'de font adını kontrol edin:
   ```lua
   config.font = wezterm.font('CaskaydiaCove Nerd Font')
   ```
4. Yüklü fontları listeleyin:
   ```powershell
   wezterm ls-fonts --list-system
   ```

### Problem: Split'ler veya tab'ler doğru çalışmıyor

**Çözüm:**
- Klavye kısayollarını kontrol edin
- Windows'ta `CTRL`, macOS'ta `CMD` kullanın
- Config'de `keys` bölümüne bakın

### Problem: WezTerm yavaş çalışıyor (Windows)

**Çözüm:**
```lua
-- GPU backend'i değiştirin (.wezterm.lua dosyasında)
config.front_end = 'OpenGL'  -- Varsayılan: WebGpu

-- Animasyonları kapatın
config.animation_fps = 1
```

### Problem: Onprem ortamda güncelleme hatası

**Çözüm:**
```lua
-- .wezterm.lua dosyasında otomatik güncellemeyi kapatın
config.check_for_updates = false
```

---

## Klavye Kısayolları Özeti

### Windows/Linux (MOD = CTRL)

| Kısayol | Açıklama |
|---------|----------|
| `CTRL+T` | Yeni tab aç |
| `CTRL+W` | Tab/Pane kapat |
| `CTRL+1/2/3` | İlgili tab'a git |
| `CTRL+[` / `]` | Önceki/sonraki tab |
| `CTRL+D` | Dikey split |
| `CTRL+SHIFT+D` | Yatay split |
| `CTRL+H/J/K/L` | Split'ler arası gezin |
| `CTRL+Q` | Aktif pane'i kapat |
| `CTRL+SHIFT+F` | Pane'i tam ekran |
| `CTRL+=` / `-` | Font büyüt/küçült |
| `CTRL+0` | Font boyutu sıfırla |
| `CTRL+P` | Komut paleti |

### macOS (MOD = CMD)

Yukarıdaki kısayollarda `CTRL` yerine `CMD` kullanın.

---

## Ek Kaynaklar

- [WezTerm Resmi Dokümantasyon](https://wezfurlong.org/wezterm/)
- [Lua Programlama Dili](https://learnxinyminutes.com/docs/lua/)
- [PowerShell Dokümantasyonu](https://docs.microsoft.com/en-us/powershell/)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Oh-My-Posh](https://ohmyposh.dev/) (PowerShell tema motoru)

---

## Katkıda Bulunma

Bu konfigürasyon dosyaları açık kaynaklıdır. Önerilerinizi issue açarak veya pull request göndererek paylaşabilirsiniz.

## Lisans

MIT License - Detaylar için ana repo'daki `LICENSE` dosyasına bakın.
