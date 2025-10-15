return {
	{
		"olimorris/codecompanion.nvim",
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic"
				}
			},
			adapters = {
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
						}
					})
				end
			}
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>cc", function() vim.cmd('CodeCompanionChat toggle') end, desc = "Open/Close codecompanion Chat", },
		},
	},
}
