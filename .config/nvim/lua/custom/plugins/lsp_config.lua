function set_generel_lsp_config(bufnr)
  -- In this case, we create_ a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>sl', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Lsp [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

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
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border_round }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border_round }),
}


-- function set_jdtl_lsp_config(jdtls, bufnr)
--   local nmap = function(keys, func, desc)
--     if desc then
--       desc = 'LSP: ' .. desc
--     end
--
--     vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--   end
--   -- Java extensions provided by jdtls
--   nmap("<leader>ei", jdtls.organize_imports, "Organize imports")
--   nmap("<leader>ev", jdtls.extract_variable, "Extract variable")
--   nmap("<leader>ec", jdtls.extract_constant, "Extract constant")
--   vim.keymap.set('v', "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
--     { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })
-- end

--  Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local lsp_servers = {
  -- gopls = {},
  -- pyright = {},
  --astro = {},
  rust_analyzer = {},
  clangd = {},
  --gopls = {},

  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

--  This function gets run when an LSP connects to a particular buffer.
-- This is the default on_attach function for every lsp which does not need custome handling/configuration
local on_attach_default = function(_, bufnr)
  set_generel_lsp_config(bufnr)
end


return {
  -- TODO: cleanup this file, autoformat should be in extra plugin folder
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'williamboman/mason.nvim',
        config = true
      },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        opts = {}
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/neodev.nvim',
        opts = {}
      },
      -- LSP Extensions for i.E. Java
      {
        'mfussenegger/nvim-jdtls'
      }
    },
    config = function()
      -- [[ Configure LSP ]]

      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(lsp_servers),
      }

      local lsp_config = require('lspconfig')

      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      mason_lspconfig.setup_handlers {
        function(server_name)
          lsp_config[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach_default,
            settings = lsp_servers[server_name],
            handlers = handlers,
          }
        end,
        -- We have to register a dedicated handler for rust_analyzer becaue it is managed
        -- by the rust-tools plugin
        -- a handler override for the `rust_analyzer`:
        -- see ':h mason-lspconfig-commands'
        ["rust_analyzer"] = function()
          vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
              float_win_config = {
                border = 'rounded'
              }
            },
            -- LSP configuration
            server = {
              on_attach = function(_, bufnr)
                set_generel_lsp_config(bufnr)
                -- you can also put keymaps in here
              end,
              settings = {
                -- rust-analyzer language server configuration
                -- ['rust-analyzer'] = {
                --   --handlers = handlers,
                -- },
              },
            },
            -- DAP configuration
            dap = {
            },
          }
        end,
        -- ["jdtls"] = function()
        --   local home = os.getenv('HOME')
        --   local jdtls = require "jdtls";
        --
        --   -- File types that signify a Java project's root directory. This will be
        --   -- used by eclipse to determine what constitutes a workspace
        --   local root_markers = { 'gradlew', 'mvnw', '.git' }
        --   local root_dir = require('jdtls.setup').find_root(root_markers)
        --
        --   -- eclipse.jdt.ls stores project specific data within a folder. If you are working
        --   -- with multiple different projects, each project must use a dedicated data directory.
        --   -- This variable is used to configure eclipse to use the directory name of the
        --   -- current project found using the root_marker as the folder for project specific data.
        --   local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
        --
        --   local config = {
        --     root_dir = root_dir,
        --     on_attach = function(client, bufnr)
        --       set_generel_lsp_config(bufnr)
        --       set_jdtl_lsp_config(jdtls, bufnr)
        --     end,
        --     settings = {
        --       java = {
        --         format = {
        --           settings = {
        --             -- Use Google Java style guidelines for formatting
        --             -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
        --             -- and place it in the ~/.local/share/eclipse directory
        --             url = "/.local/share/eclipse/eclipse-java-google-style.xml",
        --             profile = "GoogleStyle",
        --           },
        --         },
        --         signatureHelp = { enabled = true },
        --         contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
        --         -- Specify any completion options
        --         completion = {
        --           favoriteStaticMembers = {
        --             "org.hamcrest.MatcherAssert.assertThat",
        --             "org.hamcrest.Matchers.*",
        --             "org.hamcrest.CoreMatchers.*",
        --             "org.junit.jupiter.api.Assertions.*",
        --             "java.util.Objects.requireNonNull",
        --             "java.util.Objects.requireNonNullElse",
        --             "org.mockito.Mockito.*"
        --           },
        --           filteredTypes = {
        --             "com.sun.*",
        --             "io.micrometer.shaded.*",
        --             "java.awt.*",
        --             "jdk.*", "sun.*",
        --           },
        --         },
        --         -- Specify any options for organizing imports
        --         sources = {
        --           organizeImports = {
        --             starThreshold = 9999,
        --             staticStarThreshold = 9999,
        --           },
        --         },
        --         -- How code generation should act
        --         codeGeneration = {
        --           toString = {
        --             template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        --           },
        --           hashCodeEquals = {
        --             useJava7Objects = true,
        --           },
        --           useBlocks = true,
        --         },
        --         -- If you are developing in projects with different Java versions, you need
        --         -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
        --         -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        --         -- And search for `interface RuntimeOption`
        --         -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        --         configuration = {
        --           runtimes = {
        --             {
        --               name = "JavaSE-21",
        --               path = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home",
        --             },
        --             {
        --               name = "JavaSE-17",
        --               path = "/Users/florianfindelsberger/Library/Java/JavaVirtualMachines/corretto-17.0.9/Contents/Home",
        --             },
        --             {
        --               name = "JavaSE-1.8",
        --               path =
        --               "/Users/florianfindelsberger/Library/Java/JavaVirtualMachines/corretto-1.8.0_392/Contents/Home"
        --             },
        --           }
        --         }
        --       }
        --     },
        --
        --   }
        --   jdtls.start_or_attach(config)
        --end
        -- ["tsserver"] = function()
        --   lsp_config.tsserver.setup({
        --     on_attach = on_attach_default,
        --     capabilities = capabilities,
        --     settings = lsp_servers["tsserver"],
        --     filetypes = {
        --       "javascript",
        --       "typescript",
        --       "astro"
        --     },
        --   })
        -- end,
        -- ["astro"] = function()
        --   lsp_config.astro.setup {
        --     on_attach = on_attach_default,
        --     capabilities = capabilities,
        --     settings = lsp_servers["astro"],
        -- end
      }



      -- Configurete Autoformatting
      --

      -- Switch for controlling whether you want autoformatting.
      --  Use :KickstartFormatToggle to toggle autoformatting on or off
      local format_is_enabled = true
      vim.api.nvim_create_user_command('KickstartFormatToggle', function()
        format_is_enabled = not format_is_enabled
        print('Setting autoformatting to: ' .. tostring(format_is_enabled))
      end, {})

      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = 'lsp-format-' .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      -- Whenever an LSP attaches to a buffer, we will run this function.
      --
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
        -- This is where we attach the autoformatting for reasonable clients
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            print(tostring(client.name) .. 'does not support document Formatting')
            return
          end

          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == 'tsserver' then
            return
          end

          -- Create an autocmd that will run *before* we save the buffer.
          --  Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not format_is_enabled then
                return
              end

              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }
            end,
          })
        end,
      })
    end,

  },

}
