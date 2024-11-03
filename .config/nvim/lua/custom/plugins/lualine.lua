return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
          }
        }
      },
    },
  }
}
