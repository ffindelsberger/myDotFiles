return {
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		branch = "main",
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			branch = "main"
		},
		build = ':TSUpdate',
		init = function()
			-- -- Enable Highlighting
			-- vim.api.nvim_create_autocmd('FileType', {
			-- 	pattern = { '<filetype>' },
			-- 	callback = function() vim.treesitter.start() end,
			-- })

			vim.api.nvim_create_autocmd('FileType', {
				callback = function()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			local ensure_installed = { 'c', 'rust', 'vimdoc', 'cpp',
				'vim', 'html', 'css', 'toml', 'lua', 'json', 'yaml', 'dockerfile' }
			require('nvim-treesitter').install(ensure_installed)
		end,
		--config = function()
		-- [[ Configure Treesitter ]]
		-- See `:help nvim-treesitter`
		--	require('nvim-treesitter').setup {
		-- indent = { enable = true },
		-- incremental_selection = {
		-- 	enable = true,
		-- 	keymaps = {
		-- 		init_selection = '<c-space>',
		-- 		node_incremental = '<c-space>',
		-- 		scope_incremental = '<c-s>',
		-- 		node_decremental = '<M-space>',
		-- 	},
		-- },
		-- textobjects = {
		-- 	select = {
		-- 		enable = true,
		-- 		lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
		-- 		keymaps = {
		-- 			-- You can use the capture groups defined in textobjects.scm
		-- 			['aa'] = '@parameter.outer',
		-- 			['ia'] = '@parameter.inner',
		-- 			['af'] = '@function.outer',
		-- 			['if'] = '@function.inner',
		-- 			['ac'] = '@class.outer',
		-- 			['ic'] = '@class.inner',
		-- 		},
		-- 	},
		-- 	move = {
		-- 		enable = true,
		-- 		set_jumps = true, -- whether to set jumps in the jumplist
		-- 		goto_next_start = {
		-- 			[']m'] = '@function.outer',
		-- 			[']]'] = '@class.outer',
		-- 		},
		-- 		goto_next_end = {
		-- 			[']M'] = '@function.outer',
		-- 			[']['] = '@class.outer',
		-- 		},
		-- 		goto_previous_start = {
		-- 			['[m'] = '@function.outer',
		-- 			['[['] = '@class.outer',
		-- 		},
		-- 		goto_previous_end = {
		-- 			['[M'] = '@function.outer',
		-- 			['[]'] = '@class.outer',
		-- 		},
		-- 	},
		-- 	swap = {
		-- 		enable = true,
		-- 		swap_next = {
		-- 			['<leader>a'] = '@parameter.inner',
		-- 		},
		-- 		swap_previous = {
		-- 			['<leader>A'] = '@parameter.inner',
		-- 		},
		-- 	},
		-- },
		--	}
		-- end
	},
}
