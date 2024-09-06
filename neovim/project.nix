{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      plenary-nvim # just a dependency for neovim-project
    ];

  # All other neovim-project setup resides in packer.nix
  # due to lack of nix-packages.

  };
}
