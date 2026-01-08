local function set_generel_lsp_config(bufnr)
	-- In this case, we create_ a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

	-- nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap('<leader>ls', require('telescope.builtin').lsp_workspace_symbols, '[W]orkspace Lsp [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
	nmap('<leader>F', vim.lsp.buf.format, '[F]ormat Buffer')


	-- Lesser used LSP functionality
	-- did i actually ever use these =
	-- nmap('<leader>la', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	-- nmap('<leader>lr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	-- nmap('<leader>ll', function()
	--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- Specify how the border looks like
-- local border = {
--   { '┌', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '┐', 'FloatBorder' },
--   { '│', 'FloatBorder' },
--   { '┘', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '└', 'FloatBorder' },
--   { '│', 'FloatBorder' },
-- }
local border_round = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

-- LSP settings (for overriding per client)
-- local handlers = {
-- 	["textDocument/hover"] = vim.lsp.buf.hover({ border = border_round }),
-- 	-- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border_round }),
-- 	["textDocument/signatureHelp"] = vim.lsp.buf.signature_help({ border = border_round }),
-- 	-- ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border_round }),
-- }

--  Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local lsp_servers = {
	-- gopls = {},
	-- pyright = {},
	--astro = {},
	-- rust_analyzer = {}, #
	-- clangd = {},
	--gopls = {},

	-- tsserver = {},
	-- lua_ls = {
	-- 	Lua = {
	-- 		workspace = { checkThirdParty = false },
	-- 		telemetry = { enable = false },
	-- 	},
	-- },
}

--  This function gets run when an LSP connects to a particular buffer.
-- This is the default on_attach function for every lsp which does not need custome handling/configuration
local on_attach_default = function(_, bufnr)
	set_generel_lsp_config(bufnr)
end

-- Neovim 11 lsp settings
vim.lsp.config.clangd = {
	cmd = { 'clangd', '--background-index', '--clang-tidy', '--enable-config' },
	root_markers = { 'compile_commands.json', 'compile_flags.txt' },
	filetypes = { 'c', 'cpp', 'cuda' },
}
vim.lsp.enable({ 'clangd' })

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- this seems to be nightly ?
		-- if client:supports_method('textDocument/completion') then
		-- 	vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		-- end

		--Disable Semantic Code Highlighting
		---@diagnostic disable-next-line need-check-nil
		client.server_capabilities.semanticTokensProvider = nil

		--Lsp Keybindings
		local nmap = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end
			vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
		end

		nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

		nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
		nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
		nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

		-- nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
		nmap('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
		nmap('<leader>ls', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Lsp [S]ymbols')

		-- See `:help K` for why this keymap
		-- 03.06.25: This might not be needed since Neovim 0.11. Disabling it for now
		-- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
		nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

		if client:supports_method("textDocument/formatting") then
			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end
	end,
})

-- Start, Stop, Restart, Log commands {{{
vim.api.nvim_create_user_command("LspStart", function()
	vim.cmd.e()
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if opts.args == "" or opts.args == client.name then
			client:stop(true)
			vim.notify(client.name .. ": stopped")
		end
	end
end, {
	desc = "Stop all LSP clients or a specific client attached to the current buffer.",
	nargs = "?",
	complete = function(_, _, _)
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local client_names = {}
		for _, client in ipairs(clients) do
			table.insert(client_names, client.name)
		end
		return client_names
	end,
})

vim.api.nvim_create_user_command("LspRestart", function()
	local detach_clients = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client:stop(true)
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end
	local timer = vim.uv.new_timer()
	if not timer then
		return vim.notify("Servers are stopped but havent been restarted")
	end
	timer:start(
		100,
		50,
		vim.schedule_wrap(function()
			for name, client in pairs(detach_clients) do
				local client_id = vim.lsp.start(client[1].config, { attach = false })
				if client_id then
					for _, buf in ipairs(client[2]) do
						vim.lsp.buf_attach_client(buf, client_id)
					end
					vim.notify(name .. ": restarted")
				end
				detach_clients[name] = nil
			end
			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
	desc = "Get all the lsp logs",
})

-- require("vim.lsp.health").check()
vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("silent checkhealth vim.lsp")
end, {
	desc = "Get all the information about all LSP attached",
})
-- }}}



return {
	-- TODO: cleanup this file, autoformat should be in extra plugin folder
	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
		end,
		opts = {
			tools = {
				float_win_config = {
					border = border_round
				}
			},
			server = {
				on_attach = function(_, bufnr)
					-- first we set the basic keymaps that apply to every lsp
					set_generel_lsp_config(bufnr)


					-- now we confgure the rustaceanvim specific keymappings
					local nmap = function(keys, func, desc)
						if desc then
							desc = 'LSP: ' .. desc
						end
						vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
					end
					nmap('<leader>le', function() vim.cmd.RustLsp('renderDiagnostic') end, 'explain error')
					nmap('<leader>lc', function() vim.cmd.RustLsp('openCargo') end, 'open Cargo')
					nmap('<leader>rf', function() vim.cmd.RustLsp('runnables') end, 'show Runnables')
					nmap('<leader>lm', function() vim.cmd.RustLsp('expandMacro') end, 'expand Macro')
				end,
				capabilities = require('blink.cmp').get_lsp_capabilities()
			}
		}
	}
}
