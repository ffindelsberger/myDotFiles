return {
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- :help ibl.setup()
    opts = {},
    config = function()
      require("ibl").setup {
        indent = {
          char = '┊',
        },
        show_trailing_blankline_indent = false,
      }
    end
  },
}
