{ config, pkgs, ... }:

{
  programs.neovim = {

    extraConfig = ''
      lua << END
        vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })

      END
      '';
  };
}
