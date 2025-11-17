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
      catppuccin
    ];

    extraConfig = ''
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

      # Status bar at top
      set-option -g status-position top

      # Catppuccin theme settings
      set -g @catppuccin_window_status_style "rounded"
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application} #{E:@catppuccin_status_session}"

      # Transparent background
      set -g status-style bg=default
    '';
  };
}
