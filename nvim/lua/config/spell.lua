vim.opt.spelllang = {
  "ru",
  "en_us",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "tex",
    "plaintex",
    "markdown",
    "text",
    "gitcommit",
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "ru,en_us"
    vim.opt_local.spellcapcheck = ""
  end,
})

vim.keymap.set("n", "<leader>sp", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()

  if vim.opt_local.spell:get() then
    vim.notify("Spellcheck enabled", vim.log.levels.INFO)
  else
    vim.notify("Spellcheck disabled", vim.log.levels.INFO)
  end
end, {
  desc = "Toggle spellcheck",
})

vim.keymap.set("n", "<leader>sa", "zg", {
  desc = "Add word to spell dictionary",
})

vim.keymap.set("n", "<leader>sA", "zG", {
  desc = "Add word to spell dictionary temporarily",
})

vim.keymap.set("n", "<leader>su", "zug", {
  desc = "Undo spell add",
})

vim.keymap.set("n", "<leader>sf", "z=", {
  desc = "Spell suggestions",
})

vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/ru.utf-8.add"
