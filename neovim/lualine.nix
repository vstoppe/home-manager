{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
    ];

    extraLuaConfig = ''

        ---- function for getting the yaml schema. does not work right now
        local function get_schema()
          local schema = require("schema-companion").get_current_schemas()
          -- print(schema)
          if schema.result[1].name == "none" then
            return "noschema"
          end
          return schema.result[1].name
        end

        --- functions for getting the yaml_path for lualine
        local ts_utils = require("nvim-treesitter.ts_utils")
        local function yaml_path()
          local node = ts_utils.get_node_at_cursor()
          local path = {}

          while node do
            if node:type() == "block_mapping_pair" then
              local key = node:child(0)
              if key then
                table.insert(path, 1, vim.treesitter.get_node_text(key, 0))
              end
            end
            node = node:parent()
          end

          return table.concat(path, ".")
        end

        -- simple keymapping the show the yaml_path interactively
        vim.keymap.set("n", "<leader>yp", function()
          print(yaml_path())
        end, { desc = "Show YAML path" })


        ---- setting up lualine
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 1000,
            }
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            -- lualine_c = {'lsp_status', },
            lualine_x = {'encoding', 'fileformat', 'filetype', 'get_schema'},
            -- lualine_x = {'encoding', 'fileformat', 'filetype', get_schema},
            -- lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          tabline = {
            lualine_c = {
              'filename', {yaml_path, 
              cond = function() 
                return vim.bo.filetype == "yaml" or vim.bo.filetype == "helm" or vim.bo.filetype == "yaml.helm-values"
              end, } },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename' },
            -- lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
          winbar = {},
          inactive_winbar = {},
          extensions = {}
        }
      '';
  };
}
