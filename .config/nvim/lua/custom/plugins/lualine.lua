return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        --theme = 'gruvbox-material',
        theme = 'everforest',
        component_separators = '|',
        section_separators = '',
      },
    },
  }
}
