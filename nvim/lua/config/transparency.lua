local M = {}

vim.g.nvim_transparency_enabled = true

local glow = "#1f2440"
local glow_soft = "#191d33"
local text = "#cdd6f4"
local muted = "#6c7086"
local blue = "#89b4fa"
local mauve = "#cba6f7"

local function set_hl(group, opts)
  pcall(vim.api.nvim_set_hl, 0, group, opts)
end

local function clear_bg(group, extra)
  local ok, current = pcall(vim.api.nvim_get_hl, 0, {
    name = group,
    link = false,
  })

  if not ok then
    current = {}
  end

  current.bg = nil
  current.ctermbg = nil

  if extra then
    for key, value in pairs(extra) do
      current[key] = value
    end
  end

  pcall(vim.api.nvim_set_hl, 0, group, current)
end

local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "FoldColumn",
  "EndOfBuffer",
  "NonText",
  "MsgArea",

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

local function apply_cursorline()
  set_hl("CursorLine", {
    bg = glow,
  })

  set_hl("CursorLineNr", {
    fg = blue,
    bg = "NONE",
    bold = true,
  })

  set_hl("LineNr", {
    fg = muted,
    bg = "NONE",
  })
end

local function apply_colorcolumn()
  set_hl("ColorColumn", {
    bg = glow_soft,
  })
end

local function apply_tabline()
  set_hl("TabLineFill", {
    fg = muted,
    bg = glow_soft,
  })

  set_hl("TabLine", {
    fg = muted,
    bg = glow_soft,
  })

  set_hl("TabLineSel", {
    fg = mauve,
    bg = glow,
    bold = true,
  })

  set_hl("TabbyFill", {
    fg = muted,
    bg = glow_soft,
  })

  set_hl("TabbyInactive", {
    fg = muted,
    bg = glow_soft,
  })

  set_hl("TabbyHidden", {
    fg = muted,
    bg = glow_soft,
    italic = true,
  })

  set_hl("TabbyCurrent", {
    fg = mauve,
    bg = glow,
    bold = true,
  })
end

local function apply_lualine()
  local ok, groups = pcall(vim.api.nvim_get_hl, 0, {})

  if ok then
    for name, _ in pairs(groups) do
      if name:match("^lualine_") then
        clear_bg(name)

        if name:match("_normal") then
          set_hl(name, {
            fg = text,
            bg = glow,
            bold = true,
          })
        elseif name:match("_inactive") then
          set_hl(name, {
            fg = muted,
            bg = "NONE",
          })
        end
      end
    end
  end

  set_hl("StatusLine", {
    fg = text,
    bg = glow,
    bold = true,
  })

  set_hl("StatusLineNC", {
    fg = muted,
    bg = "NONE",
  })
end

function M.apply()
  if not vim.g.nvim_transparency_enabled then
    return
  end

  for _, group in ipairs(transparent_groups) do
    clear_bg(group)
  end

  apply_cursorline()
  apply_colorcolumn()
  apply_tabline()
  apply_lualine()

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
  "WinEnter",
  "BufEnter",
}, {
  callback = function()
    vim.schedule(M.apply)
  end,
})

vim.keymap.set("n", "<leader>ut", M.toggle, {
  desc = "Toggle transparency",
})

return M
