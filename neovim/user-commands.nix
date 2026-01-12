{ config, pkgs, ... }:

{
  programs.neovim = {
    extraLuaConfig = ''

      -- Show contents of certificate
      vim.api.nvim_create_user_command("DecodeCert", function()
        vim.cmd("%! openssl x509 -noout -text")
      end, { range = true })

      --  PrettyPrint JSON and Exceptions
      vim.api.nvim_create_user_command("PrettyPrint", function()
        vim.cmd("%! jq .")
        vim.cmd("%s/\\n/\r/")
      end, { range = true})

    '';
  };
}
