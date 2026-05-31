return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  opts = {
    bind = true,

    floating_window = true,
    floating_window_above_cur_line = true,
    floating_window_off_x = 1,
    floating_window_off_y = 0,

    hint_enable = false,
    doc_lines = 2,

    max_height = 8,
    max_width = function()
      return math.floor(vim.api.nvim_win_get_width(0) * 0.75)
    end,

    wrap = true,
    fix_pos = false,
    close_timeout = 3000,
    always_trigger = false,
    extra_trigger_chars = { "(", "," },

    hi_parameter = "LspSignatureActiveParameter",

    handler_opts = {
      border = "rounded",
    },

    toggle_key = "<M-s>",
    select_signature_key = "<M-n>",
  },
  config = function(_, opts)
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
      fg = mocha.base,
      bg = mocha.peach,
      bold = true,
    })

    require("lsp_signature").setup(opts)
  end,
}
