-- ~/.config/nvim/lua/eljaouadi/plugins/lsp/mason.lua

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- This now only handles formatters and linters, not LSPs
    mason_tool_installer.setup({
      ensure_installed = {
        -- Formatters
        "prettier",
        "stylua",
        "isort",
        "black",
        "phpcbf", -- PHP code beautifier (WordPress coding standards)

        -- Linters
        "pylint",
        "eslint_d",
        "phpcs", -- PHP linter (WordPress coding standards)
      },
    })
  end,
}
