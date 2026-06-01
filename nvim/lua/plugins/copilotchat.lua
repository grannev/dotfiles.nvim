return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = {
    "CopilotChat",
    "CopilotChatOpen",
    "CopilotChatClose",
    "CopilotChatToggle",
    "CopilotChatReset",
    "CopilotChatPrompts",
    "CopilotChatModels",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "zbirenbaum/copilot.lua",
  },
  keys = {
    {
      "<leader>ac",
      "<cmd>CopilotChatToggle<CR>",
      desc = "AI chat toggle",
    },
    {
      "<leader>ao",
      "<cmd>CopilotChatOpen<CR>",
      desc = "AI chat open",
    },
    {
      "<leader>aq",
      "<cmd>CopilotChatClose<CR>",
      desc = "AI chat close",
    },
    {
      "<leader>ar",
      "<cmd>CopilotChatReset<CR>",
      desc = "AI chat reset",
    },
    {
      "<leader>ap",
      "<cmd>CopilotChatPrompts<CR>",
      desc = "AI prompts",
    },
    {
      "<leader>am",
      "<cmd>CopilotChatModels<CR>",
      desc = "AI models",
    },
    {
      "<leader>ai",
      ":CopilotChat ",
      mode = { "n", "v" },
      desc = "AI prompt",
    },
    {
      "<leader>ae",
      ":CopilotChat Explain this code<CR>",
      mode = "v",
      desc = "AI explain selection",
    },
    {
      "<leader>at",
      ":CopilotChat Write tests for this code<CR>",
      mode = "v",
      desc = "AI tests for selection",
    },
  },
  opts = {
    auto_insert_mode = true,
    trusted_tools = {
      "edit",
    },

    window = {
      layout = "vertical",
      width = 0.45,
      height = 0.8,
      border = "rounded",
    },

    headers = {
      user = "You ",
      assistant = "Copilot ",
      tool = "Tool ",
    },
  },
}
