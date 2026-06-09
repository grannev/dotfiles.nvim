local M = {}

local system_tools = {
  { cmd = "git", pkg = "git" },
  { cmd = "rg", pkg = "ripgrep" },
  { cmd = "fd", pkg = "fd" },
  { cmd = "tree-sitter", pkg = "tree-sitter-cli" },
  { cmd = "curl", pkg = "curl" },
  { cmd = "tar", pkg = "tar" },
  { cmd = "unzip", pkg = "unzip" },
  { cmd = "gzip", pkg = "gzip" },
  { cmd = "npm", pkg = "npm" },
  { cmd = "python", pkg = "python" },
  { cmd = "clangd", pkg = "clang" },
  { cmd = "cc", pkg = "gcc" },
  { cmd = "make", pkg = "make" },
  { cmd = "sed", pkg = "sed" },
  { cmd = "lazygit", pkg = "lazygit" },
  { cmd = "latexmk", pkg = "texlive-binextra" },
  { cmd = "evince", pkg = "evince" },
}

local optional_tools = {
  { cmd = "go", pkg = "go" },
  { cmd = "rustc", pkg = "rust" },
  { cmd = "cargo", pkg = "rust" },
  { cmd = "xelatex", pkg = "texlive-bin" },
  { cmd = "lualatex", pkg = "texlive-bin" },
}

local mason_packages = {
  "lua-language-server",
  "pyright",
  "bash-language-server",
  "html-lsp",
  "css-lsp",
  "json-lsp",
  "texlab",
  "gopls",
  "rust-analyzer",
}

local config_files = {
  "options.lua",
  "keymaps.lua",
  "lazy.lua",
  "filetypes.lua",
  "popup_hints.lua",
  "lsp_highlight.lua",
  "inlay_hints.lua",
  "runner.lua",
  "sessions.lua",
  "folds.lua",
  "spell.lua",
  "health.lua",
}

local plugin_files = {
  "colorscheme.lua",
  "telescope.lua",
  "treesitter.lua",
  "lsp.lua",
  "mason.lua",
  "completion.lua",
  "signature.lua",
  "gitsigns.lua",
  "trouble.lua",
  "toggleterm.lua",
  "comment.lua",
  "vimtex.lua",
}

local function ok_mark(value)
  return value and "OK " or "NO "
end

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function readable(path)
  return vim.fn.filereadable(vim.fn.expand(path)) == 1
end

local function directory(path)
  return vim.fn.isdirectory(vim.fn.expand(path)) == 1
end

local function add_section(lines, title)
  table.insert(lines, "")
  table.insert(lines, "## " .. title)
end

local function add_check(lines, label, value, hint)
  local line = string.format("%s %s", ok_mark(value), label)

  if hint and hint ~= "" then
    line = line .. "  -> " .. hint
  end

  table.insert(lines, line)
end

local function mason_package(name)
  return directory(vim.fn.stdpath("data") .. "/mason/packages/" .. name)
end

local function plugin_file(path)
  return readable(vim.fn.stdpath("config") .. "/lua/plugins/" .. path)
end

local function config_file(path)
  return readable(vim.fn.stdpath("config") .. "/lua/config/" .. path)
end

local function unique(items)
  local seen = {}
  local result = {}

  for _, item in ipairs(items) do
    if item and item ~= "" and not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end

  return result
end

