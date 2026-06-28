-- Leader key — must be set before lazy.nvim loads.
-- Set here, sourced by init.lua before plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- Editor
-- Clear search highlight without moving.
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Save with Ctrl+S in normal and insert mode.
map({ 'n', 'i' }, '<C-s>', '<cmd>write<CR><Esc>')

-- Better indenting — stay in visual mode after indent.
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move selected lines up and down.
map('v', 'J', ":move '>+1<CR>gv=gv")
map('v', 'K', ":move '<-2<CR>gv=gv")

-- Keep cursor centred when jumping through search results.
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- Keep cursor centred when jumping half-pages.
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Paste without clobbering the register.
-- By default, pasting over a visual selection yanks the replaced text into the
-- register, overwriting what you wanted to paste. This preserves the register.
map('x', 'p', '"_dP')

-- Splits
map('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Split horizontal' })
map('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close split' })

-- Navigate splits with Ctrl+hjkl — matches tmux pane navigation feel.
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Buffers
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
