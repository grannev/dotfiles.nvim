vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.CustomFoldExpr()"
vim.opt.foldtext = "v:lua.CustomFoldText()"

vim.opt.fillchars:append({
  fold = " ",
})

function _G.CustomFoldExpr()
  local line = vim.fn.getline(vim.v.lnum)

  if line:match("^%s*#") then
    return "0"
  end

  return vim.treesitter.foldexpr()
end

function _G.CustomFoldText()
  local fold_size = vim.v.foldend - vim.v.foldstart + 1
  return "+- " .. fold_size .. " lines: ..."
end

local function find_open_brace_from_cursor()
  local current_line = vim.fn.line(".")
  local last_line = vim.fn.line("$")
  local scan_until = math.min(current_line + 80, last_line)

  for line_nr = current_line, scan_until do
    local line = vim.fn.getline(line_nr)

    if line:match("^%s*#") then
      return nil
    end

    local brace_col = line:find("{", 1, true)

    if brace_col then
      return line_nr, brace_col
    end

    if line:find(";", 1, true) then
      return nil
    end
  end

  return nil
end

local function matching_close_brace(open_line, open_col)
  local old_cursor = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, { open_line, open_col - 1 })
  vim.cmd("normal! %")

  local new_cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, old_cursor)

  local close_line = new_cursor[1]

  if close_line == open_line then
    return nil
  end

  return close_line
end

local function create_body_fold()
  local open_line, open_col = find_open_brace_from_cursor()

  if not open_line then
    return false
  end

  local close_line = matching_close_brace(open_line, open_col)

  if not close_line then
    return false
  end

  local body_start = open_line + 1
  local body_end = close_line - 1

  if body_start > body_end then
    return false
  end

  vim.cmd(body_start .. "," .. body_end .. "fold")

  return true
end

local function toggle_c_body_fold()
  if vim.fn.foldclosed(".") ~= -1 or vim.fn.foldlevel(".") > 0 then
    vim.cmd("normal! za")
    return
  end

  if not create_body_fold() then
    vim.cmd("normal! za")
  end
end

local function brace_delta(line)
  local opens = select(2, line:gsub("{", ""))
  local closes = select(2, line:gsub("}", ""))

  return opens - closes
end

local function create_all_body_folds()
  vim.cmd("normal! zE")

  local last_line = vim.fn.line("$")
  local depth = 0
  local folds_created = 0

  for line_nr = 1, last_line do
    local line = vim.fn.getline(line_nr)

    if not line:match("^%s*#") then
      local open_col = line:find("{", 1, true)

      if depth == 0 and open_col then
        local close_line = matching_close_brace(line_nr, open_col)

        if close_line and close_line > line_nr + 1 then
          local body_start = line_nr + 1
          local body_end = close_line - 1

          vim.cmd(body_start .. "," .. body_end .. "fold")
          folds_created = folds_created + 1
        end
      end

      depth = math.max(0, depth + brace_delta(line))
    end
  end

  if folds_created == 0 then
    vim.notify("No function body folds found", vim.log.levels.INFO)
  end
end

local function close_all_c_body_folds()
  create_all_body_folds()
  vim.cmd("normal! zM")
end

local function open_all_c_body_folds()
  vim.cmd("normal! zR")
end

local function preview_fold_signature()
  local fold_start = vim.fn.foldclosed(".")
  local fold_end = vim.fn.foldclosedend(".")

  if fold_start == -1 then
    vim.notify("Cursor is not on a closed fold", vim.log.levels.INFO)
    return
  end

  local scan_end = math.min(fold_end, fold_start + 20)
  local raw_lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, scan_end, false)
  local lines = {}

  for _, line in ipairs(raw_lines) do
    local clean = line:gsub("%s+$", "")

    if clean:find("{", 1, true) then
      clean = clean:gsub("%s*{%s*$", "")
      clean = clean:gsub("%)%s*$", ")")

      if clean:match("%S") then
        table.insert(lines, clean)
      end

      break
    end

    if clean:match("%S") then
      table.insert(lines, clean)
    end
  end

  if #lines == 0 then
    table.insert(lines, vim.fn.getline(fold_start))
  end

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end

  width = math.min(math.max(width + 4, 40), math.floor(vim.o.columns * 0.8))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.5))

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = vim.bo.filetype

  local row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    border = "rounded",
    style = "minimal",
    title = " Fold signature ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<cmd>close<CR>", {
    buffer = buf,
    silent = true,
  })

  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {
    buffer = buf,
    silent = true,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c",
    "cpp",
  },
  callback = function(event)
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldlevelstart = 99

    vim.keymap.set("n", "za", toggle_c_body_fold, {
      buffer = event.buf,
      desc = "Toggle C/C++ function body fold",
    })

    vim.keymap.set("n", "<leader>z", toggle_c_body_fold, {
      buffer = event.buf,
      desc = "Toggle C/C++ function body fold",
    })

    vim.keymap.set("n", "zM", close_all_c_body_folds, {
      buffer = event.buf,
      desc = "Close all C/C++ function body folds",
    })

    vim.keymap.set("n", "zR", open_all_c_body_folds, {
      buffer = event.buf,
      desc = "Open all C/C++ function body folds",
    })
  end,
})

vim.keymap.set("n", "<leader>z", "za", {
  desc = "Toggle fold",
})

vim.keymap.set("n", "<leader>zp", preview_fold_signature, {
  desc = "Preview folded function signature",
})
