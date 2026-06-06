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
        line = "gcc",
        block = "gbc",
      },

      opleader = {
        line = "gc",
        block = "gb",
      },

      mappings = {
        basic = true,
        extra = true,
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "c",
        "cpp",
      },
      callback = function()
        vim.bo.commentstring = "/* %s */"
      end,
    })
  end,
}
