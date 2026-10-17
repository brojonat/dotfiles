-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- For example:
-- <leader>sf to search (find) files
local keymap = vim.keymap.set

keymap("n", "<leader>sf", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })

-- <leader>yc: yank with context. Copies the selection (or current line in
-- normal mode) to the system clipboard, prefixed with the absolute path and
-- line range and wrapped in a fenced code block, for pasting into LLM prompts.
local function yank_with_context()
  local mode = vim.fn.mode()
  local first, last
  if mode == "v" or mode == "V" or mode == "\22" then
    first, last = vim.fn.line("v"), vim.fn.line(".")
    if first > last then
      first, last = last, first
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    first = vim.fn.line(".")
    last = first
  end

  local path = vim.fn.expand("%:p")
  if path == "" then
    path = "[No Name]"
  end
  local lang = vim.fn.expand("%:e")
  if lang == "" then
    lang = vim.bo.filetype
  end
  local range = first == last and ("line " .. first) or ("lines " .. first .. "-" .. last)

  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local body = table.concat(lines, "\n")

  -- Grow the fence if the snippet itself contains backticks runs.
  local fence = "```"
  for run in body:gmatch("`+") do
    if #run >= #fence then
      fence = string.rep("`", #run + 1)
    end
  end

  local text = table.concat({ path .. " " .. range, "", fence .. lang, body, fence, "" }, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Yanked " .. range .. " of " .. vim.fn.expand("%:t") .. " with context")
end

keymap({ "n", "x" }, "<leader>yc", yank_with_context, { desc = "Yank with context" })

-- Inside Rex (and not tmux), ctrl+hjkl moves between nvim splits and hands
-- off to `rex focus` at the edge, like vim-tmux-navigator does for tmux.
-- See ~/.config/rex/init.lua for the other half.
if vim.env.REX_SESSION ~= nil and vim.env.TMUX == nil then
  local function rex_navigate(wincmd, direction)
    return function()
      local win = vim.api.nvim_get_current_win()
      vim.cmd.wincmd(wincmd)
      if vim.api.nvim_get_current_win() == win then
        vim.system({ "rex", "focus", direction })
      end
    end
  end
  keymap("n", "<C-h>", rex_navigate("h", "left"), { desc = "Go to left window" })
  keymap("n", "<C-j>", rex_navigate("j", "down"), { desc = "Go to down window" })
  keymap("n", "<C-k>", rex_navigate("k", "up"), { desc = "Go to up window" })
  keymap("n", "<C-l>", rex_navigate("l", "right"), { desc = "Go to right window" })
end
