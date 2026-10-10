{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
    zsh-fzf-tab
  ];


  programs = {
    
    oh-my-posh = {
      enable = true;
      # settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${config.home.homeDirectory}/.config/my-posh-theme.json"));
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${config.home.homeDirectory}/.config/home-manager/dotfiles/posh-theme-zen.json"));
    };

    dircolors.enable = true;

    ### The better "ls"
    eza = {
      enable = true;
      colors = "auto";
      enableZshIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--time-style=+%Y-%m-%d %H:%M"
      ];
    };

    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions= [ "-d 40% -p" ];
      };
    };

    ### The better "cd"..
    zoxide = {
      enable = true;
    };

    bash = {
      enable = false;
      enableCompletion = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      initExtra = ''
        # eval "$(oh-my-posh init bash)"
      '';
      shellAliases = {
        cd = "z";
        e = "exit";
        ga = "git add";
        gp = "git push";
        gpu = "git push upstream";
        gst = "git status";
        h3 = "helm";
        k = "kubectl";
        lD = "eza -lD";
        lS = "eza -l -ssize";
        lT = "eza -l -snewest";
        la = "eza -la";
        ll = "eza -l";
        ns  = "switch ns";
        update = "home-manager switch";
        wp = "watch kubectl get po";
        ws  = "cd ~/workspace/";
        ws3 = "cd ~/workspace/k3s";
        wsa = "cd ~/workspace/ansible";
        wsh = "cd ~/workspace/homelab";
      };
    };

    kubecolor = {
      enable = true;
      enableAlias = true;
    };

    powerline-go = {
      enable = false;
      modules = [ "venv" "cwd" "perms" "git" "exit" "root" "kube" ];
      settings = { theme = "solarized-dark16"; };
      newline = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      completionInit = "autoload -Uz compinit";

      history = {
        extended = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };     historySubstringSearch.enable = true;

      initContent = ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source <(kubectl completion zsh)
        compdef kubecolor=kubectl
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first $realpath'  # dir preview
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        #zstyle ':omz:plugins:iterm2 shell-integration yes'
        source $HOME/.nix-profile/etc/profile.d/nix.sh
        source $HOME/.config/home-manager/scripts/set-kubeconfig.sh # script for managing kube configs in multiple files
      '';

      localVariables = {
        PYENV="$HOME/.pyenv";
        PATH="$HOME/.pyenv/bin:$HOME/.nix-profile/bin:/usr/local/bin:$HOME/.krew/bin:$PATH:$HOME/workspace/homelab/automation:$HOME/.config/home-manager/scripts";
        PAGER="nvimpager";
        NIXPKGS_ALLOW_UNFREE=1;
      };

      prezto = {
        # configuration framework for zsh
        enable = true;
        caseSensitive = false;
      }; 

      syntaxHighlighting.enable = true;
      shellAliases = {
        cd = "z";
        e = "exit";
        h3 = "helm";
        ns  = "switch ns";
        update = "home-manager switch";
        wp = "watch kubectl get po";
        ws  = "cd ~/workspace/";
        ws3 = "cd ~/workspace/k3s";
        wsa = "cd ~/workspace/ansible";
        wsh = "cd ~/workspace/homelab";
        fa  = "aerospace list-windows --all | fzf --bind 'enter:execute(bash -c \"aerospace focus --window-id {1}\")+abort'"; # find application
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "plugins/eza"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/kubectl"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/iterm2"; tags = [ "from:oh-my-zsh" ]; }
        ];
      };
    };
  };
}
