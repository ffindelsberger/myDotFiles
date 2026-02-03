return {
	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		main = "ibl",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- :help ibl.setup()
		opts = {},
		config = function()
			require("ibl").setup {
				indent = {
					char = '┊',
				},
				scope = {
					show_start = false,
					show_end = true
				},
				whitespace = {
					remove_blankline_trail = true,
				},
			}
		end
	},
}
