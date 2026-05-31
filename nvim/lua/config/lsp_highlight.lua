local group = vim.api.nvim_create_augroup("LspDocumentHighlight", {
  clear = true,
})

vim.api.nvim_set_hl(0, "LspReferenceText", {
  bg = "#25273a",
})

vim.api.nvim_set_hl(0, "LspReferenceRead", {
  bg = "#25273a",
})

vim.api.nvim_set_hl(0, "LspReferenceWrite", {
  bg = "#2b2d42",
  bold = true,
})

local highlight_timer = nil

local function stop_timer()
  if highlight_timer and not highlight_timer:is_closing() then
    highlight_timer:stop()
    highlight_timer:close()
  end

  highlight_timer = nil
end

local function schedule_highlight(bufnr)
  stop_timer()
  vim.lsp.buf.clear_references()

  highlight_timer = vim.uv.new_timer()

  highlight_timer:start(1500, 0, vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if vim.tbl_isempty(clients) then
      return
    end

    vim.lsp.buf.document_highlight()
  end))
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then
      return
    end

    if not client.server_capabilities.documentHighlightProvider then
      return
    end

    vim.api.nvim_create_autocmd({
      "CursorMoved",
      "BufEnter",
    }, {
      group = group,
      buffer = event.buf,
      callback = function()
        schedule_highlight(event.buf)
      end,
    })

    vim.api.nvim_create_autocmd({
      "CursorMovedI",
      "InsertEnter",
      "BufLeave",
      "WinLeave",
    }, {
      group = group,
      buffer = event.buf,
      callback = function()
        stop_timer()
        vim.lsp.buf.clear_references()
      end,
    })
  end,
})
