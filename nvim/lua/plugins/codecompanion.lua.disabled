return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "zbirenbaum/copilot.lua",
  },
  keys = {
    {
      "<leader>aa",
      "<cmd>CodeCompanionActions<CR>",
      mode = { "n", "v" },
      desc = "AI actions",
    },
    {
      "<leader>ac",
      function()
        require("codecompanion").toggle({
          window_opts = {
            layout = "vertical",
            width = 0.45,
          },
        })
      end,
      desc = "AI chat toggle",
    },
    {
      "<leader>ai",
      ":CodeCompanion ",
      mode = { "n", "v" },
      desc = "AI inline prompt",
    },
    {
      "<leader>ae",
      ":CodeCompanion /explain<CR>",
      mode = "v",
      desc = "AI explain selection",
    },
    {
      "<leader>af",
      ":CodeCompanion /fix<CR>",
      mode = "v",
      desc = "AI fix selection",
    },
    {
      "<leader>at",
      ":CodeCompanion /tests<CR>",
      mode = "v",
      desc = "AI generate tests",
    },
    {
      "<leader>al",
      "<cmd>CodeCompanion /lsp<CR>",
      desc = "AI explain LSP diagnostics",
    },
    {
      "<leader>am",
      "<cmd>CodeCompanion /commit<CR>",
      desc = "AI commit message",
    },
  },
  opts = {
    interactions = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
    },

    display = {
      action_palette = {
        provider = "telescope",
      },
      chat = {
        window = {
          layout = "vertical",
          width = 0.45,
          height = 0.8,
        },
      },
    },

    opts = {
      log_level = "ERROR",
    },
  },
}