local function open_float(lines)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local width = math.min(math.floor(vim.o.columns * 0.9), 92)
  local height = math.min(math.floor(vim.o.lines * 0.8), math.max(#lines + 2, 18))
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
    title = " Neovim config health ",
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

  vim.keymap.set("n", "r", function()
    vim.cmd("close")
    M.repair()
  end, {
    buffer = buf,
    silent = true,
    desc = "Repair missing dependencies",
  })
end

local function open_terminal_command(command)
  local ok, terminal = pcall(require, "toggleterm.terminal")

  if ok then
    local term = terminal.Terminal:new({
      cmd = command,
      direction = "float",
      close_on_exit = false,
      hidden = true,
      float_opts = {
        border = "rounded",
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
    })

    term:toggle()
    return
  end

  vim.cmd("botright split")
  vim.cmd("resize 12")
  vim.cmd("terminal " .. command)
end

function M.repair()
  local missing_packages = {}

  for _, tool in ipairs(system_tools) do
    if not executable(tool.cmd) then
      table.insert(missing_packages, tool.pkg)
    end
  end

  missing_packages = unique(missing_packages)

  local missing_mason = {}

  for _, package in ipairs(mason_packages) do
    if not mason_package(package) then
      table.insert(missing_mason, package)
    end
  end

  vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")
  vim.fn.mkdir(vim.fn.stdpath("state") .. "/sessions", "p")
  vim.fn.mkdir(vim.fn.stdpath("config") .. "/spell", "p")

  local dotfiles_script = vim.fn.expand("~/.dotfiles/dotfiles.nvim/mk_dotfiles.nvim.sh")

  if readable(dotfiles_script) and not executable(dotfiles_script) then
    vim.fn.system({ "chmod", "+x", dotfiles_script })
  end

  if #missing_mason > 0 then
    vim.cmd("MasonInstall " .. table.concat(missing_mason, " "))
  end

  if #missing_packages > 0 then
    local cmd = "sudo pacman -S --needed " .. table.concat(missing_packages, " ")
    open_terminal_command(cmd)
    return
  end

  if #missing_mason > 0 then
    vim.notify("Started Mason install: " .. table.concat(missing_mason, ", "), vim.log.levels.INFO)
    return
  end

  vim.notify("Nothing to repair", vim.log.levels.INFO)
end

function M.run()
  local lines = {}

  table.insert(lines, "# Neovim config health")
  table.insert(lines, "")
  table.insert(lines, "Config: " .. vim.fn.stdpath("config"))
  table.insert(lines, "Data:   " .. vim.fn.stdpath("data"))
  table.insert(lines, "State:  " .. vim.fn.stdpath("state"))
  table.insert(lines, "CWD:    " .. vim.fn.getcwd())

  add_section(lines, "Core")
  add_check(lines, "Neovim >= 0.12", vim.fn.has("nvim-0.12") == 1, vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
  add_check(lines, "init.lua", readable(vim.fn.stdpath("config") .. "/init.lua"))
  add_check(lines, "lazy.nvim installed", directory(vim.fn.stdpath("data") .. "/lazy/lazy.nvim"))

  add_section(lines, "System tools")

  for _, tool in ipairs(system_tools) do
    add_check(lines, tool.cmd, executable(tool.cmd), "pacman: " .. tool.pkg)
  end

  add_section(lines, "Optional language tools")

  for _, tool in ipairs(optional_tools) do
    add_check(lines, tool.cmd, executable(tool.cmd), "optional pacman: " .. tool.pkg)
  end

  add_section(lines, "Mason LSP packages")

  for _, package in ipairs(mason_packages) do
    add_check(lines, package, mason_package(package))
  end

  add_section(lines, "Important config files")

  for _, file in ipairs(config_files) do
    add_check(lines, "config/" .. file, config_file(file))
  end

  for _, file in ipairs(plugin_files) do
    add_check(lines, "plugins/" .. file, plugin_file(file))
  end

  add_section(lines, "State directories")
  add_check(lines, "undo dir", directory(vim.fn.stdpath("state") .. "/undo"))
  add_check(lines, "sessions dir", directory(vim.fn.stdpath("state") .. "/sessions"))
  add_check(lines, "spell dir", directory(vim.fn.stdpath("config") .. "/spell"))

  add_section(lines, "Dotfiles repo")
  add_check(lines, "~/.dotfiles/dotfiles.nvim", directory("~/.dotfiles/dotfiles.nvim"))
  add_check(lines, "dotfiles git repo", directory("~/.dotfiles/dotfiles.nvim/.git"))
  add_check(lines, "mk_dotfiles.nvim.sh", readable("~/.dotfiles/dotfiles.nvim/mk_dotfiles.nvim.sh"))
  add_check(lines, "mk_dotfiles.nvim.sh executable", executable(vim.fn.expand("~/.dotfiles/dotfiles.nvim/mk_dotfiles.nvim.sh")))

  add_section(lines, "Live LSP")
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
  })

  if vim.tbl_isempty(clients) then
    table.insert(lines, "NO  no LSP attached to current buffer")
  else
    for _, client in ipairs(clients) do
      table.insert(lines, "OK  attached: " .. client.name)
    end
  end

  table.insert(lines, "")
  table.insert(lines, "Press r to repair missing dependencies.")
  table.insert(lines, "Press q or Esc to close.")

  open_float(lines)
end

vim.api.nvim_create_user_command("NvimConfigHealth", M.run, {})
vim.api.nvim_create_user_command("NvimConfigRepair", M.repair, {})

vim.keymap.set("n", "<leader>ch", M.run, {
  desc = "Neovim config health",
})

vim.keymap.set("n", "<leader>cr", M.repair, {
  desc = "Neovim config repair",
})

return M
