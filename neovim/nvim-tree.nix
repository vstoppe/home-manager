{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
    ];

    extraConfig = ''
      lua << END
        require("nvim-tree").setup({
          disable_netrw = true,
          hijack_netrw = true,
          sort_by = "case_sensitive",
          view = {
            width = 30,
            number = true,
            relativenumber = true,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
        })

        -- Set leader key to space
        vim.g.mapleader = ' '

        -- auto close on quitting the last buffer except nvim-tree
        local function is_modified_buffer_open(buffers)
            for _, v in pairs(buffers) do
                if v.name:match("NvimTree_") == nil then
                    return true
                end
            end
            return false
        end

        vim.api.nvim_create_autocmd("BufEnter", {
            nested = true,
            callback = function()
                if
                    #vim.api.nvim_list_wins() == 1
                    and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
                    and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
                then
                    vim.cmd("quit")
                end
            end,
        })

        -- nvim-tree --
        vim.opt.termguicolors = true
        local nvimtree = require("nvim-tree.api")
        vim.keymap.set('n', '<leader>tt', nvimtree.tree.toggle, {})
      END
      '';
  };
}
