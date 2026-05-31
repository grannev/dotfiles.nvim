return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "IblIndent", {
      fg = mocha.surface0,
    })

    vim.api.nvim_set_hl(0, "IblScope", {
      fg = mocha.overlay0,
    })

    return {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = {
          "IblIndent",
        },
      },

      scope = {
        enabled = true,
        char = "│",
        highlight = {
          "IblScope",
        },
        show_start = false,
        show_end = false,
      },

      exclude = {
        filetypes = {
          "help",
          "terminal",
          "Trouble",
          "lazy",
          "mason",
          "oil",
          "TelescopePrompt",
        },
      },
    }
  end,
}
