-- Java Debug Adapter Protocol (DAP) - UI ve Keybindings
-- NOT: Temel DAP setup LazyVim'in lang.java extra'sı tarafından yapılıyor
return {
  -- nvim-dap'i override et - setup() çağrılmasını engelle
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      -- LazyVim'in lang.java extra'sı zaten DAP'i yapılandırıyor
      -- Burada setup() çağrılmamalı çünkü nvim-dap'in setup() fonksiyonu yok
    end,
  },

  -- DAP UI - Debugging için görsel arayüz
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local ok_dap, dap = pcall(require, "dap")
      local ok_dapui, dapui = pcall(require, "dapui")

      if not ok_dap or not ok_dapui then
        return
      end

      -- DAP UI setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- DAP UI otomatik açılma/kapanma
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- DAP virtual text - Debugging sırasında inline değerler göster
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = "<module",
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    },
  },

  -- DAP keybindings (LazyVim'in üzerine eklenenler)
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
        { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
        { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
        { "<leader>dC", "<cmd>DapRunToCursor<cr>", desc = "Run to Cursor" },
        { "<leader>dg", "<cmd>DapStepOut<cr>", desc = "Step Out" },
        { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
        { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
        { "<leader>dp", "<cmd>DapTogglePause<cr>", desc = "Pause" },
        { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
        { "<leader>ds", "<cmd>DapSessionStatus<cr>", desc = "Session Status" },
        { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      },
    },
  },
}
