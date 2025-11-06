-- LSP Configuration - Senin Projelerine Özel
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Astro (astro-test, expertup/fibro)
        astro = {},

        -- Vue 2/3 (tfr-starter-frontend)
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },

        -- Docker (astro-test has docker-compose)
        dockerls = {},
        docker_compose_language_service = {},

        -- YAML (docker-compose, config files)
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },

        -- CSS/PostCSS (Tailwind projelerinde)
        cssls = {},

        -- Emmet (HTML/JSX/Vue)
        emmet_ls = {
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "vue",
          },
        },
      },
    },
  },

  -- Mason için otomatik kurulum
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language Servers
        "typescript-language-server",
        "astro-language-server",
        "vue-language-server",
        "tailwindcss-language-server",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "yaml-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "emmet-ls",

        -- Formatters
        "prettier",
        "stylua",

        -- Linters
        "eslint_d",
      },
    },
  },
}
