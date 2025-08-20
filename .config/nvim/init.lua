--[[

=====================================================================
==================== Florian Findelsberger ==========================
=====================================================================

--]]

-- remove this if this issue is resolved -> https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

require("custom.neovim_settings")
require("custom.keymappings")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  -- 27.Januar : setzt mein zeug immer auf tabstop = 8 in den cpp files von rtgi was ned stimmt-> deswegen erstmal raus damit
  --'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',   opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  -- "gc" to comment visual regions/lines
  -- checkhealth warning: apparently which-key does not like that comment.nvim has multiple
  -- mappings to the same keystroaks in different modes hence it shows a duplicate key mapping warning
  { 'numToStr/Comment.nvim',  opts = {} },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" }
	},

  -- import all the other plugins
  { import = 'custom.plugins' },
}, {})

--07.08.2023 : When changing colorschme using the colorschme command the highlight groups would reset.
--              with this autocommand we make sure that the highlight groups get cleared every time the Theme is changed
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


--======================================================================================================================
--==================================================== MY COMMANDS =====================================================
--======================================================================================================================

vim.api.nvim_create_user_command('Dblock', function(opts)
  local text = opts.args or ""
  local len = #text
  local sides = (118 - len) / 2

  local dashes = "//"
  dashes = dashes .. string.rep('-', sides) .. text .. string.rep('-', sides)
  vim.api.nvim_put({ dashes }, 'l', true, true)
end, {
  nargs = '?',
})

vim.api.nvim_create_user_command('Pblock', function(opts)
  local text = opts.args or ""
  local len = #text
  local sides = (118 - len) / 2

  local start = "//" .. string.rep('=', 118)
  local middle = "//" .. string.rep('=', sides - 1) .. " " .. text .. " " .. string.rep('=', sides - 1)
  local ende = "//" .. string.rep('=', 118)
  local lines = { start, middle, ende }
  vim.api.nvim_put(lines, 'l', true, true)
end, {
  nargs = '?'
})

----------------------------------------------------- COMPILE COMMAND --------------------------------------------------

local stored_ccomand = nil

vim.api.nvim_create_user_command("CComand", function(opts)
  stored_ccomand = opts.args
end, {
  nargs = 1,
  desc = "Store a compile command for the current nvim session"
})

vim.api.nvim_create_autocmd("User", {
  pattern = "RunCcomand",
  desc = "Run the stored compile command",
  callback = function()
    local term = require("toggleterm");
    if stored_ccomand then
      term.exec(stored_ccomand)
    else
      print("No stored compile command. Use 'CComand' to store a compile command")
    end
  end
})

vim.keymap.set("n", "<leader>C", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "RunCcomand" })
end, {
  silent = true,
  noremap = true,
  desc = "run compile command"
})


----------------------------------------------------- RUN COMMAND --------------------------------------------------


local stored_rcomand = nil

vim.api.nvim_create_user_command("RComand", function(opts)
  stored_rcomand = opts.args
end, {
  nargs = 1,
  desc = "Store a compile command for the current nvim session"
})

vim.api.nvim_create_autocmd("User", {
  pattern = "RunRcomand",
  desc = "Run the stored compile command",
  callback = function()
    local term = require("toggleterm");
    if stored_rcomand then
      term.exec(stored_rcomand)
    else
      print("No stored run command. Use 'RComand' to store a compile command")
    end
  end
})

vim.keymap.set("n", "<leader>R", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "RunRcomand" })
end, {
  silent = true,
  noremap = true,
  desc = "execute run command"
})

------- compile and run command with neovim terminal and not toggle term

local t_state = {
  buf = -1,
  win = -1,
}

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local create_term = function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
  return vim.bo.channel
end

local job_id = 0
vim.keymap.set("n", "<space>st", function()
  job_id = create_term();
end)

vim.keymap.set("n", "<space>send", function()
  if job_id == 0 then
    job_id = create_term()
  end

  local command = stored_ccomand .. "\r\n"
  vim.fn.chansend(job_id, { command })
end)





-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
