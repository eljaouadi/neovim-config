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

    -- Define the servers that should be automatically installed by Mason
    local servers = {
      "svelte",
      "graphql",
      "emmet_ls",
      "lua_ls",
      "intelephense",
      "ts_ls", -- Corrected from tsserver
      -- Add any other servers you use here
    }

    -- Setup mason-lspconfig to automatically install and manage servers
    mason_lspconfig.setup({
      ensure_installed = servers,
    })

    -- Used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- ## Loop through servers and apply default setup ##
    for _, server_name in ipairs(servers) do
      local opts = {
        capabilities = capabilities,
      }

      -- Get the custom settings for each server
      if server_name == "svelte" then
        opts.on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end
      elseif server_name == "graphql" then
        opts.filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" }
      elseif server_name == "emmet_ls" then
        opts.filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "javascript",
          "css",
          "sass",
          "scss",
          "less",
          "svelte",
          "blade",
        }
      elseif server_name == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        }
      elseif server_name == "intelephense" then
        -- Your extensive intelephense settings go here
        opts.settings = {
          intelephense = {
            stubs = {
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
              "imap",
              "intl",
              "json",
              "libxml",
              "mbstring",
              "mcrypt",
              "mysql",
              "mysqli",
              "password",
              "pcntl",
              "pcre",
              "PDO",
              "pdo_mysql",
              "Phar",
              "readline",
              "regex",
              "session",
              "SimpleXML",
              "sockets",
              "sodium",
              "standard",
              "superglobals",
              "tokenizer",
              "xml",
              "xdebug",
              "xmlreader",
              "xmlwriter",
              "yaml",
              "zip",
              "zlib",
              "wordpress-stubs",
              "woocommerce-stubs",
              "acf-pro-stubs",
              "wordpress-globals",
              "wp-cli-stubs",
              "genesis-stubs",
              "polylang-stubs",
            },
            environment = {
              includePaths = {
                vim.fn.expand("~") .. "/.composer/vendor/php-stubs/",
                vim.fn.expand("~") .. "/.composer/vendor/wpsyntex/",
              },
            },
            files = {
              associations = { "*.php", "*.blade.php" },
              maxSize = 5000000,
            },
          },
        }
      end

      -- Finally, set up the server with the combined options
      lspconfig[server_name].setup(opts)
    end

    -- ## All your other settings below remain the same ##

    -- LspAttach autocommand for keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
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
