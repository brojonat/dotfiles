-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- For example:
-- <leader>sf to search (find) files
local keymap = vim.keymap.set

keymap("n", "<leader>sf", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })
