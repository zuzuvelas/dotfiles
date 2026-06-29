-- LSP stack: Mason (binary manager) → mason-lspconfig (name bridge) → vim.lsp.config (0.11 native).
-- nvim-lspconfig ships server defaults as runtime files; we no longer use its require() framework.
return {
  -- Binary manager for LSP servers.
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    opts = {},
  },

  -- Bridges Mason package names to lspconfig/vim.lsp server names.
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'kotlin_language_server',
        'ts_ls',
        'lua_ls',
        'angularls',
      },
    },
  },

  -- Auto-installs tools not covered by mason-lspconfig (formatters, etc.).
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = { 'prettierd' },
    },
  },

  -- Lua LSP integration for the Neovim API.
  -- Injects vim.* type annotations into lua_ls when editing Neovim config files.
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- nvim-lspconfig ships server configs (cmd, filetypes, root_markers) as runtime files.
  -- Neovim 0.11 reads these automatically via vim.lsp.enable(); no framework required.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
      'folke/lazydev.nvim',
    },
    config = function()
      -- Diagnostic display: virtual text marker, rounded float, sorted by severity.
      vim.diagnostic.config({
        virtual_text = { prefix = '●' },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = true },
      })

      -- Global capability defaults applied to every server.
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Per-server overrides — only what differs from nvim-lspconfig's shipped defaults.
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = { telemetry = { enable = false } },
        },
      })

      -- Activate servers. nvim-lspconfig's runtime files provide cmd/filetypes/root_markers.
      vim.lsp.enable({
        'lua_ls',
        'ts_ls',
        'angularls',
        'kotlin_language_server',
      })

      -- Buffer-local keymaps when a server attaches.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspKeymaps', { clear = true }),
        callback = function(args)
          local map = vim.keymap.set
          local o = { buffer = args.buf, silent = true }

          map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', o, { desc = 'LSP hover' }))
          map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', o, { desc = 'Rename symbol' }))
          map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', o, { desc = 'Code actions' }))

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('n', '<leader>th', function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
                { bufnr = args.buf }
              )
            end, vim.tbl_extend('force', o, { desc = 'Toggle inlay hints' }))
          end
        end,
      })
    end,
  },
}
