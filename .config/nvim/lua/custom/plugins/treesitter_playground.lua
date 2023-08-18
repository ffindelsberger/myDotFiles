return {
  {
    'nvim-treesitter/playground',
    opts = {},
    -- Is currently disabled, causes lagging of neovim when opening lua files like init.lua/ works fine on rust files tho, more testing needed
    enabled = false,
    config = function()
      require("nvim-treesitter.configs").setup {

      }
    end
  },
}
