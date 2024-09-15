{ config, pkgs, lib, ... }:


{
  imports = [
    ./neovim.nix
    ./shell.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = builtins.getEnv "USER";  #  <== only works with "--impure" switch
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  home.sessionPath = [
    "$HOME/bin:$HOME/.rd/bin"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.


  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
  	docker
  	docker-compose
    # vagrant
    # virt-manager # <== failed to build in 24.05
    ansible
    argocd
    bat # colorful cat alternative
    cargo
    cilium-cli
    curl
    dyff
    gcc # also used for neovim / lua stuff
    git-sync
    hubble
    jq
    k9s
    krew
    kubecolor
    kubectl
    kubectx
    kubernetes-helm
    kubeswitch
	kustomize
    netdiscover
    nix # nix-build not found without this pakage, but might break installation of home-manager env
    nmap
    operator-sdk # manage operator lifecycle manager
    p7zip
    postgresql_15
    rsync
    rustc
    unixtools.watch
    wakeonlan
    wget
    yq
    zsh
    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".p10k.zsh".source = dotfiles/p10k.zsh;

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
    # custom socket for Linux and reuse default socket on Darwin.
    SSH_AUTH_SOCK = if pkgs.stdenv.hostPlatform.isLinux then "\$XDG_RUNTIME_DIR/ssh-agent" else "\$SSH_AUTH_SOCK";   # <= funzt
  };


  services.ssh-agent = {
    # ifLinux enable => true
    enable = pkgs.stdenv.isLinux;
   };


  programs.powerline-go = {
      enable = true;
      modules = [ "venv" "user" "host" "cwd" "perms" "git" "exit" "root" "kube" ];
      settings = { theme = "solarized-dark16"; };
  };


    # Let Home Manager install and manage itself.
  programs.git = lib.mkIf (config.home.username == "vst") {
    enable    =  true;
    userEmail = "vst@lindenbox.de";
    userName  = "vstoppe";
    extraConfig = {
      user = {
        user      = "Volker Stoppe";
      };
    };
  };

  programs.home-manager.enable = true;
}
