vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local ok, wk = pcall(require, "which-key")

    if not ok then
      return
    end

    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>i", group = "inlay hints" },
      { "<leader>l", group = "lsp / latex" },
      { "<leader>m", group = "make / quickfix" },
      { "<leader>r", group = "run" },
      { "<leader>s", group = "session / search / spell" },
      { "<leader>t", group = "tabs" },
      { "<leader>x", group = "diagnostics / trouble" },
      { "<leader>z", group = "folds" },
    })
  end,
})
