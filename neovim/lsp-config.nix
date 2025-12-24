{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      SchemaStore-nvim  #  <== manage yaml schemata: https://github.com/b0o/SchemaStore.nvim/
      schema-companion-nvim # <== fork of yaml-companion
      helm-ls-nvim # <== helm ft detection, alternative to vim-helm
    ];

    extraLuaConfig = ''

      -- https://github.com/cenk1cenk2/schema-companion.nvim
      require("schema-companion").setup({
        log_level = vim.log.levels.INFO,
      })

      -- Symbols for lsp.diagnostics
      local severity = vim.diagnostic.severity
      vim.diagnostic.config({
        signs = {
          text = {
            [severity.ERROR] = " ",
            [severity.WARN] = " ",
            [severity.HINT] = "󰠠 ",
            [severity.INFO] = " ",
          },
        },
      })

      -- Set different settings for different languages' LSP
      -- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
      --     - the settings table is sent to the LSP
      --     - on_attach: a lua callback function to run after LSP attaches to a given buffer
      local lspconfig = require('lspconfig')

      -- Customized on_attach function
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local lsp_keymappings = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end


      -- Setup the language servers

      vim.lsp.config('pylsp', {
        cmd = { 'pylsp' },
        on_attach = lsp_keymappings,
        filetypes = { 'python' },
        settings = {
          pylsp = {
            configurationSources = "pycodestyle",
            plugins = {
              jedi_completion = {
                enabled = true,
                include_class_objects = true,
                include_function_objects = true,
                fuzzy = true,
                eager = true,
              },
              pylint = {
                enabled = false
              },
              flake8 = {
                enabled = false
              },
              pyls_mypy = {
                enabled = true,
                --live_mode = true,
              },
              rope_autoimport = {
                enabled = true,
                memory = true,
              },
              rope_completion = {
                enabled = true,
              }
            }
          },
        },
      })
        

      vim.lsp.config('rust_analyzer', {
        -- Server-specific settings. See `:help lsp-quickstart`
        on_attach = lsp_keymappings,
        cmd = {'rust-analyzer'},
        filetypes = { 'rust' },
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = true;
            }
          },
        },
      })


      -- Here we differentiate yaml from helm files:
      vim.filetype.add({
        pattern = {
          [".*/templates/.*%.yaml"] = "helm",
        },
      })


      vim.lsp.config('bashls', {
        on_attach = lsp_keymappings,
        filetypes = { 'bash'},
      })

      vim.lsp.config('yamlls', {
        on_attach = lsp_keymappings,
        filetypes = { 'yaml'},
      })

        
      require("helm-ls").setup() -- for helm-ls.nvim plugin
      
      vim.lsp.enable('bashls')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('nil_ls')
      vim.lsp.enable('pylsp')
      vim.lsp.enable('helm_ls')
      vim.lsp.enable('yamlls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('vimls')

    '';
  };
}
