return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to down window" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to up window" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to previous window" },
  },
}
