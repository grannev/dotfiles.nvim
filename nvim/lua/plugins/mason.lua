return {
  {
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUpdate",
    },
    opts = {
      max_concurrent_installers = 1,
      ui = {
        border = "rounded",
        width = 0.85,
        height = 0.75,
        icons = {
          package_installed = "+",
          package_pending = "~",
          package_uninstalled = "-",
        },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "bashls",
        "html",
        "cssls",
        "jsonls",
        "texlab",
        "gopls",
        "rust_analyzer",
      },
      automatic_enable = true,
    },
  },
}
