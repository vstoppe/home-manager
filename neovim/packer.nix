{ config, pkgs, ... }:

{
  programs.neovim = {
    ### packer for packages which are not available in nixpkgs.
    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];

    extraConfig = ''
      lua << END

        return require('packer').startup(function(use)

        -- install the indent-tools
        use({
          "arsham/indent-tools.nvim",
          requires = {
            "arsham/arshlib.nvim",
            "nvim-treesitter/nvim-treesitter-textobjects",
          },
          config = function()
            require("indent-tools").config({})
          end,
        })

        use { "dapc11/telescope-yaml.nvim" }

        use {
          "cuducos/yaml.nvim",
          ft = { "yaml" }, -- optional
        }
      

        -- install markdown support
        use({
            'MeanderingProgrammer/render-markdown.nvim',
            -- after = { 'nvim-treesitter' }, -- dep not found by packer / should be installed by nix
            requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
            -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
            requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
            config = function()
                require('render-markdown').setup({})
            end,
        })


        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
          require('packer').sync()
        end
      end)

      END
      '';
  };
}
