--[[

=====================================================================
==================== Florian Findelsberger ==========================
=====================================================================

--]]
require("custom.neovim_settings")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
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
  'tpope/vim-sleuth',
  -- file managing , picker etc
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

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
  { 'numToStr/Comment.nvim',  opts = {} },

  -- require 'kickstart.plugins.debug',
  { import = 'custom.plugins' },
}, {})

-- Fix : indent_blankline resets the colors when the theme is set so we
-- introduce this autocommand to correct them each time the colors are set
-- see https://github.com/lukas-reineke/indent-blankline.nvim/issues/553
-- 18.07.2023 : i dont actually know if i need this anymore, i might have fixed that but dont know how anymore. Should test this but am to lazy right know
-- 07.08.2023 : i deactivated it and did not notice any issues so far
--vim.api.nvim_create_autocmd("ColorScheme", {
--  desc = "Refresh indent colors",
--  callback = function()
--    vim.cmd [[hi IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
--    vim.cmd [[hi IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
--    vim.cmd [[hi IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
--    vim.cmd [[hi IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
--    vim.cmd [[hi IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
--    vim.cmd [[hi IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
--  end,
--})

-- Get that semantic token shit outa here
-- Hide all semantic highlights
-- disables semantic tokens for all lsp`s
-- see https://github.com/simrat39/rust-tools.nvim/issues/365
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
--07.08.2023 : When changing colorschme using the colorschme command the highlight groups would reset.
--              with this autocommand we make sure that the highlight groups get cleared every time the Theme is changed
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
  end,
})

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

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

-- Dont know if they belong to treesitter
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--
-- leader s would be way better for save but i alredy have all my telescope bindings on s
vim.keymap.set('n', "<leader>l", "<cmd> w <CR>", { desc = 'save the file' })
vim.keymap.set('n', "<C-s>", "<cmd> w <CR>", { desc = 'save the file' })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
