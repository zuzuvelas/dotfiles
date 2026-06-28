-- Speed up module loading by caching bytecode.
vim.loader.enable()

require('user.options')
require('user.keymaps')
require('user.plugins')
require('user.autocmds')
