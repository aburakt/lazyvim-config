# Java & Spring Boot için LazyVim Konfigürasyonu

## 📦 Kurulu Bağımlılıklar

### Sistem Gereksinimleri
- ✅ **Java 17** (OpenJDK Temurin)
- ✅ **Maven 3.9.11** - Dependency management
- ✅ **Gradle 9.2.0** - Build tool alternative

### LazyVim Eklentileri
Aşağıdaki dosyalar oluşturuldu/güncellendi:

1. **`lua/plugins/extras.lua`** - LazyVim Java desteği eklendi
2. **`lua/plugins/java.lua`** - nvim-java ile tam Java LSP desteği
3. **`lua/plugins/spring-boot.lua`** - Spring Boot özel ayarları
4. **`lua/plugins/java-dap.lua`** - Debugging (DAP) konfigürasyonu
5. **`lua/plugins/lsp.lua`** - Java LSP ve formatter/linter eklendi
6. **`lua/config/keymaps.lua`** - Java özel keybindings

### Mason Paketleri (Otomatik Kurulacak)
LazyVim'i açtığınızda Mason otomatik olarak şunları kuracak:
- `jdtls` - Java Language Server
- `java-debug-adapter` - Java debugging desteği
- `java-test` - Test runner
- `google-java-format` - Code formatter
- `checkstyle` - Java linter

## 🚀 Kullanım

### İlk Açılış
1. Neovim'i açın: `nvim`
2. Mason otomatik olarak gerekli paketleri kuracak
3. İlk kurulum birkaç dakika sürebilir

### Java Projesi Açma
```bash
# Maven projesi
cd your-spring-boot-project
nvim src/main/java/com/example/Application.java

# Gradle projesi
cd your-gradle-project
nvim src/main/java/com/example/Application.java
```

### Otomatik Tamamlama ve LSP Özellikleri
- **Kod tamamlama**: Yazarken otomatik
- **Import organize et**: `<leader>co` (code organize)
- **Format kod**: `<leader>cf` (code format) - google-java-format kullanır
- **Hata göster**: Satır numarasının yanında otomatik
- **Hover documentation**: `K` tuşu
- **Go to definition**: `gd`
- **Find references**: `gr`
- **Rename symbol**: `<leader>cr`

## ⌨️  Java Özel Keybindings

### Test Komutları
| Komut | Açıklama |
|-------|----------|
| `<leader>cJt` | Test class'ını çalıştır |
| `<leader>cJT` | Test class'ını debug et |
| `<leader>cJm` | Mevcut test metodunu çalıştır |
| `<leader>cJM` | Mevcut test metodunu debug et |

