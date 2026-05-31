local function shellescape(path)
  return vim.fn.shellescape(path)
end

local function cwd()
  return vim.fn.getcwd()
end

local function has_in_cwd(marker)
  return vim.fn.filereadable(cwd() .. "/" .. marker) == 1 or vim.fn.isdirectory(cwd() .. "/" .. marker) == 1
end

local function open_runner_terminal(cmd)
  local Terminal = require("toggleterm.terminal").Terminal

  local full_cmd = table.concat({
    "cd",
    shellescape(cwd()),
    "&&",
    cmd,
    ";",
    "printf '\\n[process exited] press Enter to close...'",
    ";",
    "read _",
  }, " ")

  local term = Terminal:new({
    cmd = full_cmd,
    direction = "float",
    close_on_exit = true,
    hidden = true,
    float_opts = {
      border = "rounded",
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
    },
  })

  term:toggle()
end

local function run_current_file()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  vim.cmd("write")

  local ft = vim.bo.filetype
  local cmd = nil

  if ft == "python" then
    cmd = "python " .. shellescape(file)
  elseif ft == "sh" or ft == "bash" then
    cmd = "bash " .. shellescape(file)
  elseif ft == "go" then
    cmd = "go run " .. shellescape(file)
  elseif ft == "rust" then
    if has_in_cwd("Cargo.toml") then
      cmd = "cargo run"
    else
      local out = "/tmp/nvim_run_rust"
      cmd = "rustc " .. shellescape(file) .. " -o " .. shellescape(out) .. " && " .. shellescape(out)
    end
  elseif ft == "c" then
    local out = "/tmp/nvim_run_c"
    cmd = "gcc " .. shellescape(file) .. " -Wall -Wextra -std=c11 -o " .. shellescape(out) .. " && " .. shellescape(out)
  elseif ft == "cpp" then
    local out = "/tmp/nvim_run_cpp"
    cmd = "g++ " .. shellescape(file) .. " -Wall -Wextra -std=c++20 -o " .. shellescape(out) .. " && " .. shellescape(out)
  else
    vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  open_runner_terminal(cmd)
end

vim.keymap.set("n", "<leader>rr", run_current_file, {
  desc = "Run current file",
})
