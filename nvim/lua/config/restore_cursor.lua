vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype

    if filetype == "gitcommit" or filetype == "gitrebase" then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
    end
  end,
})
