-- LazyVim Extras - Senin İhtiyaçların İçin
-- https://www.lazyvim.org/extras

return {
  -- Import LazyVim extras
  { import = "lazyvim.plugins.extras.lang.typescript" }, -- TypeScript/React/Next.js
  { import = "lazyvim.plugins.extras.lang.json" }, -- JSON
  { import = "lazyvim.plugins.extras.lang.tailwind" }, -- TailwindCSS
  { import = "lazyvim.plugins.extras.formatting.prettier" }, -- Prettier
  { import = "lazyvim.plugins.extras.linting.eslint" }, -- ESLint
  { import = "lazyvim.plugins.extras.util.mini-hipatterns" }, -- Color highlighter
  { import = "lazyvim.plugins.extras.ui.mini-animate" }, -- Smooth animations
  { import = "lazyvim.plugins.extras.coding.copilot" }, -- GitHub Copilot (optional)
  { import = "lazyvim.plugins.extras.util.project" }, -- Project management
  { import = "lazyvim.plugins.extras.vscode" }, -- VSCode integration
}
