-- The Trouble File contains the Trouble Plugin and each plugin which is mainly used in combination with Trouble, i.E, "todo-comments"

return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below

    },
    config =
        function()
          vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end,
            { desc = "Show project Diagnostics" })
          vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
          vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
          vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
          vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
          vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
        end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    }
  }

}
