-- gitsigns — per-line git diff markers and hunk-level staging/reset.
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    -- Sign characters in the signcolumn.
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '󰍵' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local map = vim.keymap.set
      local o = { buffer = bufnr, silent = true }

      -- Hunk navigation.
      map('n', ']h', gs.next_hunk, vim.tbl_extend('force', o, { desc = 'Next hunk' }))
      map('n', '[h', gs.prev_hunk, vim.tbl_extend('force', o, { desc = 'Previous hunk' }))

      -- Hunk staging and reset (for crafting commits without leaving Neovim).
      map('n', '<leader>hs', gs.stage_hunk, vim.tbl_extend('force', o, { desc = 'Stage hunk' }))
      map('n', '<leader>hr', gs.reset_hunk, vim.tbl_extend('force', o, { desc = 'Reset hunk' }))
      map('n', '<leader>hS', gs.stage_buffer, vim.tbl_extend('force', o, { desc = 'Stage buffer' }))
      map('n', '<leader>hu', gs.undo_stage_hunk, vim.tbl_extend('force', o, { desc = 'Undo stage hunk' }))
      map('n', '<leader>hR', gs.reset_buffer, vim.tbl_extend('force', o, { desc = 'Reset buffer' }))
      map('n', '<leader>hp', gs.preview_hunk, vim.tbl_extend('force', o, { desc = 'Preview hunk' }))

      -- Blame.
      map('n', '<leader>gb', gs.blame_line, vim.tbl_extend('force', o, { desc = 'Blame line' }))
      map('n', '<leader>gB', gs.blame, vim.tbl_extend('force', o, { desc = 'Blame buffer' }))

      -- Toggle.
      map('n', '<leader>td', gs.toggle_deleted, vim.tbl_extend('force', o, { desc = 'Toggle deleted lines' }))
    end,
  },
}
