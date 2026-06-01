return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Find text",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find help",
    },
  },
  opts = {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = "  ",
      path_display = { "smart" },

      file_ignore_patterns = {
        "%.git/",
        "node_modules/",
        "build/",
        "dist/",
        "target/",
        "__pycache__/",
        "%.venv/",
        "venv/",
        "%.mypy_cache/",
        "%.pytest_cache/",
        "%.cache/",
        "%.o$",
        "%.a$",
        "%.so$",
        "%.pdf$",
        "%.aux$",
        "%.log$",
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-q>"] = "send_selected_to_qflist",
        },
      },
    },
  },
}
