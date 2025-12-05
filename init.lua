
-- ============================================
-- MİNİMAL NEOVİM KURULUMU (GELİŞMİŞ LSP)
-- ============================================

-- TEMEL AYARLAR
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.cursorline = true

-- TEMEL KISA TUŞLAR
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Kaydet" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Çık" })

-- PLUGIN MANAGER (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- LSP KONFİGÜRASYONU VE KISAYOLLAR
-- ============================================

-- Hata mesajlarının görünümü (Simgeler)
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- LSP Bağlandığında Çalışacak Tuşlar
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    
    -- EN ÖNEMLİ TUŞLAR:
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)           -- Dökümantasyonu Görüntüle (Hover)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)     -- Tanıma Git (Go Definition)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Hata Detayını Gör
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)  -- Otomatik Düzeltme (Code Action)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)   -- Sonraki Hataya Git
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)   -- Önceki Hataya Git
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)  -- Yeniden Adlandır (Rename)
  end,
})

-- PLUGINLER
require("lazy").setup({
  -- TEMA
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
          styles = { sidebars = "transparent", floats = "transparent" },
        },
      })
      vim.cmd([[colorscheme github_dark_default]])
    end,
  },

  -- TOGGLETERM (Lazygit & Lazydocker)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = { border = "curved", width = 130, height = 30 }
      })
      local Terminal = require("toggleterm.terminal").Terminal
      
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, {desc = "Lazygit"})
      
      local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true })
      vim.keymap.set("n", "<leader>dd", function() lazydocker:toggle() end, {desc = "Lazydocker"})
    end
  },

  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Dosya Bul" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Metin Ara" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Açık Dosyalar" },
    },
  },

  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "python", "java", "html", "css", "vue" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP CONFIG
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "vue_ls" },
      })
      
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      require("lspconfig").lua_ls.setup({ capabilities = capabilities })
      require("lspconfig").ts_ls.setup({ capabilities = capabilities })
      require("lspconfig").vue_ls.setup({ capabilities = capabilities })
    end,
  },

  -- AUTOCOMPLETION (CMP)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Dosya Ağacı" } },
    config = function()
      require("neo-tree").setup({ filesystem = { follow_current_file = { enabled = true } } })
    end,
  },

  -- EXTRAS
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "numToStr/Comment.nvim", config = true },
  { "nvim-lualine/lualine.nvim", config = function() require("lualine").setup({ options = { theme = "auto" } }) end },
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
}, { ui = { border = "rounded" } })

-- ============================================
-- KISAYOL ÖZETİ
-- ============================================
-- K           = İmleçteki kodun dökümanını oku (Hover)
-- Space + d   = Hata detayını pencerede gör
-- ]d          = Sonraki hataya git
-- [d          = Önceki hataya git
-- gd          = Tanıma git (Go Definition)
-- Space + ca  = Hata düzeltme önerileri (Code Action)
-- Space + r   = Değişken adını her yerde değiştir (Rename)
-- ============================================
