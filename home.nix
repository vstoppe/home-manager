{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vst";
  home.homeDirectory = "/Users/vst";
  home.sessionPath = [
    "$HOME/bin"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ansible
    argocd
    bat # colorful cat alternative
  	docker
  	docker-compose
    cargo
    cilium-cli
    curl
    dyff
    git-sync
    jq
    hubble
    k9s
    krew
    kubecolor
    kubectl
    kubectx
    kubernetes-helm
    kubeswitch
    # neovim
    netdiscover
    nix # nix-build not found without this pakage
    nmap
    nodejs_18  # neovim / ls dependency
    operator-sdk # manage operator lifecycle manager
    postgresql_15
    python311Full
    python311Packages.kubernetes
    python311Packages.pip
    python311Packages.pylint
    ripgrep    # neovim / telescope dependency
    rsync
    rustc
    shellcheck # neovim / lsp depencency
    unixtools.watch
    #vagrant
    # vimPlugins.nvim-tree-lua
    virt-manager
    wakeonlan
    wget
    xsel      # neovim dep
    yq
    zsh

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    DOCKER_HOST="ssh://root@onyx";
    EDITOR = "nvim";
  };

  imports = [
    ./neovim/nvim-tree.nix
    ./neovim/options.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #extraConfig = ''
    #'';

    plugins = with pkgs.vimPlugins; [
      autoclose-nvim
      coc-nvim
      gruvbox-nvim
      indent-blankline-nvim
      lualine-nvim
      nvim-comment
      nvim-surround
      nvim-web-devicons # needed for lualine-nvim
      vim-fugitive
      vim-nix
      vim-sort-motion
    ];


    extraConfig = ''
      lua << END
        require('lualine').setup{
          options = { theme = 'gruvbox' }
        }

        require('autoclose').setup()

        -- setup indent-blankline: add lines to help identify indentions
        require('ibl').setup()

        -- helps in changeing surroundings (eg. "\', \" ")
        require('nvim-surround').setup()

        -- helps un/commenting lines:
        require('nvim_comment').setup()
      END


      colorscheme gruvbox


      " Enable line numbers
      set number

      " Enable syntax highlighting
      syntax enable


      " CoC.nvim configuration
      let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-python']

      " Additional settings
      set tabstop=4
      set shiftwidth=4
      set expandtab
      '';



  };

  programs.powerline-go = {
    enable = true;
    modules = [ "venv" "user" "host" "cwd" "perms" "git" "exit" "root" "kube" ];
    settings = { theme = "solarized-dark16"; };
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    initExtra = ''
    compdef kubecolor=kubectl
    '';
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.extended = true;
    historySubstringSearch.enable = true;
    localVariables = {
      PATH="$HOME/.nix-profile/bin:/usr/local/bin:$HOME/.krew/bin:$PATH";
    };
    shellAliases = {
      e = "exit";
      gb = "git branch";
      gp = "git push";
      gs = "git status";
      h3 = "helm";
      k = "kubectl";
      kubectl = "kubecolor --light-background";
      l  = "ls -lh";
      ll = "ls -lh";
      nixvim = "nvim";
      ns  = "switch ns";
      # nvim = "nvim -u ~/.config/nvim/init.lua";
      update = "home-manager switch";
      wp = "watch kubectl get po";
      ws  = "cd ~/workspace/";
      ws3 = "cd ~/workspace/k3s";
      wsa = "cd ~/workspace/ansible";
      wsh = "cd ~/workspace/homelab";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "lxd" ];
      theme = "agnoster";
    };
  };

  # Let Home Manager install and manage itself.
  programs.git = {
    enable    = true;
    #user      = "Volker Stoppe";
    userEmail = "vst@lindenbox.de";
    userName  = "vstoppe";
  };
  programs.home-manager.enable = true;
}
