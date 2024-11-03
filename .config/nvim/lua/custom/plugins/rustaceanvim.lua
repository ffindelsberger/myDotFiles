return
{
  -- 'mrcjkb/rustaceanvim',
  -- version = '^5', -- Recommended
  -- lazy = false,   -- This plugin is already lazy
  -- config = function(_, opts)
  --   vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
  -- end,
  -- opts = {
  --   server = {
  --     on_attach = function(_, bufnr)
  --       local nmap = function(keys, func, desc)
  --         if desc then
  --           desc = 'LSP: ' .. desc
  --         end
  --         vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  --       end
  --
  --       nmap('<leader>fr', function()
  --         vim.cmd.RustLsp('explainError')
  --       end, 'explain error')
  --       nmap('<leader>fc', function()
  --         vim.cmd.RustLsp('openCargo')
  --       end, 'open Cargo')
  --     end
  --   }
  -- }
}
