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
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      menu = {
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
