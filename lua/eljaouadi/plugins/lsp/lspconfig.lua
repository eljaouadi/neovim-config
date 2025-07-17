-- ~/.config/nvim/lua/eljaouadi/plugins/lsp/lspconfig.lua

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import plugins
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap -- for conciseness

    -- Single source of truth for all LSP servers
    local servers = {
      -- PHP / WordPress
      "intelephense",
      -- Web Dev
      "html",
      "cssls",
      "tailwindcss",
      "emmet_ls",
      "eslint",
      "jsonls",
      "ts_ls", -- For TypeScript/JavaScript
      "svelte",
      "astro",
      "graphql",
      -- Other
      "lua_ls",
      "pyright",
      "prismals",
    }

    -- Setup mason-lspconfig to automatically install and manage servers
    mason_lspconfig.setup({
      ensure_installed = servers,
    })

    -- Default capabilities for autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- ## Loop through servers and apply setup ##
    for _, server_name in ipairs(servers) do
      local opts = {
        capabilities = capabilities,
      }

      -- ### Server-specific settings ###
      if server_name == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        }
      elseif server_name == "intelephense" then
        opts.settings = {
          intelephense = {
            -- Corrected stub keys for WordPress, WooCommerce, etc.
            stubs = {
              "acf",
              "bcmath",
              "bz2",
              "Core",
              "curl",
              "date",
              "dom",
              "fileinfo",
              "filter",
              "gd",
              "gettext",
              "hash",
              "iconv",
              "imagick",
              "imap",
              "intl",
              "json",
              "libxml",
              "mbstring",
              "mysqli",
              "openssl",
              "password",
              "pcre",
              "PDO",
              "pdo_mysql",
              "Phar",
              "readline",
              "session",
              "SimpleXML",
              "sockets",
              "sodium",
              "standard",
              "tokenizer",
              "xml",
              "xmlreader",
              "xmlwriter",
              "zip",
              "zlib",
              -- IMPORTANT: These are the correct keys
              "wordpress",
              "woocommerce",
              "wp-cli",
            },
            -- You can also specify your PHP version for better analysis
            environment = {
              phpVersion = "8.2", -- Change to your project's PHP version
            },
          },
        }
      end

      -- Finally, set up the server with the combined options
      lspconfig[server_name].setup(opts)
    end

    -- ## Keymaps and Diagnostics ##
    -- LspAttach autocommand for keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        -- Add all your keymaps here, they are correct as they were
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { buffer = ev.buf, desc = "Show LSP references" })
        keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = ev.buf, desc = "Show LSP definitions" })
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          { buffer = ev.buf, desc = "Show LSP implementations" }
        )
        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          { buffer = ev.buf, desc = "See available code actions" }
        )
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Smart rename" })
        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { buffer = ev.buf, desc = "Show buffer diagnostics" }
        )
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show line diagnostics" })
        keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Go to previous diagnostic" })
        keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })
        keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          { buffer = ev.buf, desc = "Show documentation for what is under cursor" }
        )
      end,
    })

    -- Diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
