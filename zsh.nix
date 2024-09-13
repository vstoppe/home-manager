{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-fzf-tab
  ];

  programs.dircolors.enable = true;

  programs.fzf = {
    enable = true;
  };



  programs.zsh = {
    enable = true;
    autocd = true;
    prezto = {
      # configuration framework for zsh
      enable = true;
      caseSensitive = false;
    }; 
    initExtra = ''
      compdef kubecolor=kubectl
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
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
}
