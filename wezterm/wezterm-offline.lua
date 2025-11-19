-- WezTerm Konfigürasyon Dosyası (ONPREM/Offline Optimized)
-- Bu dosya ONPREM ortamlar için optimize edilmiştir
-- Otomatik güncellemeler ve internet gerektiren özellikler kapatılmıştır

-- WezTerm API'sini yükle
local wezterm = require('wezterm')

-- Konfigürasyon objesi oluştur
local config = {}

-- Yeni versiyon uyumluluğu için config_builder kullan (önerilir)
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================================
-- 🖥️  PLATFORM ALGILAMA (Cross-Platform Support)
-- ============================================================================

-- Platform algılama: macOS, Windows veya Linux
local is_macos = wezterm.target_triple:find("darwin") ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- Modifier tuşu: macOS'ta CMD, Windows/Linux'ta CTRL
local mod = is_macos and 'CMD' or 'CTRL'

-- ============================================================================
-- 🎨 GÖRÜNÜM AYARLARI
-- ============================================================================

-- Renk Teması
-- Tokyo Night Storm - modern, göz yormayan, LazyVim ile uyumlu
-- Diğer temalar: 'Catppuccin Mocha', 'Dracula', 'Nord'
config.color_scheme = 'Tokyo Night Storm'

-- Arka Plan Şeffaflığı
-- 0.0 = tamamen şeffaf, 1.0 = tamamen opak
-- 0.95 hafif bir şeffaflık verir, dikkat dağıtmaz
config.window_background_opacity = 0.95

-- Blur Efekti (sadece macOS)
-- Arka plandaki pencereler bulanık görünür
if is_macos then
  config.macos_window_background_blur = 20
end

-- Windows için Acrylic efekti (opsiyonel)
if is_windows then
  config.win32_system_backdrop = 'Acrylic'
end

-- Pencere Padding (İç Boşluk)
-- Yazıların kenarlara yapışmaması için boşluk bırakır
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- ============================================================================
-- 🔤 FONT AYARLARI
-- ============================================================================

-- Ana Font
-- CaskaydiaCove Nerd Font - programlama için optimize, icon desteği var
config.font = wezterm.font('CaskaydiaCove Nerd Font', {
  weight = 'Regular',        -- Normal kalınlık
  style = 'Normal',          -- İtalik değil
})

-- Font Boyutu
-- 14-16 arası okunabilir, tercihe göre değiştirilebilir
config.font_size = 15.0

-- Font Ligatures (Bağlı Karakterler)
-- => != >= gibi sembolleri güzel gösterir
-- "Half" = sadece belirli kombinasyonlar, "None" = kapalı
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Satır Yüksekliği
-- 1.2 = %20 daha fazla boşluk, okunabilirliği artırır
config.line_height = 1.2

-- ============================================================================
-- 📑 TAB BAR (ÜST MENÜ) AYARLARI
-- ============================================================================

-- Tab Bar'ı Göster
-- Her zaman görünür, hangi tab'de olduğunu görebilirsin
config.enable_tab_bar = true

-- Tab Bar Stili
-- "fancy" = modern görünüm, "retro" = klasik görünüm
config.use_fancy_tab_bar = true

-- Tab Bar Pozisyonu
-- Üstte dursun (iTerm gibi)
config.tab_bar_at_bottom = false

-- Tab'de Kapatma Butonu Göster
-- Sağ üstteki X butonu, fareyle kapatmak için
config.show_tab_index_in_tab_bar = false

-- Yeni Tab Butonu Göster
config.show_new_tab_button_in_tab_bar = true

-- Tab Maksimum Genişliği
config.tab_max_width = 32

-- ============================================================================
-- ⌨️  KLAVYE KISAYOLLARI (KEYBINDINGS)
-- ============================================================================

