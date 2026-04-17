{ pkgs, config, ... }:

{
  # Note: theme.conf is managed by switch-theme.sh script, not by Nix

  programs.tmux = {
    enable = true;

    # Basic settings
    prefix = "C-s";
    mouse = true;
    terminal = "tmux-256color";

    # Use vi mode
    keyMode = "vi";

    # Start window/pane numbering at 1
    baseIndex = 1;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];

    extraConfig = ''
      # Automatically renumber windows when one is closed
      set -g renumber-windows on

      # Reload config with prefix + r
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Terminal colors
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Status bar at top
      set -g status-position top

      # Theme: Catppuccin Latte
      set -g pane-border-lines simple
      set -g status-left ""
      set -g window-status-format "•"
      set -g window-status-current-format "•"
      set -g pane-border-style "fg=#504945"
      set -g pane-active-border-style "fg=#d79921"
      set -g status-style "bg=default,fg=#ebdbb2"
      set -g status-right "#[fg=#d79921]#S"
      set -g window-status-style "fg=#928374"
      set -g window-status-current-style "#{?window_zoomed_flag,fg=#fabd2f,fg=#d79921,nobold}"
      set -g window-status-bell-style "fg=#fb4934,nobold"

      # Pane resizing
      bind -r H resize-pane -L 5
      bind -r L resize-pane -R 5

      # Window navigation: Ctrl+Tab
      bind -n C-Tab next-window
      bind -n C-S-Tab previous-window

      # Window navigation: Alt+1-9
      bind -n M-1 select-window -t :1
      bind -n M-2 select-window -t :2
      bind -n M-3 select-window -t :3
      bind -n M-4 select-window -t :4
      bind -n M-5 select-window -t :5
      bind -n M-6 select-window -t :6
      bind -n M-7 select-window -t :7
      bind -n M-8 select-window -t :8
      bind -n M-9 select-window -t :9
    '';
  };
}
