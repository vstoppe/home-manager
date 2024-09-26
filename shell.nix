{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
    zinit # plugin manager
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
      icons = true;
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
      prezto = {
        # configuration framework for zsh
        enable = true;
        caseSensitive = false;
        # prompt = {
        #   theme = "powerlevel10k";
        # }; 
      }; 

      initExtraBeforeCompInit= ''
        ### initialize zinit plugin manager
        # do "touch $ZINIT[MAN_DIR]/man1/zinit.1" to prevent "/zinit.1: No such file or directory" error
        declare -A ZINIT
        declare ZINIT[NO_ALIASES]=1  # do not create aliases for zi or zini / breaks zi (zoxide interactive)
        source "$HOME/.nix-profile/share/zinit/zinit.zsh"
        zinit snippet OMZP::eza
        zinit snippet OMZP::git
        zinit snippet OMZP::kubectl
        zinit snippet OMZP::kubectx
      '';

      initExtra = ''
        compdef kubecolor=kubectl
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --group-directories-first $realpath'  # dir preview
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        zinit cdreplay -q  # Replay compdefs (to be done after compinit)
        # source ~/.p10k.zsh
        # eval "$(oh-my-posh init zsh --config ~/.config/my-posh-theme.toml)"
      '';

      # enableAutosuggestions = true; <== outdated with 24.05
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        extended = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };     historySubstringSearch.enable = true;
      localVariables = {
        PATH="$HOME/.nix-profile/bin:/usr/local/bin:$HOME/.krew/bin:$PATH";
      };
      shellAliases = {
        cd = "z";
        e = "exit";
        h3 = "helm";
        k = "kubectl";
        kubectl = "kubecolor --light-background";
        ns  = "switch ns";
        update = "home-manager switch";
        wp = "watch kubectl get po";
        ws  = "cd ~/workspace/";
        ws3 = "cd ~/workspace/k3s";
        wsa = "cd ~/workspace/ansible";
        wsh = "cd ~/workspace/homelab";
      };
    };
  };
}
