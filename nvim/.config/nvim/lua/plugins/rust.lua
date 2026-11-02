-- Rust-only overrides: show cargo-style diagnostics on the familiar keys.
-- Wraps LazyVim's on_attach rather than replacing it, so <leader>cR and
-- <leader>dr from the lang.rust extra survive.
return {
  "mrcjkb/rustaceanvim",
  opts = function(_, opts)
    local on_attach = opts.server.on_attach
    opts.server.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.keymap.set("n", "<leader>cd", function()
        vim.cmd.RustLsp({ "renderDiagnostic", "current" })
      end, { desc = "Render Diagnostic (cargo)", buffer = bufnr })
      vim.keymap.set("n", "<leader>ce", function()
        vim.cmd.RustLsp({ "explainError", "current" })
      end, { desc = "Explain Error", buffer = bufnr })
    end
  end,
}
