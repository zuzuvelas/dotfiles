-- Treesitter — AST-based parsing for syntax, folding, and indentation.
-- Replaces Neovim's regex engine with grammar-per-language parse trees.
-- Must load eagerly (lazy = false) so the FileType autocmd fires for the first buffer.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    local ts = require('nvim-treesitter')

    ts.setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
    })

    -- Parsers to install. Sized for this setup: Kotlin/Android, Angular/TS, Lua, and formats.
    local parsers = {
      'bash',
      'css',
      'diff',
      'dockerfile',
      'gitcommit',
      'gitignore',
      'html',
      'javascript',
      'json',
      'kotlin',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'regex',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    }

    -- Install parsers async after startup so they don't block the UI.
    vim.schedule(function()
      ts.install(parsers)
    end)

    -- Enable highlighting, folding, and indentation per buffer.
    -- Falls through gracefully: if the language parser isn't available, nothing breaks.
    -- On-demand install fires for any available parser we don't have yet.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        local buf = args.buf

        if not vim.treesitter.language.add(lang) then
          if vim.list_contains(ts.get_available(), lang) then
            ts.install({ lang })
          end
          return
        end

        vim.treesitter.start(buf, lang)

        -- Window-buffer-local: folds are per-buffer-in-window, not global.
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
