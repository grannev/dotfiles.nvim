return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "Open parent directory",
    },
    {
      "<leader>e",
      function()
        require("oil").open_float()
      end,
      desc = "Open file explorer",
    },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      "icon",
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 90,
      max_height = 30,
      border = "rounded",
    },
  },
}
