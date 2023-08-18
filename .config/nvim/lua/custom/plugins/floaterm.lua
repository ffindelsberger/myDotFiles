return {
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.9 --width=0.9 --autoclose=2 <CR> ",
        { desc = 'Open Floating Term' })
      vim.keymap.set('n', "<leader>t", ":FloatermToggle myfloat<CR>", { desc = 'Floaterm toggle' })
      vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>", { desc = 'close Floaterm' })
    end
  }
}
