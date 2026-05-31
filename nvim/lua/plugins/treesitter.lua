return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "c",
      "cpp",
      "go",
      "rust",
      "python",
      "pascal",

      "asm",
      "nasm",

      "bash",
      "lua",
      "vim",
      "vimdoc",
      "query",

      "html",
      "xml",
      "css",
      "json",
      "jsonc",

      "latex",
      "bibtex",
      "markdown",
      "markdown_inline",

      "make",
      "cmake",
      "yaml",
      "toml",
    }

    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "c",
        "cpp",
        "go",
        "rust",
        "python",
        "pascal",

        "asm",
        "nasm",

        "bash",
        "sh",
        "lua",
        "vim",
        "vimdoc",

        "html",
        "xhtml",
        "xml",
        "css",
        "json",
        "jsonc",

        "tex",
        "bib",
        "plaintex",
        "markdown",

        "make",
        "cmake",
        "yaml",
        "toml",
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
