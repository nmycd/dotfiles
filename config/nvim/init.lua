-- ==========================================================================
-- 1. GLOBAL BASICS (Must happen first)
-- ==========================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- Set to true since you have icons in your config

-- Disable Netrw so Mini.Files works
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ==========================================================================
-- 2. LOAD CORE CONFIG (Options, Keymaps, Autocmds)
-- ==========================================================================
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- ==========================================================================
-- 3. BOOTSTRAP LAZY.NVIM
-- ==========================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- 4. LOAD PLUGINS
-- ==========================================================================
require('lazy').setup({
  { import = 'plugins' },
}, {
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
vim.diagnostic.config {
  update_in_insert = true,
}

require('neoscroll').setup {
  mappings = { -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>',
    '<C-d>',
    '<C-b>',
    '<C-f>',
    '<C-y>',
    '<C-e>',
    'zt',
    'zz',
    'zb',
  },
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 0.3, -- Global duration multiplier
  easing = 'linear', -- Default easing function
  pre_hook = nil, -- Function to run before the scrolling animation starts
  post_hook = nil, -- Function to run after the scrolling animation ends
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  ignored_events = { -- Events ignored while scrolling
    'WinScrolled',
    'CursorMoved',
  },
}
