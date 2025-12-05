local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.colors = {
        foreground = "#CBE0F0",
        background = "#011423",
        cursor_bg = "#47FF9C",
        cursor_border = "#47FF9C",
        cursor_fg = "#011423",
        selection_bg = "#033259",
        selection_fg = "#CBE0F0",
        ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
        brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.native_macos_fullscreen_mode = false
config.enable_tab_bar = false

config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14

-- GÖRSEL AYARLAR: Pasif pencereleri karart
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.5, -- Pasif olanlar %50 daha karanlık olacak
}

-- KISAYOL TUŞLARI
config.keys = {
    -- 1. Ekranı Bölme
    { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },

    -- 2. Pencereler Arası Gezinti (Cmd + Option + Oklar)
    { key = "LeftArrow", mods = "CMD|OPT", action = wezterm.action.ActivatePaneDirection "Left" },
    { key = "RightArrow", mods = "CMD|OPT", action = wezterm.action.ActivatePaneDirection "Right" },
    { key = "UpArrow", mods = "CMD|OPT", action = wezterm.action.ActivatePaneDirection "Up" },
    { key = "DownArrow", mods = "CMD|OPT", action = wezterm.action.ActivatePaneDirection "Down" },

    -- 3. Pencere Boyutlandırma (Cmd + Ctrl + Oklar)
    { key = "LeftArrow", mods = "CMD|CTRL", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
    { key = "RightArrow", mods = "CMD|CTRL", action = wezterm.action.AdjustPaneSize { "Right", 5 } },
    { key = "UpArrow", mods = "CMD|CTRL", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
    { key = "DownArrow", mods = "CMD|CTRL", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
}

return config