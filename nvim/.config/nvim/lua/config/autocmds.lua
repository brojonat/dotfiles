-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-reload buffers when files change externally (for use with AI coding agents in other tmux panes)
-- This triggers a checktime when focus is gained or the cursor is held
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("auto_reload_buffers", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime") -- Check if any buffers have been changed outside of Neovim
    end
  end,
})

-- Disable diagnostics for .env files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("disable_env_diagnostics", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
