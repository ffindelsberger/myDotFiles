return {

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
  },

  {
    "rebelot/kanagawa.nvim",
    config = function(_, opts)
      require('kanagawa').setup({
        compile = false,  -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,    -- do not set background color
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {             -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        theme = "dragon",  -- Load "wave" theme when 'background' option is not set
        background = {     -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus"
        },
      })
    end
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
    "catppuccin/nvim",
    name = "catppuccin",
    init = function()
      -- must be called before opts -> that why init func and not conf
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
    opts = {
      transparent_background = true,
    },
    priority = 1000
  },

  {
    'sainnhe/everforest',
    name = "everforest",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd("let g:everforest_background = 'hard'")
      vim.cmd("let g:everforest_foreground = 'hard'")
      vim.cmd("let g:everforest_transparent_background = '1'")
      vim.cmd("let g:everforest_diagnostic_virtual_text = 'colored' ")
      --vim.cmd([[colorscheme everforest]])
    end
  },

  {
    -- The Main Theme
    'sainnhe/gruvbox-material',
    -- lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      --require("gruvbox-material").setup({
      --  foreground = 'original'
      --})


      -- has no impact as backround is turned off
      vim.cmd("let g:gruvbox_material_background = 'medium'")
      vim.cmd("let g:gruvbox_material_foreground = 'material'")
      vim.cmd("let g:gruvbox_material_transparent_background = '1'")
      vim.cmd("let g:gruvbox_material_diagnostic_virtual_text = 'colored' ")
      --vim.cmd([[colorscheme gruvbox-material]])
    end,
  }
  ,
  {
    'ribru17/bamboo.nvim'
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true
    },
  }
  ,
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    opts = {
      transparent = true,
    },
  }
}
