{ config, pkgs, lib, ... }:


{
  imports = [
    ./neovim.nix
    ./shell.nix
    ./tmux.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };


  home = {
    username = builtins.getEnv "USER";  #  <== only works with "--impure" switch
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionPath = [
      "$HOME/bin:$HOME/.rd/bin"
    ];

    stateVersion = "25.05"; # Please read the comment before changing.

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
      kubeswitch
      lynx
      nix # nix-build not found without this pakage, but might break installation of home-manager env
      nix-du
      nvimpager
      p7zip
      toml2json
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
      libdvdcss
      libdvdread
      minikube
      netdiscover
      nmap
      operator-sdk # manage operator lifecycle manager
      podman
      postgresql_15
      rsync
      rustc
      smartmontools
      # talosctl
      unixtools.watch
      vobcopy
      wakeonlan
      wget
      zsh
    ] 
    else []);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
    file = {
    ".config/my-posh-theme.toml".source = dotfiles/my-posh-theme.toml;
    ".config/my-posh-theme.json".source = dotfiles/my-posh-theme.json;
    ".config/posh-theme-zen.toml".source = dotfiles/posh-theme-zen.toml;
    ".config/posh-theme-zen.json".source = dotfiles/posh-theme-zen.json;
    # not usable on chroot nix
    # ".ssh/rc".source = dotfiles/ssh-rc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    sessionVariables = {
      # DOCKER_HOST="ssh://root@onyx";
      # custom socket for Linux and reuse default socket on Darwin.
      # SSH_AUTH_SOCK = if pkgs.stdenv.hostPlatform.isLinux then "\$XDG_RUNTIME_DIR/ssh-agent" else "\$SSH_AUTH_SOCK";   # <= funzt
      KUSTOMIZE_PLUGIN_HOME = "$HOME/.kustomize/plugins";
      XDG_CONFIG_HOME = "$HOME/.config";
    };
  };


  services.ssh-agent = {
    # enable = pkgs.stdenv.isLinux;
    enable = false;
  };



  # Let Home Manager install and manage itself.
  programs = {
    git = lib.mkIf (config.home.username == "vst") {
    enable    =  true;
    userEmail = "vst@lindenbox.de";
    userName  = "vstoppe";
    extraConfig = {
      user = {
        user      = "Volker Stoppe";
      };
    };
  };

  bat = {
    enable = true;
      config = {
        theme = "frappe";
      };
    themes = {
        frappe = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
            sha256 = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
          };
          file = "themes/Catppuccin\ Frappe.tmTheme";
        };
    };
  };
    
  home-manager.enable = true;

  };





}

