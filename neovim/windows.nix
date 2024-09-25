{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      windows-nvim # automatic window sizing
      animation-nvim # optinal dependency for windows-vim
    ];

  # All other neovim-project setup resides in packer.nix
  # due to lack of nix-packages.
    extraConfig = ''
      lua << END

        require('animation').setup()
        require('windows').setup()


      END
      '';

  };
}
