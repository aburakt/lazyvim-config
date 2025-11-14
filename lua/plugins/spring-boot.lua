-- Spring Boot Specific Configuration
return {
  -- Java formatter (google-java-format)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "google-java-format",
      })
    end,
  },

  -- Formatting için conform.nvim ayarları
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },

  -- Spring Boot LSP uzantıları
  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "ibhagwan/fzf-lua",
    },
  },

  -- YAML için Spring Boot desteği (application.yml, application.properties)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                -- Spring Boot configuration schema
                ["https://json.schemastore.org/application.json"] = {
                  "application.yml",
                  "application.yaml",
                  "application-*.yml",
                  "application-*.yaml",
                },
                ["https://json.schemastore.org/bootstrap.json"] = {
                  "bootstrap.yml",
                  "bootstrap.yaml",
                  "bootstrap-*.yml",
                  "bootstrap-*.yaml",
                },
              },
            },
          },
        },
      },
    },
  },

  -- Properties dosyaları için syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java", "properties" })
      end
    end,
  },

  -- Spring Boot için autocmd'ler
  {
    "neovim/nvim-lspconfig",
    init = function()
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup

      -- Spring Boot application.properties için
      autocmd({ "BufNewFile", "BufRead" }, {
        pattern = { "application*.properties", "application*.yml", "application*.yaml" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
        end,
      })

      -- Maven pom.xml için
      autocmd("FileType", {
        pattern = "xml",
        callback = function()
          local filename = vim.fn.expand("%:t")
          if filename == "pom.xml" then
            vim.opt_local.shiftwidth = 2
            vim.opt_local.tabstop = 2
          end
        end,
      })

      -- Gradle build files için
      autocmd({ "BufNewFile", "BufRead" }, {
        pattern = { "*.gradle", "*.gradle.kts", "settings.gradle", "settings.gradle.kts" },
        callback = function()
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
        end,
      })
    end,
  },
}
