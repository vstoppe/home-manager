{ config, pkgs, ... }:

{
  programs.neovim = {

    extraLuaConfig = ''
        vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
      '';
  };
}
