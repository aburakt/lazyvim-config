-- ONPREM/Offline optimized lazy.nvim configuration
-- This version disables auto-updates and assumes all plugins are pre-bundled

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- In ONPREM environment, lazy.nvim should be pre-bundled
  -- If you see this error, make sure you copied the nvim-data bundle correctly
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.api.nvim_echo({
    { "lazy.nvim not found in " .. lazypath .. "\n", "ErrorMsg" },
    { "ONPREM MODE: lazy.nvim should be pre-bundled.\n", "WarningMsg" },
    { "Please ensure nvim-data bundle was copied correctly.\n", "WarningMsg" },
    { "\nIf you have internet access, attempting to clone...\n", "WarningMsg" },
  }, true, {})

  -- Attempt to clone (will fail in fully offline environment)
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim (expected in offline mode):\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import LazyVim extras
    { import = "plugins.extras" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = false, -- ONPREM: Disable automatic update checks
    notify = false, -- ONPREM: Disable update notifications
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  -- ONPREM: Disable git operations for plugin management
  git = {
    timeout = 10, -- Reduced timeout for offline environment
  },
  ui = {
    border = "rounded",
  },
})

-- ONPREM Notice
vim.notify("ONPREM Mode: Auto-updates disabled. All plugins should be pre-bundled.", vim.log.levels.INFO)
