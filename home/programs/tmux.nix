{ pkgs, ... }:

{
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

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];

    extraConfig = ''
      # Faster escape for vim
      set -g escape-time 0

      # Automatically renumber windows when one is closed
      set -g renumber-windows on

      # Reload config with prefix + r
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Terminal colors
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Vim-style pane navigation
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Pane resizing med prefix + H/J/K/L (repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Status bar at top
      set -g status-position top

      # Theme: Dynamic based on ~/.config/tmux/theme.conf
      set -g pane-border-lines simple
      set -g status-left ""
      set -g window-status-format "•"
      set -g window-status-current-format "•"

      # Source theme file (will be symlinked by theme switcher)
      source-file ~/.config/tmux/theme.conf

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
