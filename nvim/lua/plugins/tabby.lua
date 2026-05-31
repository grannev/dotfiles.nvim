return {
  "nanozuki/tabby.nvim",
  event = "VimEnter",
  config = function()
    vim.o.showtabline = 2

    local mocha = require("catppuccin.palettes").get_palette("mocha")

    vim.api.nvim_set_hl(0, "TabbyFill", {
      fg = mocha.overlay0,
      bg = mocha.mantle,
    })

    vim.api.nvim_set_hl(0, "TabbyCurrent", {
      fg = mocha.mauve,
      bg = mocha.surface1,
      bold = true,
    })

    vim.api.nvim_set_hl(0, "TabbyInactive", {
      fg = mocha.overlay1,
      bg = mocha.mantle,
    })

    vim.api.nvim_set_hl(0, "TabbyHidden", {
      fg = mocha.overlay0,
      bg = mocha.mantle,
      italic = true,
    })

    local max_name_length = 11

    local function shorten(text, max_len)
      if #text <= max_len then
        return text
      end

      return text:sub(1, max_len - 2) .. ".."
    end

    local function tab_info(tabid)
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local winid = vim.api.nvim_tabpage_get_win(tabid)
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local name = vim.api.nvim_buf_get_name(bufnr)

      if name == "" then
        name = "No Name"
      else
        name = vim.fn.fnamemodify(name, ":t")
      end

      name = shorten(name, max_name_length)

      local modified = vim.bo[bufnr].modified and "+" or ""

      return {
        id = tabid,
        nr = tabnr,
        text = tabnr .. ":" .. name .. modified,
      }
    end

    local function segment_width(info)
      return #info.text + 2
    end

    local function hidden_width(count)
      if count <= 0 then
        return 0
      end

      return #(" ... " .. count .. " ")
    end

    local function total_width(infos, first, last)
      local width = 0

      width = width + hidden_width(first - 1)

      for i = first, last do
        width = width + segment_width(infos[i])
      end

      width = width + hidden_width(#infos - last)

      return width
    end

    local function visible_range(infos, current_index, available)
      local first = current_index
      local last = current_index

      while true do
        local can_left = first > 1 and total_width(infos, first - 1, last) <= available
        local can_right = last < #infos and total_width(infos, first, last + 1) <= available

        if can_left and can_right then
          if current_index - first <= last - current_index then
            first = first - 1
          else
            last = last + 1
          end
        elseif can_left then
          first = first - 1
        elseif can_right then
          last = last + 1
        else
          break
        end
      end

      return first, last
    end

    require("tabby").setup({
      line = function(line)
        local tabids = vim.api.nvim_list_tabpages()
        local current = vim.api.nvim_get_current_tabpage()
        local infos = {}
        local current_index = 1

        for i, tabid in ipairs(tabids) do
          infos[i] = tab_info(tabid)

          if tabid == current then
            current_index = i
          end
        end

        local available = math.max(vim.o.columns - 4, 20)
        local first, last = visible_range(infos, current_index, available)

        local result = {
          hl = "TabbyFill",
        }

        if first > 1 then
          table.insert(result, {
            " ... " .. first - 1 .. " ",
            hl = "TabbyHidden",
          })
        end

        for i = first, last do
          local info = infos[i]
          local hl = i == current_index and "TabbyCurrent" or "TabbyInactive"

          table.insert(result, {
            "%" .. info.nr .. "T " .. info.text .. " %T",
            hl = hl,
          })
        end

        if last < #infos then
          table.insert(result, {
            " " .. #infos - last .. " ... ",
            hl = "TabbyHidden",
          })
        end

        table.insert(result, line.spacer())

        return result
      end,
    })
  end,
}
