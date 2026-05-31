return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local function lsp_name()
      local clients = vim.lsp.get_clients({
        bufnr = vim.api.nvim_get_current_buf(),
      })

      if vim.tbl_isempty(clients) then
        return "no lsp"
      end

      local names = {}

      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end

      return table.concat(names, ",")
    end

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        icons_enabled = false,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
            "starter",
          },
        },
      },

      sections = {
        lualine_a = {
          "mode",
        },

        lualine_b = {
          "branch",
        },

        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = "E:",
              warn = "W:",
              info = "I:",
              hint = "H:",
            },
          },
        },

        lualine_x = {
          {
            "filename",
            path = 1,
            shorting_target = 35,
          },
        },

        lualine_y = {
          {
            lsp_name,
            cond = function()
              return vim.bo.filetype ~= ""
            end,
          },
          {
            "filetype",
          },
        },

        lualine_z = {
          "location",
        },
      },
    }
  end,
}