config.keys = {
  -- TAB YÖNETİMİ
  -- MOD+T: Yeni tab aç (macOS: CMD+T, Windows: CTRL+T)
  {
    key = 't',
    mods = mod,
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },

  -- MOD+W: Aktif pane'i kapat (split varsa split'i, yoksa tab'ı kapat)
  {
    key = 'w',
    mods = mod,
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- MOD+1,2,3...: Tab'ler arası hızlı geçiş
  -- MOD+1 = ilk tab, MOD+2 = ikinci tab, vs.
  {
    key = '1',
    mods = mod,
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = '2',
    mods = mod,
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = '3',
    mods = mod,
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = '4',
    mods = mod,
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = '5',
    mods = mod,
    action = wezterm.action.ActivateTab(4),
  },

  -- MOD+] / MOD+[: Sağa/sola tab geçişi
  {
    key = ']',
    mods = mod,
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = '[',
    mods = mod,
    action = wezterm.action.ActivateTabRelative(-1),
  },

  -- SPLIT (BÖLME) YÖNETİMİ
  -- MOD+D: Dikey split (Vim'deki :vsplit gibi)
  -- Pencereyi sağ-sol böler
  {
    key = 'd',
    mods = mod,
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- MOD+SHIFT+D: Yatay split (Vim'deki :split gibi)
  -- Pencereyi üst-alt böler
  {
    key = 'D',
    mods = mod .. '|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- MOD+H/J/K/L: Vim tarzı split navigasyonu
  -- h=sol, j=aşağı, k=yukarı, l=sağ (Vim kullanıcıları için tanıdık)
  {
    key = 'h',
    mods = mod,
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = mod,
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = mod,
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = mod,
    action = wezterm.action.ActivatePaneDirection 'Right',
  },

  -- MOD+Q: Aktif pane'i kapat (tab değil, sadece split'i kapat)
  {
    key = 'q',
    mods = mod,
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- ZOOM VE BOYUTLANDIRMA
  -- MOD+SHIFT+F: Aktif pane'i tam ekran yap (toggle)
  {
    key = 'F',
    mods = mod .. '|SHIFT',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- MOD + / MOD -: Font boyutunu büyüt/küçült
  {
    key = '=',
    mods = mod,
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = mod,
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = mod,
    action = wezterm.action.ResetFontSize,
  },

  -- LAUNCHER
  -- MOD+P: Hızlı komut paleti (VSCode'daki CMD/CTRL+P gibi)
  {
    key = 'p',
    mods = mod,
    action = wezterm.action.ActivateCommandPalette,
  },

  -- COPY/PASTE
  -- MOD+C ve MOD+V zaten default olarak çalışır, ekstra tanımlama gerekmez
}

-- ============================================================================
-- 🎯 GELIŞMIŞ AYARLAR
-- ============================================================================

-- Scrollback Buffer (Yukarı kaydırma limiti)
-- 10000 satır geçmişi saklar (varsayılan 3500)
config.scrollback_lines = 10000

-- Fareyle Metin Seçimi
-- Otomatik kopyalama kapalı (iTerm'den farklı)
config.selection_word_boundary = ' \t\n{}[]()"\':;,│'

-- Cursor (İmleç) Stili
-- "SteadyBlock" = sabit kare, "BlinkingBlock" = yanıp sönen kare
-- "SteadyBar" = sabit çizgi, "BlinkingBar" = yanıp sönen çizgi
config.default_cursor_style = 'BlinkingBlock'

-- Cursor Yanıp Sönme Hızı
config.cursor_blink_rate = 500  -- milisaniye

-- Pencere Başlangıç Boyutu
config.initial_cols = 140  -- Genişlik (karakter sayısı)
config.initial_rows = 40   -- Yükseklik (satır sayısı)

-- Pencere Başlığında Ne Gösterilsin
-- "$(window):$(pane)" format: tab adı ve aktif program
config.window_frame = {
  font = wezterm.font('CaskaydiaCove Nerd Font', { weight = 'Bold' }),
  font_size = 13.0,
}

-- Pencere Kapatma Onayı
-- Hala çalışan process varsa onay iste
config.window_close_confirmation = 'AlwaysPrompt'

-- Native Tam Ekran (sadece macOS)
-- "true" = macOS'un native tam ekran, "false" = borderless tam ekran
if is_macos then
  config.native_macos_fullscreen_mode = false
end

-- ============================================================================
-- 🌐 ONPREM / OFFLINE ORTAM AYARLARI
-- ============================================================================

-- ONPREM: Otomatik güncelleme kontrolünü kapat
config.check_for_updates = false

-- ONPREM Notice: İlk açılışta kullanıcıya bilgi ver
wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('WezTerm ONPREM Mode',
    'Auto-updates disabled. Running in offline mode.',
    nil, 3000)
end)

-- ============================================================================
-- 📱 TAB İSİMLENDİRME (CUSTOM TAB FORMAT)
-- ============================================================================

-- Tab başlıklarını özelleştir
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title

  -- Eğer tab'de bir dizin çalışıyorsa, dizin adını göster
  if title:find('bash') or title:find('zsh') or title:find('fish') or title:find('pwsh') or title:find('powershell') then
    local cwd = pane.current_working_dir
    if cwd then
      title = cwd.file_path:match("([^/\\]+)[/\\]?$") or title
    end
  end

  -- Tab numarası + başlık
  return {
    { Text = ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' ' },
  }
end)

-- ============================================================================
-- 🚀 PERFORMANS VE DENEYSEL ÖZELLIKLER
-- ============================================================================

-- GPU Hızlandırma
-- WezTerm varsayılan olarak GPU kullanır, bu ayar açık
config.front_end = 'WebGpu'  -- "WebGpu" veya "OpenGL"

-- Animasyonları devre dışı bırak (opsiyonel, performans için)
-- config.animation_fps = 1

-- ============================================================================
-- 💻 WINDOWS POWERSHELL AYARLARI
-- ============================================================================

-- Windows'ta varsayılan shell olarak PowerShell'i ayarla
if is_windows then
  -- PowerShell 7 (pwsh.exe) kullan
  -- PowerShell 7 yüklü değilse, Windows PowerShell'e fallback olacak
  config.default_prog = { 'pwsh.exe', '-NoLogo' }

  -- Windows'ta Nerd Font rendering iyileştirmesi
  config.freetype_load_target = 'Normal'
  config.freetype_render_target = 'HorizontalLcd'

  -- Windows Terminal benzeri görünüm
  config.use_fancy_tab_bar = true

  -- Windows'ta fare tekerleği hassasiyeti
  config.alternate_buffer_wheel_scroll_speed = 3
end

-- ============================================================================
-- 🎓 ÖĞRENME NOTLARI
-- ============================================================================

--[[

  ONPREM/OFFLINE MODE:
  Bu WezTerm konfigürasyonu ONPREM ortamlar için optimize edilmiştir:
  - Otomatik güncelleme kontrolleri devre dışı
  - Tüm özellikler offline çalışır
  - İnternet bağlantısı gerektirmez

  HIZLI BAŞLANGIÇ KLAVYE KISAYOLLARI:
  MOD = macOS'ta CMD, Windows/Linux'ta CTRL

  Tab Yönetimi:
    MOD+T          → Yeni tab aç
    MOD+W          → Pane/Tab'ı kapat (split varsa split, yoksa tab)
    MOD+1/2/3      → İlgili tab'a git
    MOD+[ / ]      → Önceki/sonraki tab

  Split (Bölme):
    MOD+D          → Dikey split (yan yana)
    MOD+SHIFT+D    → Yatay split (üst-alt)
    MOD+H/J/K/L    → Split'ler arası gezin (Vim tarzı)
    MOD+Q          → Aktif split'i kapat
    MOD+SHIFT+F    → Split'i tam ekran yap

  Görünüm:
    MOD+= / -      → Font büyüt/küçült
    MOD+0          → Font boyutunu sıfırla
    MOD+P          → Komut paleti

  CROSS-PLATFORM KULLANIM:
  - Bu config dosyası macOS, Windows ve Linux'ta çalışır
  - Modifier tuşu otomatik algılanır (macOS: CMD, Windows/Linux: CTRL)

  WINDOWS'TA CONFIG DOSYASI KONUMU:
  - %USERPROFILE%\.wezterm.lua (C:\Users\YourName\.wezterm.lua)

]]

-- ============================================================================

-- Konfigürasyonu döndür (Lua'da fonksiyon return eder)
return config
