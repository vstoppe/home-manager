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
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${config.home.homeDirectory}/.config/posh-theme-zen.json"));
    };

    dircolors.enable = true;

    ### The better "ls"
    eza = {
      enable = true;
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
        kubectl = "kubecolor --light-background";
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
      completionInit = "autoload -U +X compinit && compinit";

      history = {
        extended = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };     historySubstringSearch.enable = true;

      initExtra = ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source <(kubectl completion zsh)
        compdef kubecolor=kubectl
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first $realpath'  # dir preview
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        zstyle ':omz:plugins:iterm2 shell-integration yes'
      '';

      localVariables = {
        PATH="$HOME/.nix-profile/bin:/usr/local/bin:$HOME/.krew/bin:$PATH:$HOME/.garden/bin";
        PAGER="nvimpager";
      };

      prezto = {
        # configuration framework for zsh
        enable = true;
        caseSensitive = false;
      }; 

      # enableAutosuggestions = true; <== outdated with 24.05
      syntaxHighlighting.enable = true;
      shellAliases = {
        cd = "z";
        e = "exit";
        h3 = "helm";
        kubectl = "kubecolor --light-background"; # <= makes problems for auto completion
        ns  = "switch ns";
        update = "home-manager switch";
        wp = "watch kubectl get po";
        ws  = "cd ~/workspace/";
        ws3 = "cd ~/workspace/k3s";
        wsa = "cd ~/workspace/ansible";
        wsh = "cd ~/workspace/homelab";
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
