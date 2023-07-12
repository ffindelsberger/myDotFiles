return {
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {},
    config = function()
      require("indent_blankline").setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end
  },
}
