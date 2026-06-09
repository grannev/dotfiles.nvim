local M = {}

vim.g.nvim_transparency_enabled = true

local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "EndOfBuffer",
  "FoldColumn",
  "MsgArea",
  "NonText",
  "TabLineFill",
}

local glass_groups = {
  "NormalFloat",
  "FloatBorder",
  "Pmenu",
  "PmenuSel",
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopeResultsNormal",
  "TelescopeResultsBorder",
  "TelescopePreviewNormal",
  "TelescopePreviewBorder",
  "WhichKeyFloat",
  "LazyNormal",
  "MasonNormal",
}

function M.apply()
  if not vim.g.nvim_transparency_enabled then
    return
  end

  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, {
      bg = "NONE",
    })
  end

  for _, group in ipairs(glass_groups) do
    vim.api.nvim_set_hl(0, group, {
      bg = "NONE",
    })
  end

  vim.opt.winblend = 8
  vim.opt.pumblend = 8
end

function M.toggle()
  vim.g.nvim_transparency_enabled = not vim.g.nvim_transparency_enabled

  if vim.g.nvim_transparency_enabled then
    M.apply()
    vim.notify("Neovim transparency enabled", vim.log.levels.INFO)
  else
    vim.cmd.colorscheme("catppuccin-mocha")
    vim.opt.winblend = 0
    vim.opt.pumblend = 0
    vim.notify("Neovim transparency disabled", vim.log.levels.INFO)
  end
end

vim.api.nvim_create_autocmd({
  "ColorScheme",
  "VimEnter",
}, {
  callback = function()
    vim.schedule(M.apply)
  end,
})

vim.keymap.set("n", "<leader>ut", M.toggle, {
  desc = "Toggle transparency",
})

return M
