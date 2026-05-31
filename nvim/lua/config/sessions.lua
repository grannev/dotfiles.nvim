local session_dir = vim.fn.stdpath("state") .. "/sessions"

vim.fn.mkdir(session_dir, "p")

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "terminal",
}

local function normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function session_root()
  return normalize(vim.fn.getcwd())
end

local function safe_name(root)
  local home = vim.fn.expand("$HOME")
  local name = root:gsub("^" .. vim.pesc(home), "~")
  name = name:gsub("[/\\:]", "%%")
  return name
end

local function session_file()
  local root = session_root()
  return session_dir .. "/" .. safe_name(root) .. ".vim"
end

local function save_session()
  local file = session_file()
  vim.cmd("mksession! " .. vim.fn.fnameescape(file))
  vim.notify("Session saved: " .. file, vim.log.levels.INFO)
end

local function load_session()
  local file = session_file()

  if vim.fn.filereadable(file) == 0 then
    vim.notify("No session found: " .. file, vim.log.levels.WARN)
    return
  end

  vim.cmd("silent! source " .. vim.fn.fnameescape(file))

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name ~= "" and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.bo[bufnr].undofile = true
    end
  end

  vim.notify("Session loaded: " .. file, vim.log.levels.INFO)
end

local function delete_session()
  local file = session_file()

  if vim.fn.filereadable(file) == 0 then
    vim.notify("No session to delete: " .. file, vim.log.levels.WARN)
    return
  end

  vim.fn.delete(file)
  vim.notify("Session deleted: " .. file, vim.log.levels.INFO)
end

local function session_info()
  print("Session root: " .. session_root())
  print("Session file: " .. session_file())
  print("Exists: " .. tostring(vim.fn.filereadable(session_file()) == 1))
end

vim.api.nvim_create_user_command("SessionSave", save_session, {})
vim.api.nvim_create_user_command("SessionLoad", load_session, {})
vim.api.nvim_create_user_command("SessionDelete", delete_session, {})
vim.api.nvim_create_user_command("SessionInfo", session_info, {})

vim.keymap.set("n", "<leader>ss", save_session, {
  desc = "Save project session",
})

vim.keymap.set("n", "<leader>sl", load_session, {
  desc = "Load project session",
})

vim.keymap.set("n", "<leader>sd", delete_session, {
  desc = "Delete project session",
})
