return {
	"nvim-tree/nvim-tree.lua",             -- Filesystem navigation
	dependencies = "nvim-tree/nvim-web-devicons", -- Filesystem icons
	opts = {},
	keys = {
		{ "<leader>nt", "<Cmd>NvimTreeToggle<CR>",   desc = "[N]vim[T]ree toggle" },
		{ "<S-F1>",     "<Cmd>NvimTreeFindFile<CR>", desc = "NvimTree find file" }
	}
}
