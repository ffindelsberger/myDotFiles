return {

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
  },

  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      bold = false,
      transparent_mode = true,
    },
    config = function(_, opts)
      -- vim.cmd.colorscheme 'gruvbox'
      require("gruvbox").setup(opts)
    end,
  },

  {
    -- The Main Theme
    'sainnhe/gruvbox-material',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      --require("gruvbox-material").setup({
      --  foreground = 'original'
      --})
      vim.cmd("let g:gruvbox_material_foreground = 'mix'")
      vim.cmd("let g:gruvbox_material_transparent_background = '1'")
      vim.cmd("let g:gruvbox_material_diagnostic_virtual_text = 'colored' ")
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  }
}
