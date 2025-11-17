{ config, pkgs, ... }:

{
  programs.neovim = {
    ### packer for packages which are not available in nixpkgs.
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      denops-vim #  <== dep for k8s.vim
    ];

    extraConfig = ''
      lua << END

        return require('packer').startup(function(use)
          use 'wbthomason/packer.nvim' -- this is essential.



        --use { 
        --  "dapc11/telescope-yaml.nvim",
        --  requires = { "dapc11/telescope-yaml.nvim" }
        --}

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


        -- install neovim-project (manager)

        use({
          "coffebar/neovim-project",
          config = function()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
            -- setup neovim-project plugin
            require("neovim-project").setup {
              projects = { -- define project roots
                "~/workspace/*",
                "~/.config/*",
              },
            }
          end,
          requires = {
            { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
            { "Shatur/neovim-session-manager" },
          }
        })

        -- setup k8s extension

        -- use({
        --   "skanehira/k8s.vim",
        --   config = function()
        --     require("k8s").setup()
        --   end,
        -- })

        use({
          "ramilito/kubectl.nvim",
          config = function()
            require("kubectl").setup()
          end,
        })
        vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

        --- setup yaml-companion
        use({
          "someone-stole-my-name/yaml-companion.nvim",
          -- requires = {
          --    { "neovim/nvim-lspconfig" },
          --    { "nvim-lua/plenary.nvim" },
          --    { "nvim-telescope/telescope.nvim" },
          --},
          config = function()
            require("telescope").load_extension("yaml_schema")
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
