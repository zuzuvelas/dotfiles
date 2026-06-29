-- conform.nvim — external formatter runner with LSP format as fallback.
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      desc = 'Format buffer',
    },
  },
  opts = {
    -- Formatter selection per filetype. stop_after_first: try in order, stop at the first found.
    formatters_by_ft = {
      lua             = { 'stylua' },
      kotlin          = { 'ktlint' },
      javascript      = { 'prettierd', 'prettier', stop_after_first = true },
      typescript      = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      html            = { 'prettierd', 'prettier', stop_after_first = true },
      css             = { 'prettierd', 'prettier', stop_after_first = true },
      json            = { 'prettierd', 'prettier', stop_after_first = true },
      yaml            = { 'prettierd', 'prettier', stop_after_first = true },
      markdown        = { 'prettierd', 'prettier', stop_after_first = true },
    },
    -- Format on save. 500ms timeout: if the formatter is slow, skip silently rather than block.
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
}
