vim.api.nvim_set_hl(0, "LspInlayHint", {
  fg = "#6c7086",
  bg = "NONE",
  italic = true,
})

local group = vim.api.nvim_create_augroup("LspInlayHints", {
  clear = true,
})

local enabled = false

local function supports_inlay_hints(client)
  return client and client.server_capabilities and client.server_capabilities.inlayHintProvider
end

local function set_inlay_hints(bufnr, value)
  local ok = pcall(vim.lsp.inlay_hint.enable, value, {
    bufnr = bufnr,
  })

  return ok
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not supports_inlay_hints(client) then
      return
    end

    set_inlay_hints(event.buf, enabled)
  end,
})

vim.keymap.set("n", "<leader>ih", function()
  enabled = not enabled

  local bufnr = vim.api.nvim_get_current_buf()
  set_inlay_hints(bufnr, enabled)

  if enabled then
    vim.notify("Inlay hints enabled", vim.log.levels.INFO)
  else
    vim.notify("Inlay hints disabled", vim.log.levels.INFO)
  end
end, {
  desc = "Toggle inlay hints",
})
