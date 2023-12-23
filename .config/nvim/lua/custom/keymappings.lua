-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Up and down halg page and keep cursor in the middle
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Diagnostic keymaps
-- TODO: next and previous diagnostic should be in same key gourp i.E both should start with same key and afther that the direction is chosen
vim.keymap.set('n', '<leader>kd', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>jd', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--
-- leader s would be way better for save but i alredy have all my telescope bindings on s and w is already for workspace commands
vim.keymap.set('n', "<leader>l", "<cmd> w <CR>", { desc = 'save the file' })
vim.keymap.set('n', "<C-s>", "<cmd> w <CR>", { desc = 'save the file' })

-- "find" and replace the current word
vim.keymap.set("n", "<leader>fn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[F]find and [R]eplace word" })
