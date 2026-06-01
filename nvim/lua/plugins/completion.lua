return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "default",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<CR>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.accept()
          end

          require("config.smart_enter").enter()
          return true
        end,
      },
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.select_next()
            return true
          end

          local col = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          local before = line:sub(col, col)

          if before:match("%s") or col == 0 then
            return false
          end

          if vim.g.popup_hints_enabled ~= true then
            cmp.show()
            return true
          end

          return false
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.select_prev()
            return true
          end

          return false
        end,
        "fallback",
      },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      menu = {
        auto_show = function()
          return vim.g.popup_hints_enabled == true
        end,
        border = "rounded",
        max_height = 10,
      },
      documentation = {
        auto_show = false,
        window = {
          border = "rounded",
        },
      },
    },

    signature = {
      enabled = false,
    },

    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
    },
  },
}
