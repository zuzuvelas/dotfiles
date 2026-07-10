-- Completion engine — sources pipeline from LSP, path, snippets, and buffer.
-- Uses a pre-built Rust binary for fuzzy matching; version = pinned release downloads the binary.
return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = { 'folke/lazydev.nvim' },
  opts = {
    -- Keymap preset — 'default' uses Tab/S-Tab to cycle, CR to accept, C-e to cancel.
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    },

    appearance = {
      -- Tell blink.cmp the Nerd Font glyphs are single-width.
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          max_width = 60,
          max_height = 15,
        },
      },
      -- Menu columns: icon, label + description, kind name.
      menu = {
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label',    'label_description', gap = 1 },
            { 'kind' },
          },
        },
      },
    },

    -- Show function signature popup when inside a call's argument list.
    signature = { enabled = true },

    sources = {
      -- Source order: lazydev first (Neovim API boost), then LSP, path, snippets, buffer.
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
    },
  },
}
