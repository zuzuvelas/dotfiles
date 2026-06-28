-- Highlight on Yank
-- Briefly flash the yanked region so you can see what was copied.
local yank_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 150 })
  end,
})

-- Restore Cursor Position
-- When reopening a file, jump to where the cursor was when it was last closed.
local cursor_group = vim.api.nvim_create_augroup('RestoreCursor', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim Trailing Whitespace
-- Strip trailing whitespace on save for code files.
-- Excludes filetypes where trailing whitespace is meaningful (markdown).
local trim_group = vim.api.nvim_create_augroup('TrimWhitespace', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = trim_group,
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    if ft == 'markdown' then return end
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Filetype Overrides
-- Force 4-space indent for specific filetypes that have strong community conventions.
local indent_group = vim.api.nvim_create_augroup('FiletypeIndent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = indent_group,
  pattern = { 'python', 'java' },
  callback = function()
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.tabstop     = 4
    vim.opt_local.softtabstop = 4
  end,
})
