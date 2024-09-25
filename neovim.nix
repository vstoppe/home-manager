{ config, pkgs, ... }:

{
  imports = [
    ./neovim/completion.nix
    ./neovim/keymaps.nix
    ./neovim/lsp-config.nix
    ./neovim/lualine.nix
    ./neovim/nvim-tree.nix
    ./neovim/options.nix
    ./neovim/packer.nix
    ./neovim/project.nix
    ./neovim/telescope.nix
    ./neovim/treesitter.nix
  ];

  home.packages = with pkgs; [

    nodejs_18  # neovim / ls dependency
    helm-ls    # helm-language-server binary
    ripgrep    # neovim / telescope dependency
    shellcheck # neovim / lsp depencency
    xsel       # neovim dep
    (pkgs.python311.withPackages (ppkgs: with ppkgs; [
      # some neovim python plugins search for dependencies here, not programs.neovim.extraPython3Packages!!!
      autopep8 # <== kick in auto-lintng with pylsp
      flake8
      jedi # <= Provides Completions, Definitions, Hover, Referpnces, Signature Help, and Symbols for pylsp
      kubernetes
      mccabe
      pycodestyle
      pyflakes
      python-lsp-server
      rope # <== for Completions and renaming (pylsp)
    ]))
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      yaml-language-server
      vim-language-server
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
      gitsigns-nvim
      gruvbox-nvim # colorscheme
      indent-blankline-nvim
      nightfox-nvim # colorscheme
      nvim-comment
      nvim-surround
      nvim-web-devicons # needed for lualine-nvim
      telescope-nvim
      vim-flog
      vim-fugitive
      vim-nix
      vim-sort-motion
      vim-tmux-navigator
    ];


    extraConfig = ''
      lua << END

          -- require('rainbow-delimiters.setup').setup()
          require('autoclose').setup({
            keys = {
              -- In Markdown autoclose the backticks is annoying for codeblocks ("```")
              ["`"] = { close = false, disabled_filetypes = { "markdown"} },
            },
          })

          -- setup indent-blankline: add lines to help identify indentions
          require('ibl').setup()

          -- helps in changeing surroundings (eg. "\', \" ")
          require('nvim-surround').setup()

          -- helps un/commenting lines:
          require('nvim_comment').setup()

          require('gitsigns').setup({
            on_attach = function(bufnr)
              local function map(mode, lhs, rhs, opts)
                  opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
              end

              map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>")
              map("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>")
            end
          })
      END

        colorscheme dawnfox

        " Enable syntax highlighting
        syntax enable
    '';
  };
}
