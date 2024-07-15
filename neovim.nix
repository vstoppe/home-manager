{ config, pkgs, ... }:

{
  imports = [
    ./neovim/completion.nix
    ./neovim/keymaps.nix
    ./neovim/lsp-config.nix
    ./neovim/lualine.nix
    ./neovim/nvim-tree.nix
    ./neovim/options.nix
    ./neovim/treesitter.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      lua-language-server
      yaml-language-server
      nodePackages.bash-language-server
      nil # <== language-server for nix
    ];

    # this is a function taking a package as an argument:
    # Python packages which need to be available for nvim
    # have to go here:
    # extraPython3Packages = (ps: with ps; [
    #   autopep8
    # ]);


    plugins = with pkgs.vimPlugins; [
      autoclose-nvim
      gruvbox-nvim
      indent-blankline-nvim
      nvim-comment
      nvim-surround
      nvim-web-devicons # needed for lualine-nvim
      vim-fugitive
      vim-nix
      vim-sort-motion
    ];


    extraConfig = ''
      lua << END

          -- require('rainbow-delimiters.setup').setup()
          require('autoclose').setup()

          -- setup indent-blankline: add lines to help identify indentions
          require('ibl').setup()

          -- helps in changeing surroundings (eg. "\', \" ")
          require('nvim-surround').setup()

          -- helps un/commenting lines:
          require('nvim_comment').setup()
      END

        colorscheme gruvbox

        " Enable syntax highlighting
        syntax enable
    '';
  };
}
