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
