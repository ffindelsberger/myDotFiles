return {
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
}
