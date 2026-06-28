local opt          = vim.opt

-- Appearance
opt.termguicolors  = true      -- Enable 24-bit color. Required for catppuccin to render correctly.
opt.number         = true      -- Show line numbers.
opt.relativenumber = true      -- Relative numbers for the lines above/below cursor.
opt.signcolumn     = 'yes'     -- Always show the sign column (gitsigns, diagnostics live here).
opt.cursorline     = true      -- Highlight the line the cursor is on.
opt.showmode       = false     -- Mode is shown by the statusline, not built-in.
opt.wrap           = false     -- Don't wrap long lines.
opt.scrolloff      = 8         -- Keep 8 lines visible above and below the cursor.
opt.sidescrolloff  = 8         -- Keep 8 columns visible left and right of the cursor.
opt.pumheight      = 10        -- Limit the completion popup to 10 items.
opt.laststatus     = 3         -- Single global statusline across all splits (Neovim 0.7+).
opt.winborder      = 'rounded' -- Rounded borders on floating windows (LSP hover, etc).

-- Indentation
opt.expandtab      = true -- Spaces, not tabs.
opt.shiftwidth     = 2 -- Indent size for >> / << and auto-indent.
opt.tabstop        = 2 -- How wide a tab character displays.
opt.softtabstop    = 2 -- How many spaces the tab key inserts.
opt.smartindent    = true -- Auto-indent new lines based on context.

-- Search
opt.ignorecase     = true -- Case-insensitive search by default...
opt.smartcase      = true -- ...unless the pattern contains an uppercase letter.
opt.hlsearch       = false -- Don't persist search highlights after moving away.

-- File Handling
opt.undofile       = true -- Persist undo history to disk. Survives closing and reopening files.
opt.swapfile       = false -- No swap files.
opt.backup         = false -- No backup files.
opt.updatetime     = 250 -- Fire CursorHold faster. LSP hover and gitsigns depend on this.

-- Clipboard
opt.clipboard      = 'unnamedplus' -- Sync yanks and pastes with the system clipboard.

-- Splits
opt.splitbelow     = true -- Horizontal splits open below the current window.
opt.splitright     = true -- Vertical splits open to the right.

-- Editing
opt.timeoutlen     = 500                            -- Ms to wait for a key sequence (e.g. leader combos).
opt.completeopt    = { 'menu', 'menuone', 'noinsert' } -- Don't auto-select completions; wait for explicit choice.
