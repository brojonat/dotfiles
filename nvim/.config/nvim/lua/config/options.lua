-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-reload files when they change externally (e.g., from AI coding agents in other tmux panes)
vim.opt.autoread = true -- Automatically read files when changed outside of Neovim
vim.opt.updatetime = 300 -- Faster update time for better responsiveness (default is 4000ms)

-- Terminal and color settings (ensure proper rendering with tmux true color support)
vim.opt.termguicolors = true -- Enable 24-bit RGB colors (needed for proper colorscheme rendering)
