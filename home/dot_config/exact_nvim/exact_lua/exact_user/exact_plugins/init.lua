-- Bootstrap lazy.nvim if not already installed.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin list.
require('lazy').setup({
  { import = 'user.plugins.colorscheme' },
}, {
  -- lazy.nvim options
  install = {
    colorscheme = { 'catppuccin' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
