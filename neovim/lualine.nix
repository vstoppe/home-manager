{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
    ];

    extraLuaConfig = ''

        local function get_schema()
          local schema = require("yaml-companion").get_buf_schema(0)
          if schema.result[1].name == "none" then
            return ""
          end
          return schema.result[1].name
        end

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
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype', get_schema},
            -- lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {}
        }
      '';
  };
}
