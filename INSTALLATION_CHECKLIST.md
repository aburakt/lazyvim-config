# ONPREM LazyVim + WezTerm Kurulum Kontrol Listesi

Bu doküman, ONPREM (offline) ortamlarda LazyVim ve WezTerm kurulumu için adım adım kontrol listesi sağlar.

## 📋 Kurulum Öncesi (İnternet Bağlantılı Makine)

### 1. Bundle Hazırlama

- [ ] **prepare-bundle.ps1 script'ini çalıştır**
  ```powershell
  .\prepare-bundle.ps1
  ```
  - [ ] Neovim yüklü olduğundan emin ol
  - [ ] Git yüklü olduğundan emin ol
  - [ ] İnternet bağlantısı aktif
  - [ ] Script'in tamamlanmasını bekle (5-10 dakika)

- [ ] **Bundle oluşturulduğunu doğrula**
  - [ ] `bundle/` klasörü oluştu
  - [ ] `bundle/lazy/` içinde 40+ plugin var
  - [ ] `bundle/mason/packages/` içinde Mason tool'lar var
  - [ ] Toplam boyut: ~1-2 GB

### 2. Installer'ları İndir

`DOWNLOAD_LINKS.md` dosyasındaki linkleri kullanarak:

#### Zorunlu Installer'lar
- [ ] **Neovim** (nvim-win64.msi) - ~30 MB
  - Minimum versiyon: 0.9.0
  - Önerilen: 0.10.0+

- [ ] **Git for Windows** (Git-*-64-bit.exe) - ~50 MB
  - Minimum versiyon: 2.0+

- [ ] **WezTerm** (WezTerm-*-setup.exe) - ~50 MB
  - En son stable versiyon

- [ ] **Nerd Font** (CascadiaCode.zip) - ~20 MB
  - CaskaydiaCove Nerd Font (önerilir)

#### Opsiyonel Installer'lar
- [ ] **PowerShell 7** (PowerShell-*-win-x64.msi) - ~100 MB
  - Gelişmiş terminal özellikleri için

- [ ] **MSYS2** (msys2-x86_64-*.exe) - ~100 MB
  - Bazı plugin'lerin derlenmesi için compiler gerekli

- [ ] **JDK 17+** (jdk-*-windows-x64.msi) - ~150-300 MB
  - Java/Spring Boot development için

### 3. ONPREM Paket Yapısını Oluştur

- [ ] **Klasör yapısı oluştur**
  ```
  lazyvim-onprem-package/
  ├── 1-installers/
  │   ├── neovim/
  │   ├── git/
  │   ├── wezterm/
  │   ├── fonts/
  │   ├── powershell/
  │   ├── compiler/
  │   └── jdk/
  ├── 2-config/
  ├── 3-bundle/
  └── INSTALL_ONPREM.ps1
  ```

- [ ] **Dosyaları kopyala**
  - [ ] Installer'ları ilgili klasörlere yerleştir
  - [ ] Bu repo'yu `2-config/` olarak kopyala
  - [ ] `bundle/` klasörünü `3-bundle/` olarak kopyala
  - [ ] `INSTALL_ONPREM.ps1`'i root'a kopyala

