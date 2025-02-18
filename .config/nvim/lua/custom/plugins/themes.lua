return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		init = function()
			-- must be called before opts -> that why init func and not conf
			-- vim.cmd([[colorscheme catppuccin-mocha]])
		end,
		setup = {
			custome_highlights = {
				function(colors)
					return {
						Type = { fg = colors.peach, bg = colors.peach },
					}
				end
			}
		},
		opts = {
			transparent_background = true,
		},
		priority = 1000
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		init = function()
			vim.cmd([[colorscheme kanagawa-dragon]])
		end,
		opts = {
			transparent = true,
			theme = "dragon"
		},
	}
}
