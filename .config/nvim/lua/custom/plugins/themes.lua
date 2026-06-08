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
		'EdenEast/nightfox.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('nightfox').setup({
				options = {
					transparent = true,
				}
			})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		init = function()
			vim.cmd([[colorscheme kanagawa-dragon]])
		end,
		opts = {
			keywordStyle = { italic = false },
			transparent = true,
			theme = "dragon",
			colors = {
				palette = {
					-- dragonYellow = "#c0b496",
					dragonYellow = "#bfb59d"
				}
			}
		},
	},
	{
		'sainnhe/everforest',
		lazy = false,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.everforest_enable_italic = true
			vim.g.everforest_transparent_background = 1
		end
	},
	{
		'Mofiqul/vscode.nvim',
		lazy = false,
		config = function()

		end
	},
	{
		"nickkadutskyi/jb.nvim",
		lazy = false,
		-- priority = 1000,
		opts = {},
		config = function()
			require("jb").setup({ transparent = true })
			-- vim.cmd("colorscheme jb")
		end,
	}
}
