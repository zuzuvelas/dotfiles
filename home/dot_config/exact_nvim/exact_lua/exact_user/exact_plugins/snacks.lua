-- snacks.nvim — file picker, explorer, and LSP navigation UI.
-- priority = 1000 and lazy = false: loaded before everything else so picker is always available.
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Fuzzy file/grep/buffer finder.
    picker = { enabled = true },

    -- File tree sidebar. replace_netrw: snacks handles `nvim .` instead of netrw.
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    lazygit = { enabled = true },

    -- Disable treesitter/syntax for files over ~1.5MB — prevents editor lockup.
    bigfile = { enabled = true },
  },
  config = function(_, opts)
    local snacks = require('snacks')
    snacks.setup(opts)

    -- File navigation keymaps.
    local map = vim.keymap.set
    map('n', '<leader>ff', function() snacks.picker.files() end, { desc = 'Find files' })
    map('n', '<leader>fg', function() snacks.picker.grep() end, { desc = 'Grep' })
    map('n', '<leader>fb', function() snacks.picker.buffers() end, { desc = 'Buffers' })
    map('n', '<leader>fr', function() snacks.picker.recent() end, { desc = 'Recent files' })
    map('n', '<leader>fe', function() snacks.explorer() end, { desc = 'File explorer' })
    map({ 'n', 'x' }, '<leader>fw', function() snacks.picker.grep_word() end, { desc = 'Grep word/selection' })

    -- Lazygit keymaps.
    map('n', '<leader>gg', function() snacks.lazygit() end, { desc = 'Lazygit' })
    map('n', '<leader>gl', function() snacks.lazygit.log() end, { desc = 'Git log (repo)' })
    map('n', '<leader>gL', function() snacks.lazygit.log_file() end, { desc = 'Git log (file)' })

    -- LSP navigation via snacks picker — shows results in a searchable list.
    -- Set up in LspAttach so keymaps only apply to buffers with an active server.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('SnacksLspKeymaps', { clear = true }),
      callback = function(args)
        local o = { buffer = args.buf, silent = true }

        map('n', 'gd', function() snacks.picker.lsp_definitions() end,
          vim.tbl_extend('force', o, { desc = 'Go to definition' }))
        map('n', 'gD', function() snacks.picker.lsp_declarations() end,
          vim.tbl_extend('force', o, { desc = 'Go to declaration' }))
        map('n', 'gr', function() snacks.picker.lsp_references() end,
          vim.tbl_extend('force', o, { nowait = true, desc = 'References' }))
        map('n', 'gi', function() snacks.picker.lsp_implementations() end,
          vim.tbl_extend('force', o, { desc = 'Go to implementation' }))
        map('n', '<leader>D', function() snacks.picker.lsp_type_definitions() end,
          vim.tbl_extend('force', o, { desc = 'Type definition' }))
        map('n', '<leader>ds', function() snacks.picker.lsp_symbols() end,
          vim.tbl_extend('force', o, { desc = 'Document symbols' }))
        map('n', '<leader>ws', function() snacks.picker.lsp_workspace_symbols() end,
          vim.tbl_extend('force', o, { desc = 'Workspace symbols' }))
      end,
    })
  end,
}
