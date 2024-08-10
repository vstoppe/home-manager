{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    initExtra = ''
    compdef kubecolor=kubectl
    '';
    # enableAutosuggestions = true; <== outdated with 24.05
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.extended = true;
    historySubstringSearch.enable = true;
    localVariables = {
      PATH="$HOME/.nix-profile/bin:/usr/local/bin:$HOME/.krew/bin:$PATH";
      # ${if config.stdenv.hostPlatform.isLinux then "SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket; else ""}
      # ${pkgs.lib.mkIf config.stdenv.hostPlatform.isLinux "SSH_AUTH_SOCK"} = true;
      # ${pkgs.lib.mkIf config.stdenv.hostPlatform.isLinux "linux-setting"} = true;
      # ${if config.stdenv.hostPlatform.isLinux "linux-setting"; fi} = true; 
      # ${pkgs.lib.mkIf config.stdenv.hostPlatform.isLinux "linux-setting"} = true;
      # SSH_AUTH_SOCK = pkgs.lib.optional config.stdenv.hostPlatform.isLinux "hü";
      # SSH_AUTH_SOCK = pkgs.lib.optional pkgs.stdenv.isLinux "$XDG_RUNTIME_DIR/ssh-agent.socket";
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
