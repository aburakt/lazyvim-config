# Minimal Neovim & WezTerm Konfigürasyonu

Bu repo, kişisel, sadeleştirilmiş ve performans odaklı **Neovim** ve **WezTerm** konfigürasyonlarımı içerir. Karmaşık framework'lerden arındırılmış, tek dosya (`init.lua`) tabanlı bir Neovim yapısı ve minimal bir terminal deneyimi sunar.

## 🚀 Neovim Kurulumu

Eski `LazyVim` yapısı yerine, tüm ayarların ve eklentilerin tek bir `init.lua` dosyasında toplandığı, yönetimi kolay bir yapıya geçildi.

### Özellikler
- **Hız & Performans:** Gereksiz eklentiler kaldırıldı.
- **LSP (Language Server):** `nvim-lspconfig` ve `mason` ile otomatik dil sunucusu yönetimi (Lua, TS, Vue, Java, vb.).
- **Otomatik Tamamlama:** `nvim-cmp` ile hızlı ve akıllı kod tamamlama.
- **Dosya Gezgini:** `neo-tree.nvim` ile modern dosya ağacı.
- **Terminal:** `toggleterm.nvim` ile entegre `lazygit` ve `lazydocker`.
- **Tema:** `github-nvim-theme` (Transparent mod aktif).

### Kurulum

Mevcut Neovim konfigürasyonunuzu yedekledikten sonra:

```bash
# Linux / macOS
git clone https://github.com/KULLANICI_ADI/lazyvim-config.git ~/.config/nvim
```

### Önemli Kısayollar (Leader: Space)

| Tuş Kombinasyonu | İşlev |
|------------------|-------|
| `<Space> f` | Dosya Ara (Telescope) |
| `<Space> g` | Metin Ara (Grep) |
| `<Space> e` | Dosya Ağacını Aç/Kapa (NeoTree) |
| `<Space> gg` | Lazygit |
| `<Space> dd` | Lazydocker |
| `gd` | Tanıma Git (Go to Definition) |
| `K` | Dökümantasyonu Gör (Hover) |
| `<Space> ca` | Hata Düzeltme (Code Action) |
| `<Space> r` | Yeniden Adlandır (Rename) |

---

## 🖥️ WezTerm Kurulumu

Göz yormayan, şeffaf ve bulanıklık (blur) efektli, sekmesiz (tabless) minimal terminal yapılandırması.

### Özellikler
- **Görünüm:** Özel koyu mavi tema, %80 opaklık ve blur efekti.
- **Font:** CaskaydiaCove Nerd Font.
- **Minimalizm:** Tab bar kapatıldı, sadece içerik odaklı.

### Kurulum

`wezterm/wezterm.lua` dosyasını home dizininize `.wezterm.lua` olarak kopyalayın veya symlink oluşturun.

```bash
# macOS / Linux
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua
```

### Kısayollar

| Tuş Kombinasyonu | İşlev |
|------------------|-------|
| `Cmd + d` | Ekranı Yatay Böl (Split Horizontal) |
| `Cmd + Shift + d` | Ekranı Dikey Böl (Split Vertical) |
| `Cmd + Opt + Oklar` | Pencereler Arası Geçiş |
| `Cmd + Ctrl + Oklar` | Pencere Boyutlandırma |

---

## Lisans
Bu proje MIT lisansı ile lisanslanmıştır.