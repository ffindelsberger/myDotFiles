return {
	{
		"olimorris/codecompanion.nvim",
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic"
				}
			},
			opts = {
				log_level = "TRACE"
			},
			adapters = {
			}
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>cc", function() vim.cmd('CodeCompanionChat toggle') end, desc = "harpoon to file 1", },
		},
	},
}


-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