### Refactoring
| Komut | Açıklama |
|-------|----------|
| `<leader>cJv` | Extract Variable |
| `<leader>cJc` | Extract Constant |
| `<leader>cJm` | Extract Method (visual mode'da) |

### Spring Boot Komutları
| Komut | Açıklama |
|-------|----------|
| `<leader>cJs` | Spring Boot uygulamasını çalıştır (Maven) |
| `<leader>cJb` | Maven ile build et (`mvn clean install`) |
| `<leader>cJg` | Gradle ile çalıştır (`gradle bootRun`) |

## 🐛 Debugging (DAP)

### Debugging Keybindings
| Komut | Açıklama |
|-------|----------|
| `<leader>db` | Breakpoint ekle/kaldır |
| `<leader>dB` | Koşullu breakpoint |
| `<leader>dc` | Debug'ı devam ettir |
| `<leader>dC` | Cursor'a kadar çalıştır |
| `<leader>di` | Step Into |
| `<leader>do` | Step Over |
| `<leader>dg` | Step Out |
| `<leader>dt` | Debug'ı sonlandır |
| `<leader>du` | DAP UI'ı aç/kapat |
| `<leader>dr` | REPL'i aç/kapat |

### Debugging Nasıl Yapılır
1. Java dosyasını aç
2. Breakpoint ekle: `<leader>db`
3. Test veya uygulama debug mode'da çalıştır: `<leader>cJT` veya `<leader>cJM`
4. DAP UI otomatik açılacak
5. Step over/into ile ilerle
6. Variables, watches, console pencerelerini kullan

## 📁 Spring Boot Özellikleri

### Desteklenen Dosya Tipleri
- ✅ `application.properties` / `application.yml` - Schema validation
- ✅ `pom.xml` - Maven auto-format (2 space indent)
- ✅ `build.gradle` / `build.gradle.kts` - Gradle syntax
- ✅ Java source files - Tam LSP desteği
- ✅ Test files (JUnit, TestNG, etc.)

### Spring Boot Schema Support
`application.yml` ve `application.properties` dosyalarında otomatik tamamlama ve validation:
- Spring Boot configuration properties
- Bootstrap configuration
- Profile-specific configs (`application-dev.yml`, etc.)

## 🔧 Manuel Kurulum Gereksinimleri

Eğer LazyVim paketleri otomatik kurulmadıysa:

```bash
# Neovim içinde
:Lazy sync
:Mason

# Mason UI içinde:
# - jdtls
# - java-debug-adapter
# - java-test
# - google-java-format
# - checkstyle
# paketlerini manuel kurun (i tuşu ile install)
```

## 🧪 Test Etme

Basit bir test dosyası oluşturup deneyin:

```bash
mkdir -p ~/test-java/src/main/java/com/example
cd ~/test-java

# HelloWorld.java oluştur
cat > src/main/java/com/example/HelloWorld.java << 'EOF'
package com.example;

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Spring Boot with LazyVim!");
    }
}
EOF

# Neovim ile aç
nvim src/main/java/com/example/HelloWorld.java
```

Dosyayı açtığınızda:
- LSP otomatik başlamalı (alt kısımda "jdtls" göreceksiniz)
- Syntax highlighting çalışmalı
- `K` tuşuna basarak hover documentation görebilmelisiniz
- `<leader>cf` ile kod formatlanmalı

## 🔍 Sorun Giderme

### LSP başlamıyor
```vim
:LspInfo       " LSP durumunu kontrol et
:LspLog        " LSP loglarını görüntüle
:Mason         " Mason UI'ı aç, paketleri kontrol et
```

### Formatter çalışmıyor
```vim
:Mason         " google-java-format kurulu mu kontrol et
:ConformInfo   " Formatter durumunu kontrol et
```

### DAP çalışmıyor
```vim
:DapInfo                    " DAP durumunu kontrol et
:checkhealth nvim-dap       " DAP health check
```

## 📚 Ek Öneriler

### SDKMAN ile Farklı JDK Versiyonları
```bash
# SDKMAN kurulumu (opsiyonel)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Farklı JDK versiyonları
sdk install java 11.0.20-tem
sdk install java 17.0.8-tem
sdk install java 21.0.0-tem
sdk use java 17.0.8-tem
```

### Spring Initializr ile Yeni Proje
```bash
# Web UI: https://start.spring.io/
# Veya Maven ile:
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-spring-app \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DinteractiveMode=false
```

## ✨ Özellikler

- ✅ Akıllı kod tamamlama (LSP)
- ✅ Otomatik import organize
- ✅ Google Java Format ile formatting
- ✅ Checkstyle ile linting
- ✅ Debugging desteği (breakpoints, step through, etc.)
- ✅ Test running ve debugging
- ✅ Refactoring araçları
- ✅ Spring Boot özel desteği
- ✅ Maven ve Gradle entegrasyonu
- ✅ Lombok desteği
- ✅ Multi-module project desteği

## 📖 Daha Fazla Bilgi

- LazyVim Docs: https://www.lazyvim.org/
- nvim-java: https://github.com/nvim-java/nvim-java
- Spring Boot: https://spring.io/projects/spring-boot
- JDTLS: https://github.com/eclipse-jdt/eclipse.jdt.ls

---

**Not**: İlk açılışta LSP'nin başlaması birkaç saniye sürebilir. Gradle/Maven bağımlılıklarını indirirken ilk seferde daha uzun sürebilir.
