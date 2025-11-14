-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader key (already set by LazyVim but being explicit)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Senin tercihlerine göre ek ayarlar
vim.opt.relativenumber = true -- Göreceli satır numaraları
vim.opt.wrap = false -- Satır kaydırma kapalı
vim.opt.swapfile = false -- Swap dosyası oluşturma
vim.opt.timeoutlen = 300 -- Which-key için bekleme süresi (kısalt)

-- Dışarıdan değişen dosyaları otomatik oku
vim.opt.autoread = true

-- Focus değiştiğinde dosyaları kontrol et
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
  desc = "Check if buffer changed outside of Neovim",
})
