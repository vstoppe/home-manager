{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-fzf-tab
    zinit # plugin manager
  ];


  programs = {

    dircolors.enable = true;

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

    zsh = {
      enable = true;
      autocd = true;
      prezto = {
        # configuration framework for zsh
        enable = true;
        caseSensitive = false;
      }; 
      initExtraBeforeCompInit= ''
        ### initialize zinit plugin manager
        # do "touch $ZINIT[MAN_DIR]/man1/zinit.1" to prevent "/zinit.1: No such file or directory" error
        source "$HOME/.nix-profile/share/zinit/zinit.zsh"
        zinit snippet OMZP::eza
        zinit snippet OMZP::git
        zinit snippet OMZP::kubectl
        zinit snippet OMZP::kubectx
        
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
      '';
      initExtra = ''
        ### cdreplay should be anabled, throws an error, but nothing is missing
        # zinit cdreplay -q  # Replay compdefs (to be done after compinit)
        compdef kubecolor=kubectl
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
        e = "exit";
        gb = "git branch";
        gp = "git push";
        gs = "git status";
        h3 = "helm";
        k = "kubectl";
        kubectl = "kubecolor --light-background";
        # l  = "eza -l";
        # ll = "ls -lh";
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
  };
}
