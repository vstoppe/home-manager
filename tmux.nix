{ config, pkgs, ... }:

{

  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      mouse = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      plugins = with pkgs; [
        # tmuxPlugins.power-theme
        # tmuxPlugins.tmux-colors-solarized
        tmuxPlugins.onedark-theme
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
      ];
      extraConfig = ''
        # set Terminal to 24Bit color if supported:
        set-option -sa terminal-overrides ",xterm*:Tc"

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Open panes in current directory
        bind '"' split-window -v -c "#{pane_current_path}"
        bind  %  split-window -h -c "#{pane_current_path}"

        # vim keybindings for copy mode
        bind-key -T copy-mode-vi v   send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

        # enable ssh-agent-forwarding
        set -g update-environment "SSH_AUTH_SOCK"
      '';
    };
  };
}