- [ ] **Paket boyutunu kontrol et**
  - Beklenen: 2-4 GB (installer'lara bağlı)

### 4. ONPREM Makineye Taşı

- [ ] **USB veya Network Drive ile kopyala**
  - [ ] Tüm `lazyvim-onprem-package/` klasörünü kopyala
  - [ ] Dosya bütünlüğünü kontrol et (hash check önerilir)

---

## 🖥️ ONPREM Makinede Kurulum

### 5. Sistem Hazırlığı

- [ ] **Windows sürümünü kontrol et**
  - Minimum: Windows 10 1903+
  - Önerilen: Windows 10 22H2 veya Windows 11

- [ ] **PowerShell versiyonunu kontrol et**
  ```powershell
  $PSVersionTable.PSVersion
  ```
  - Minimum: 5.1
  - Önerilen: 7.0+

- [ ] **Yönetici hakları kontrolü**
  - Installer'lar için yönetici hakları gerekebilir

### 6. Kurulum Script'ini Çalıştır

- [ ] **PowerShell'i aç** (sağ tık → "Run as Administrator" önerilir)

- [ ] **Kurulum dizinine git**
  ```powershell
  cd C:\path\to\lazyvim-onprem-package
  ```

- [ ] **Execution Policy'yi kontrol et**
  ```powershell
  Get-ExecutionPolicy -Scope CurrentUser
  ```
  - Eğer "Restricted" ise:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

- [ ] **INSTALL_ONPREM.ps1'i çalıştır**
  ```powershell
  .\INSTALL_ONPREM.ps1
  ```

- [ ] **Script'in tamamlanmasını bekle**
  - Adımları takip et
  - Hataları not et

### 7. Kurulum Adımları (Script İçinde)

#### Adım 1: Sistem Gereksinimleri
- [ ] Neovim yüklü veya yüklenecek
- [ ] Git yüklü veya yüklenecek
- [ ] WezTerm yüklü veya yüklenecek (opsiyonel)

#### Adım 2: Eksik Araçları Yükle
- [ ] Script eksik araçları otomatik yükler
- [ ] Manuel yükleme gerekirse installer'ları çalıştır

#### Adım 3: Bundle Kopyalama
- [ ] `3-bundle/` → `%LOCALAPPDATA%\nvim-data\`
- [ ] 40+ plugin kopyalandı
- [ ] Mason tool'lar kopyalandı

#### Adım 4: LazyVim Config
- [ ] Config → `%LOCALAPPDATA%\nvim\`
- [ ] `init.lua` mevcut
- [ ] `lua/` klasörü mevcut
- [ ] Offline config seçildi (önerilen)

#### Adım 5: WezTerm Config
- [ ] Config → `%USERPROFILE%\.wezterm.lua`
- [ ] Offline mode aktif

#### Adım 6: PowerShell Profil (Opsiyonel)
- [ ] Unix-like komutlar istiyorsan: Evet
- [ ] İstemiyorsan: Hayır

#### Adım 7: Execution Policy
- [ ] "RemoteSigned" olarak ayarlandı

#### Adım 8: Doğrulama
- [ ] verify-onprem.ps1 çalıştırıldı
- [ ] Tüm kontroller başarılı

---

## ✅ Kurulum Sonrası Doğrulama

### 8. Manuel Doğrulama

- [ ] **Neovim'i başlat**
  ```bash
  nvim
  ```
  - [ ] LazyVim açılış ekranı görünüyor
  - [ ] Hata mesajı yok
  - [ ] Plugin'ler yükleniyor (ilk açılış biraz sürebilir)

- [ ] **LazyVim sağlık kontrolü**
  ```vim
  :checkhealth
  ```
  - [ ] Kritik hatalar yok
  - [ ] Uyarılar normal seviyede

- [ ] **Plugin kontrolü**
  ```vim
  :Lazy
  ```
  - [ ] 40+ plugin listede
  - [ ] Tüm plugin'ler "loaded" durumunda

- [ ] **Mason kontrolü**
  ```vim
  :Mason
  ```
  - [ ] LSP server'lar yüklü (lua-language-server, typescript-language-server, vb.)
  - [ ] Formatter'lar yüklü (prettier, stylua)
  - [ ] Internet olmadan çalışıyor

### 9. WezTerm Kontrolü

- [ ] **WezTerm'i başlat**
  ```bash
  wezterm
  ```
  - [ ] Terminal açılıyor
  - [ ] Font doğru görünüyor (Nerd Font icons)
  - [ ] Tema aktif (Tokyo Night Storm)

- [ ] **Klavye kısayolları test et**
  - [ ] `CTRL+T` → Yeni tab açılıyor
  - [ ] `CTRL+D` → Dikey split
  - [ ] `CTRL+W` → Pane/tab kapatma

### 10. PowerShell Profil Kontrolü (Eğer yüklediysen)

- [ ] **Yeni PowerShell penceresi aç**

- [ ] **Unix-like komutları test et**
  ```powershell
  ls          # Dosya listele
  ll          # Detaylı liste
  cat file.txt # Dosya oku
  grep "text" file.txt # Metin ara
  which nvim  # Komut konumu bul
  ```

---

## 🔧 Sorun Giderme Kontrol Listesi

### Plugin'ler Yüklenmiyor

- [ ] `%LOCALAPPDATA%\nvim-data\lazy\` klasörü dolu mu?
- [ ] Bundle doğru kopyalandı mı?
- [ ] `:Lazy sync` komutunu dene

### Mason Tool'lar Eksik

- [ ] `%LOCALAPPDATA%\nvim-data\mason\packages\` klasörü dolu mu?
- [ ] Bundle'da mason tool'lar var mı?
- [ ] `:Mason` açıp manuel yükleme dene (internet gerekir)

### Font İkonları Görünmüyor

- [ ] Nerd Font yüklü mü? (Fonts Settings → CaskaydiaCove Nerd Font)
- [ ] WezTerm config'de font doğru ayarlı mı?
- [ ] Terminal'i yeniden başlat

### PowerShell Profil Hatası

- [ ] Execution Policy "RemoteSigned" mi?
  ```powershell
  Get-ExecutionPolicy -Scope CurrentUser
  ```
- [ ] Profil dosyası doğru konumda mı?
  ```powershell
  $PROFILE
  ```
- [ ] check-profile.ps1 çalıştır

### Offline Mode Çalışmıyor

- [ ] lazy.lua'da `checker.enabled = false` var mı?
- [ ] wezterm.lua'da `check_for_updates = false` var mı?
- [ ] Offline config kullanıldı mı?

---

## 📚 Ek Kaynaklar

### Dokümantasyon
- [ ] `ONPREM_KURULUM.md` - Detaylı kurulum rehberi
- [ ] `BUNDLE_PREPARATION.md` - Bundle hazırlama kılavuzu
- [ ] `PACKAGE_STRUCTURE.md` - Paket yapısı açıklaması
- [ ] `DOWNLOAD_LINKS.md` - İndirme linkleri

### Script'ler
- [ ] `INSTALL_ONPREM.ps1` - Ana kurulum script'i
- [ ] `prepare-bundle.ps1` - Bundle hazırlayıcı
- [ ] `verify-onprem.ps1` - Kurulum doğrulama
- [ ] `verify-install.ps1` - Basit doğrulama

### WezTerm Docs
- [ ] `wezterm/WEZTERM_SETUP.md` - WezTerm kurulum kılavuzu

---

## ✨ Son Kontroller

- [ ] **Tüm araçlar yüklü**
  - Neovim, Git, WezTerm, Font

- [ ] **Config dosyaları yerinde**
  - LazyVim, WezTerm, PowerShell profil

- [ ] **Bundle kopyalandı**
  - Plugin'ler, Mason tools

- [ ] **Offline mode aktif**
  - Auto-update kapalı

- [ ] **Verification başarılı**
  - verify-onprem.ps1 hatasız geçti

- [ ] **Test edildi**
  - Neovim çalışıyor
  - WezTerm çalışıyor
  - LSP server'lar çalışıyor

---

## 🎯 Sonraki Adımlar

Kurulum tamamlandıktan sonra:

1. **LazyVim öğrenmeye başla**
   - `:Tutor` ile Vim temellerini öğren
   - `<leader>` (varsayılan: Space) tuşunu keşfet
   - `:help LazyVim` ile dokümantasyona bak

2. **Kendi konfigürasyonunu özelleştir**
   - `lua/plugins/` altına kendi plugin'lerini ekle
   - `lua/config/keymaps.lua` ile kısayol ekle

3. **Java/Spring Boot development (eğer kullanıyorsan)**
   - `:Mason` ile jdtls kontrolü yap
   - Java dosyası aç ve LSP'yi test et

4. **Git workflow'unu kur**
   - Lazygit kısayolu: `<leader>gg`
   - Git komutları WezTerm'de çalışır

---

## 📝 Notlar

- Bu checklist Windows 10/11 için hazırlanmıştır
- Internet bağlantısı sadece bundle hazırlama aşamasında gerekir
- ONPREM kurulum tamamen offline çalışır
- Tüm dokümantasyon Türkçe ve İngilizce mevcuttur

**Kurulum başarılı olduğunda bu checklist'i kaydet ve referans için sakla!**

İyi çalışmalar! 🚀
