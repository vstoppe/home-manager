{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vst";
  home.homeDirectory = "/Users/vst";

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
    bat # colorful cat alternative
  	docker
  	docker-compose
    cargo
    curl
    k9s
    krew
    kubecolor
    kubectl
    kubernetes-helm
    kubeswitch
    neovim
    nix # nix-build not found without this pakage
    nmap
    nodejs_18  # neovim / ls dependency
    ripgrep    # neovim / telescope dependency
    rsync
    rustc
    shellcheck # neovim / lsp depencency
    unixtools.watch
    vagrant
    virt-manager
    wget
    xsel      # neovim dep
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
    DOCKER_HOST="ssh://vst@irix";
    EDITOR = "nvim";
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
      gs = "git status";
      gp = "git push";
      ll = "ls -lh";
      update = "home-manager switch";
      ws  = "cd ~/workspace/";
      wsa = "cd ~/workspace/ansible";
      kubectl = "kubecolor --light-background";
      k = "kubectl";
      nvim = "nvim -u ~/.config/nvim/init.lua";
      nixvim = "nvim";
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
