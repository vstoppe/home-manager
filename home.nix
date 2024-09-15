{ config, pkgs, lib, ... }:


{
  imports = [
    ./neovim.nix
    ./shell.nix
  ];

  home = {
    username = builtins.getEnv "USER";  #  <== only works with "--impure" switch
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionPath = [
      "$HOME/bin:$HOME/.rd/bin"
    ];

    stateVersion = "24.05"; # Please read the comment before changing.

    ### common packages 
    packages = with pkgs; [
      # vagrant
      # virt-manager # <== failed to build in 24.05
      bat # colorful cat alternative
      cilium-cli
      dyff
      gcc # also used for neovim / lua stuff
      hubble
      jq
      k9s
      krew
      kubecolor
      kubeswitch
      nix # nix-build not found without this pakage, but might break installation of home-manager env
      nix-du
      p7zip
      yq
      # It is sometimes useful to fine-tune packages, for example, by applying
      # overrides. You can do that directly here, just don't forget the
      # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    ] ++ (if config.home.username == "vst" then 
    [
      # Packages I don't need to install in work environment.
      ansible
      argocd
      cargo
      curl
      docker
      docker-compose
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      netdiscover
      nmap
      operator-sdk # manage operator lifecycle manager
      postgresql_15
      rsync
      rustc
      unixtools.watch
      wakeonlan
      wget
      zsh
    ] 
    else []);


    #programs.git = lib.mkIf (config.home.username == "vst") {
    # packages = lib.mkIf (config.home.username == "vst") = with pkgs; [
    #   kubectx
    # ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
    file = {
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
    sessionVariables = {
      # DOCKER_HOST="ssh://root@onyx";
      EDITOR = "nvim";
      # custom socket for Linux and reuse default socket on Darwin.
      SSH_AUTH_SOCK = if pkgs.stdenv.hostPlatform.isLinux then "\$XDG_RUNTIME_DIR/ssh-agent" else "\$SSH_AUTH_SOCK";   # <= funzt
    };
  };


  services.ssh-agent = {
    # ifLinux enable => true
    enable = pkgs.stdenv.isLinux;
  };


  programs.powerline-go = {
      enable = false;
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

