{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter # should not be install parallel to ..withAllGrammers
      nvim-treesitter.withAllGrammars
      rainbow-delimiters-nvim
    ];

    extraLuaConfig = ''
        local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
        vim.fn.mkdir(parser_install_dir, "p")
        vim.opt.runtimepath:append(parser_install_dir)

        local status_ok, plugin = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
          vim.notify("WARNING: nvim-treetitter.configs failed to load")
          return
        end

        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "bash", "dockerfile", "helm", "gotmpl", "html", "json", "json5", "lua", "nix", "markdown", "python", "query", "rust", "sql", "vim", "vimdoc", "yaml" },

          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = false,

          ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
          -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
          parser_install_dir = parser_install_dir,

          highlight = {
            enable = true,
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
          -- rainbow-delimiters are only activated here:
          rainbow = {
            enable = true,
            query = 'rainbow-parens',
            strategy = require('rainbow-delimiters').strategy['global'],
          },
          indent = { enable = true, disable = { "yaml" } },
        }
      '';
  };
}
