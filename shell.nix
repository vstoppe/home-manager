{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
    zinit # plugin manager
    zsh-fzf-tab
  ];


  programs = {

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
    };

    ### The better "cd"..
    zoxide = {
      enable = true;
    };


    bash = {
      enable = true;
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
        ns  = "switch ns";
        update = "home-manager switch";
        wp = "watch kubectl get po";
        ws  = "cd ~/workspace/";
        ws3 = "cd ~/workspace/k3s";
        wsa = "cd ~/workspace/ansible";
        wsh = "cd ~/workspace/homelab";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      prezto = {
        # configuration framework for zsh
        enable = true;
        caseSensitive = false;
        prompt = {
          theme = "powerlevel10k";
        }; 
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
        source ~/.p10k.zsh
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

      # plugins = [
      #   {
      #     name = "powerlevel10k-config";
      #     src = ./dotfiles;
      #     file = "p10k.zsh";
      #   }
      # ];
    };
  };
}
