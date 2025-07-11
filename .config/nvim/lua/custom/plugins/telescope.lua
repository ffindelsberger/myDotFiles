return {
	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
		config = function()
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require('telescope').setup {
				defaults = {
					border = false, -- to not have double borders because of win.o.borders
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				},
			}

			-- Enable telescope fzf native, if installed
			pcall(require('telescope').load_extension, 'fzf')

			-- See `:help telescope.builtin`
			vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
				{ desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files,
				{ desc = '[ ] Find all Files' })
			vim.keymap.set('n', '<leader>sF', function()
					require('telescope.builtin').find_files {
						cwd = vim.fn.expand("$HOME"),
						hidden = true,
						no_ignore = true,
					}
				end,
				{ desc = '[ ] Find all Files in Home' })
			vim.keymap.set('n', '<leader>/', function()
				require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })

			vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
			vim.keymap.set('n', '<leader>sf', require('telescope.builtin').buffers,
				{ desc = '[S]earch open [F]iles/Buffers' })
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
				{ desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
				{ desc = '[S]earch [D]iagnostics' })
		end
	},
}
