return {
  "lewis6991/gitsigns.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  keys = {
    {
      "]c",
      function()
        require("gitsigns").next_hunk()
      end,
      desc = "Next git hunk",
    },
    {
      "[c",
      function()
        require("gitsigns").prev_hunk()
      end,
      desc = "Previous git hunk",
    },
    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview git hunk",
    },
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset git hunk",
    },
    {
      "<leader>gb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Git blame line",
    },
  },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    current_line_blame = false,
    preview_config = {
      border = "rounded",
    },
  },
}
