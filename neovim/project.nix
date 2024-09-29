{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = plenary-nvim; # just a dependency for neovim-project
        config = ''
          packadd! plenary-nvim
        '';
      }
    ];

  # All other neovim-project setup resides in packer.nix
  # due to lack of nix-packages.

  };
}
