# Java LSP Kurulum Hatası Düzeltme Adımları

## 🔧 Sorun
`jdtls` ve `java-test` Mason'dan kurulmaya çalışıldı, ancak bu paketler **nvim-java** eklentisi tarafından otomatik yönetiliyor. Bu çakışmaya neden oldu.

## ✅ Yapılan Düzeltmeler

1. **Mason konfigürasyonu güncellendi**
   - `jdtls`, `java-test`, `java-debug-adapter` Mason listesinden kaldırıldı
   - Bu paketler artık nvim-java tarafından otomatik kurulacak
   - Sadece `google-java-format` Mason'da kaldı

2. **nvim-java lazy loading eklendi**
   - `ft = { "java" }` parametresi eklendi
   - Java dosyası açıldığında otomatik yüklenecek

3. **Mason registry yapılandırıldı**
   - nvim-java'nın kendi registry'si eklendi
   - Artık jdtls doğru kaynaktan indirilecek

## 🚀 Şimdi Ne Yapmalısın?

### Adım 1: Neovim'i Yeniden Başlat ve Paketleri Senkronize Et

```bash
# 1. Neovim'i aç
nvim

# 2. Neovim içinde (normal mode'da):
:Lazy sync
```

Bu komut:
- Eklentileri güncelleyecek
- nvim-java'yı yükleyecek
- Mason registry'sini yapılandıracak

### Adım 2: Java Dosyası Aç

```bash
# Staffy backend projesinden bir dosya aç
nvim ~/Sites/ib/staffy/backend/src/main/java/com/staffmanagement/StaffManagementApplication.java
```

### Adım 3: nvim-java'nın Otomatik Kurulumunu İzle

Java dosyasını açtığınızda:
1. nvim-java yüklenecek
2. Otomatik olarak **jdtls**, **java-test**, **java-debug-adapter** indirilmeye başlayacak
3. İlk kurulum 2-5 dakika sürebilir
4. Alt kısımda bildirimler göreceksiniz

### Adım 4: Kurulum Durumunu Kontrol Et

Neovim içinde:
```vim
:Mason
```

Mason UI'da şunları görmelisiniz:
- ✅ `google-java-format` (kurulu)
- ✅ `java-debug-adapter` (kurulu)

**NOT:** `jdtls` ve `java-test` Mason UI'da GÖRÜNMEYECEK çünkü nvim-java bunları kendi yönetiyor. Bu normal!

### Adım 5: LSP Durumunu Kontrol Et

Java dosyasındayken:
```vim
:LspInfo
```

Görmek istediğiniz:
```
Client: jdtls (id: 1, bufnr: [X])
  filetypes:       java
  autostart:       true
  root directory:  /Users/aburakt/Sites/ib/staffy/backend
  cmd:             <jdtls komutu>
```

## 🔍 Sorun Giderme

### Eğer hala jdtls başlamıyorsa:

1. **nvim-java loglarını kontrol et:**
   ```vim
   :messages
   ```

2. **LSP loglarını kontrol et:**
   ```vim
   :LspLog
   ```

3. **Mason cache'ini temizle:**
   ```bash
   rm -rf ~/.local/share/nvim/mason
   nvim
   :Lazy sync
   :Mason
   ```

4. **nvim-java data klasörünü kontrol et:**
   ```bash
   ls -la ~/.local/share/nvim/nvim-java/
   ```

   Bu klasörde jdtls binary'leri olmalı.

### Eğer hata mesajları görüyorsan:

**"jdtls not found" hatası:**
- Java dosyasını açtıktan sonra 2-3 dakika bekle
- İlk kurulum sırasında jdtls indiriliyor
- `:messages` ile ilerlemeyi takip et

**"JAVA_HOME not set" hatası:**
```bash
# .zshrc veya .bashrc'ye ekle:
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

## ✨ Beklenen Sonuç

Her şey düzgün çalıştığında:
- Java dosyası açıldığında LSP otomatik başlayacak (2-30 saniye)
- Syntax highlighting çalışacak
- Code completion (autocomplete) çalışacak
- `gd` ile definition'a gidebileceksin
- `K` ile hover documentation görebileceksin
- `<leader>cf` ile kod formatlayabileceksin

## 📝 Yapılan Değişiklikler Özeti

**Değiştirilen dosyalar:**
- `~/.config/nvim/lua/plugins/java.lua` - nvim-java konfigürasyonu
- `~/.config/nvim/lua/plugins/lsp.lua` - Java paketleri kaldırıldı

**Önemli değişiklikler:**
```lua
-- ÖNCE (yanlış):
{
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "jdtls",           -- ❌ Çakışma!
      "java-test",       -- ❌ Çakışma!
      "java-debug-adapter", -- ❌ Çakışma!
    }
  }
}

-- SONRA (doğru):
{
  "nvim-java/nvim-java",
  ft = { "java" },  -- ✅ Java dosyasında lazy load
  config = function()
    require("java").setup({
      java_test = { enable = true },
      java_debug_adapter = { enable = true },
    })
  end
}
```

## 🎯 Test Senaryosu

1. ✅ Backend projesinden bir Java dosyası aç
2. ✅ 30 saniye bekle (LSP başlasın)
3. ✅ `gd` ile bir sınıf/metod tanımına git
4. ✅ `K` ile hover documentation gör
5. ✅ Yazarken autocomplete çalışsın
6. ✅ `<leader>cf` ile kodu formatla

Hepsi çalışıyorsa: **Kurulum başarılı!** 🎉

---

**Hala sorun mu var?** Hata mesajlarını paylaş, birlikte çözelim!
