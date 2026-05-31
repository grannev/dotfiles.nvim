return {
  "numToStr/Comment.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    require("Comment").setup({
      padding = true,
      sticky = true,

      toggler = {
        line = nil,
        block = "gcc",
      },

      opleader = {
        line = nil,
        block = "gc",
      },

      mappings = {
        basic = true,
        extra = false,
      },
    })

    local function uncomment_line(line)
      local indent, body = line:match("^(%s*)/%*%s?(.-)%s?%*/%s*$")

      if indent and body then
        return indent .. body
      end

      return line
    end

    local function comment_line(line)
      if line:match("^%s*$") then
        return line
      end

      local indent, body = line:match("^(%s*)(.*)$")
      return indent .. "/* " .. body .. " */"
    end

    local function is_block_commented(line)
      return line:match("^%s*/%*.*%*/%s*$") ~= nil
    end

    local function toggle_range(line1, line2)
      if line1 > line2 then
        line1, line2 = line2, line1
      end

      local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

      local non_empty = {}
      for _, line in ipairs(lines) do
        if not line:match("^%s*$") then
          table.insert(non_empty, line)
        end
      end

      if #non_empty == 0 then
        return
      end

      local all_commented = true
      for _, line in ipairs(non_empty) do
        if not is_block_commented(line) then
          all_commented = false
          break
        end
      end

      local new_lines = {}

      for _, line in ipairs(lines) do
        if line:match("^%s*$") then
          table.insert(new_lines, line)
        elseif all_commented then
          table.insert(new_lines, uncomment_line(line))
        else
          table.insert(new_lines, comment_line(line))
        end
      end

      vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, new_lines)
    end

    vim.api.nvim_create_user_command("BlockCommentLines", function(opts)
      toggle_range(opts.line1, opts.line2)
    end, {
      range = true,
    })

    vim.keymap.set("x", "gc", ":BlockCommentLines<CR>", {
      silent = true,
      desc = "Toggle block comment for each selected line",
    })
  end,
}
