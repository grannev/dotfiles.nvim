local M = {}

local pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

local function termcodes(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

function M.enter()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()

  local before = line:sub(col, col)
  local after = line:sub(col + 1, col + 1)

  if pairs[before] == after then
    vim.api.nvim_feedkeys(termcodes("<CR><Esc>O"), "n", false)
    return
  end

  vim.api.nvim_feedkeys(termcodes("<CR>"), "n", false)
end

return M
