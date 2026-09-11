return {
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
			},
			overrides = function()
				return {
					-- Type = { fg = "#86985D" },
					Number = { fg = "#86985D" },
					["@variable.member"] = { fg = "#A292A3" },
					["@variable.member.rust"] = { fg = "#A292A3" },
				}
			end,
		},
	}
}
