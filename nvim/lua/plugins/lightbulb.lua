return {
  "kosayoda/nvim-lightbulb",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {
    priority = 1000,
    link_highlights = false,

    autocmd = {
      enabled = true,
      updatetime = 500,
      events = {
        "CursorHold",
        "CursorHoldI",
      },
    },

    sign = {
      enabled = true,
      text = "A",
      hl = "LightBulbSign",
    },

    virtual_text = {
      enabled = false,
    },

    float = {
      enabled = false,
    },

    status_text = {
      enabled = false,
    },

    number = {
      enabled = false,
    },

    line = {
      enabled = false,
    },
  },
  config = function(_, opts)
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "LightBulbSign", {
      fg = mocha.yellow,
      bg = "NONE",
      bold = true,
    })

    require("nvim-lightbulb").setup(opts)
  end,
}
