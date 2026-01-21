{ config, pkgs, ... }:

{
  imports = [
    ./neovim/completion.nix
    ./neovim/keymaps.nix
    ./neovim/lsp-config.nix
    ./neovim/lualine.nix
    ./neovim/neogit.nix
    ./neovim/nvim-tree.nix
    ./neovim/user-commands.nix
    ./neovim/options.nix
    ./neovim/packer.nix
    ./neovim/neoscroll.nix
    ./neovim/telescope.nix
    ./neovim/treesitter.nix
  ];

  home = {
    file = {
      ".config/nvim/after/lsp/helm_ls.lua".source = neovim/helm_ls.lua;
      ".config/nvim/after/lsp/yamlls".source      = neovim/yamlls.lua;
      ".config/nvim/queries/nix/injections.scm".source  = neovim/queries/nix/injections.scm;
      ".config/nvim/queries/yaml/injections.scm".source = neovim/queries/yaml/injections.scm;
      ".config/nvim/ftplugin/helm.lua".source = neovim/ftplugin/helm.lua;
    };

    packages = with pkgs; [
      helm-ls    # helm-language-server binary
      nodejs_20  # neovim / ls dependency
      ripgrep    # neovim / telescope dependency
      shellcheck # neovim / lsp depencency
      tree-sitter
      xsel       # neovim dep
      yaml-language-server
      (pkgs.python313.withPackages (ppkgs: with ppkgs; [
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
  };

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
      animation-nvim # dependency for nvim-windows
      autoclose-nvim
      b64-nvim
      catppuccin-nvim # colorscheme
      diffview-nvim # neogit dep for viewing diffs
      flash-nvim # better key navigation / jumping
      gitsigns-nvim
      gruvbox-nvim # colorscheme
      indent-blankline-nvim
      indent-tools-nvim
      middleclass # dependency for nvim-windows
      mini-icons # support for render-markdown
      mini-nvim  # support for render-markdown
      neogit
      nightfox-nvim # colorscheme
      nvim-comment # https://github.com/terrortylor/nvim-comment
      nvim-surround
      nvim-ts-context-commentstring # get ft for nvim-comment
      nvim-web-devicons # needed for lualine-nvim
      plenary-nvim # a dependency for neovim-project
      render-markdown-nvim
      telescope-nvim
      treesj # expandes single lines with multiple braces to multiline code
      vim-flog
      vim-nix
      vim-sort-motion
      vim-tmux-navigator
      windows-nvim
    ];

    extraLuaConfig = ''
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
      require('nvim_comment').setup({
        hook = function()
          require('ts_context_commentstring').update_commentstring()
        end,
      })

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

      -- colorscheme settings
      require("catppuccin").setup({
        transparent_background = true,
        ingegrations = {
          treesitter_context = true,
        }
      })
      vim.cmd.colorscheme "catppuccin"

      require('treesj').setup()

      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })

      require('flash').setup({
        modes = {
          search = {
            enabled = false
          },
          char = {
            jump_labels = true
          }
        }
      })

      -- In command line mode toggle between normal and flash search:
      vim.keymap.set('c', '<c-s>', function() require("flash").toggle() end)
      -- append a flash movement after a command:
      vim.keymap.set('o', 'r',     function() require("flash").remote() end)

      require("windows").setup({
         autowidth = {
            enable = true,
            winwidth = 1.1,
            filetype = {
               help = 2,
            },
         },
         ignore = {
            buftype = { "quickfix" },
            filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "gitsigns-blame" }
         },
         animation = {
            enable = true,
            duration = 100,
            fps = 60,
            easing = "in_out_sine"
         }
      })


    '';

    extraConfig = ''
      set nowrap
    '';
  };
}
