return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
      fg = mocha.base,
      bg = mocha.peach,
      bold = true,
    })

    require("config.popup_hints").apply_signature()
  end,
}
