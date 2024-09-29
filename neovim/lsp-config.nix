{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-helm #  <== for helm file highlight
      SchemaStore-nvim  #  <== manage yaml schemata: https://github.com/b0o/SchemaStore.nvim/
    ];

    extraConfig = ''
      lua << END

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
        local on_attach = function(client, bufnr)
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
        lspconfig.pylsp.setup(
          { 
            on_attach = on_attach, 
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
                }
              }
          }
        )
        require('lspconfig').bashls.setup{}
        require('lspconfig').lua_ls.setup {}
        require('lspconfig').nil_ls.setup {}
        require('lspconfig').vimls.setup{}
        require('lspconfig').rust_analyzer.setup{
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = true;
              }
            }
          }
        }

        local cfg = require("yaml-companion").setup {
          -- detect k8s schemas based on file content
          builtin_matchers = {
            kubernetes = { enabled = true }
          },

          -- schemas available in Telescope picker
          schemas = {
            -- not loaded automatically, manually select with
            -- :Telescope yaml_schema
            {
              name = "Argo CD Application",
              uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"
            },
            {
              name = "Argo Workflows",
              uri  = "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"
            },
            {
              name = "docker-compose.yml",
              uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"

            },
            {
              name = "helmfile",
              uri = "https://json.schemastore.org/helmfile.json"

            },
            {
              name = 'Helm Chart.yaml',
              uri  = 'https://json.schemastore.org/chart.json'
            },
            {
              name = "SealedSecret",
              uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json"
            },
            -- schemas below are automatically loaded, but added
            -- them here so that they show up in the statusline
            {
              name = "Kustomization",
              uri = "https://json.schemastore.org/kustomization.json"
            },
            {
              name = "GitHub Workflow",
              uri = "https://json.schemastore.org/github-workflow.json"
            },
          },

          lspconfig = {
            settings = {
              yaml = {
                validate = true,
                schemaStore = {
                  enable = false,
                  url = ""
                },

                -- schemas from store, matched by filename
                -- loaded automatically
                -- catalog: https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
                schemas = require('schemastore').yaml.schemas {
                  select = {
                    'Argo Workflows',
                    'Helm Chart.yaml',
                    'Helm Chart.lock',
                    'helmfile',
                    'Helm Unittest Test Suite',
                    'docker-compose.yml',
                    'helmfile',
                    'kustomization.yaml',
                  },
                  -- additional schemas (not in the catalog)
                  extra = {
                    {
                      url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
                      name = 'Argo CD Application',
                    }
                  }
                }
              }
            }
          }
        }

        require("lspconfig")["yamlls"].setup(cfg)
        require("telescope").load_extension("yaml_schema")







        -- Here we differentiate yaml from helm files:
        -- vim.filetype.add({
        --   pattern = {
        --     [".*/templates/.*%.yaml"] = "helm",
        --   },
        -- })


        -- require'lspconfig'.helm_ls.setup{
        --   settings = {
        --     ['helm-ls'] = {
        --       yamlls = {
        --         path = "yaml-language-server",
        --       }
        --     }
        --   }
        -- }




      END
      '';
  };
}
