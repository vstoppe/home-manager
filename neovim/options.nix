{ config, pkgs, ... }:

{
  programs.neovim = {

    extraConfig = ''
      lua << END

        -- Set leader key to space
        vim.g.mapleader = ' '

        -- Hint: use `:h <option>` to figure out the meaning if needed
        vim.opt.clipboard = 'unnamedplus'   -- use system clipboard
        vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
        vim.opt.mouse = 'a'                 -- allow the mouse to be used in Nvim

        -- Tab
        vim.opt.tabstop = 2                 -- number of visual spaces per TAB
        vim.opt.softtabstop = 2             -- number of spacesin tab when editing
        vim.opt.shiftwidth = 2              -- insert 4 spaces on a tab
        vim.opt.expandtab = true            -- tabs are spaces, mainly because of python

        -- UI config
        vim.opt.number = true               -- show absolute number
        vim.opt.relativenumber = true       -- add numbers to each line on the left side
        vim.opt.cursorline = true           -- highlight cursor line underneath the cursor horizontally
        vim.opt.splitbelow = true           -- open new vertical split bottom
        vim.opt.splitright = true           -- open new horizontal splits right
        -- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
        vim.opt.showmode = false            -- we are experienced, wo don't need the "-- INSERT --" mode hint

        -- Searching
        vim.opt.incsearch = true            -- search as characters are entered
        vim.opt.hlsearch = true            -- highlight matches
        vim.opt.ignorecase = true           -- ignore case in searches by default
        vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered

        -- Telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

        -- nvim-tree --
        vim.opt.termguicolors = true
        local nvimtree = require("nvim-tree.api")
        vim.keymap.set('n', '<leader>tt', nvimtree.tree.toggle, {})
        -- vim-tree / nvim-project --
        vim.keymap.set('n', '<leader>dp', '<Cmd>Telescope neovim-project discover<CR>', {})
        vim.keymap.set('n', '<leader>ph', '<Cmd>Telescope neovim-project history<CR>', {})
        vim.keymap.set('n', '<leader>rp', '<Cmd>NeovimProjectLoadRecent<CR>', {})

        -- in insert mode move cursor one char right by pressing <ctrl>f
        vim.keymap.set('i', '<c-f>', '<right>', {})

        vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

      END
      '';
  };
}
