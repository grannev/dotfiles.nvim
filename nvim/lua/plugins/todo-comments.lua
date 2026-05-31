return {
  "folke/todo-comments.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    {
      "<leader>xt",
      "<cmd>TodoTrouble<CR>",
      desc = "Todo comments in Trouble",
    },
    {
      "<leader>ft",
      "<cmd>TodoTelescope<CR>",
      desc = "Find todo comments",
    },
  },
  opts = {
    signs = true,
    sign_priority = 8,

    keywords = {
      TODO = {
        icon = "T",
        color = "info",
      },
      FIXME = {
        icon = "F",
        color = "error",
        alt = {
          "FIX",
          "BUG",
          "ISSUE",
        },
      },
      HACK = {
        icon = "H",
        color = "warning",
      },
      WARN = {
        icon = "W",
        color = "warning",
        alt = {
          "WARNING",
          "XXX",
        },
      },
      NOTE = {
        icon = "N",
        color = "hint",
        alt = {
          "INFO",
        },
      },
    },

    highlight = {
      multiline = false,
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 200,
    },

    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}
