return {
	{
		"olimorris/codecompanion.nvim",
		opts = {
			interactions = {
				chat = {
					adapter = "anthropic",
					model = "claude-opus-4-5"
				}
			},
			adapters = {
				http = {
					openai = function()
						return require("codecompanion.adapters").extend("openai", {
							env = {
								api_key =
								""
							}
						})
					end,
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key =
								""
							},
							{
								schema = {
									model = {
										default = "claude-opus-4-5"
									}
								}
							}
						})
					end
				}
			}
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>cc", function() vim.cmd('CodeCompanionChat adapter=anthropic model=claude-opus-4-5 toggle') end, desc = "Open/Close codecompanion Chat", },
		},
	},
}
