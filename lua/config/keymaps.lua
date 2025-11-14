-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Java specific keybindings
local function java_keymaps()
  local opts = { buffer = true, silent = true }

  -- Java test commands
  vim.keymap.set("n", "<leader>cJt", "<cmd>JavaTestRunCurrentClass<cr>", vim.tbl_extend("force", opts, { desc = "Run Test Class" }))
  vim.keymap.set("n", "<leader>cJT", "<cmd>JavaTestDebugCurrentClass<cr>", vim.tbl_extend("force", opts, { desc = "Debug Test Class" }))
  vim.keymap.set("n", "<leader>cJm", "<cmd>JavaTestRunCurrentMethod<cr>", vim.tbl_extend("force", opts, { desc = "Run Test Method" }))
  vim.keymap.set("n", "<leader>cJM", "<cmd>JavaTestDebugCurrentMethod<cr>", vim.tbl_extend("force", opts, { desc = "Debug Test Method" }))

  -- Java refactoring
  vim.keymap.set("n", "<leader>cJv", "<cmd>JavaRefactorExtractVariable<cr>", vim.tbl_extend("force", opts, { desc = "Extract Variable" }))
  vim.keymap.set("v", "<leader>cJv", "<cmd>JavaRefactorExtractVariable<cr>", vim.tbl_extend("force", opts, { desc = "Extract Variable" }))
  vim.keymap.set("n", "<leader>cJc", "<cmd>JavaRefactorExtractConstant<cr>", vim.tbl_extend("force", opts, { desc = "Extract Constant" }))
  vim.keymap.set("v", "<leader>cJc", "<cmd>JavaRefactorExtractConstant<cr>", vim.tbl_extend("force", opts, { desc = "Extract Constant" }))
  vim.keymap.set("v", "<leader>cJm", "<cmd>JavaRefactorExtractMethod<cr>", vim.tbl_extend("force", opts, { desc = "Extract Method" }))

  -- Spring Boot specific
  vim.keymap.set("n", "<leader>cJs", function()
    -- Backend klasörünü bul
    local backend_dir = vim.fn.finddir("backend", vim.fn.getcwd() .. ";")
    if backend_dir == "" then
      backend_dir = vim.fn.getcwd()
    else
      backend_dir = vim.fn.fnamemodify(backend_dir, ":p:h")
    end
    vim.cmd("terminal cd " .. vim.fn.shellescape(backend_dir) .. " && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev")
  end, vim.tbl_extend("force", opts, { desc = "Run Spring Boot App (Dev)" }))

  vim.keymap.set("n", "<leader>cJb", function()
    local backend_dir = vim.fn.finddir("backend", vim.fn.getcwd() .. ";")
    if backend_dir == "" then
      backend_dir = vim.fn.getcwd()
    else
      backend_dir = vim.fn.fnamemodify(backend_dir, ":p:h")
    end
    vim.cmd("terminal cd " .. vim.fn.shellescape(backend_dir) .. " && ./mvnw clean install -DskipTests")
  end, vim.tbl_extend("force", opts, { desc = "Build with Maven" }))

  vim.keymap.set("n", "<leader>cJg", function()
    local backend_dir = vim.fn.finddir("backend", vim.fn.getcwd() .. ";")
    if backend_dir == "" then
      backend_dir = vim.fn.getcwd()
    else
      backend_dir = vim.fn.fnamemodify(backend_dir, ":p:h")
    end
    vim.cmd("terminal cd " .. vim.fn.shellescape(backend_dir) .. " && gradle bootRun")
  end, vim.tbl_extend("force", opts, { desc = "Run with Gradle" }))
end

-- Java dosyalarında otomatik olarak yükle
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = java_keymaps,
})
