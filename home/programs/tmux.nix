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
      {
        plugin = catppuccin;
        extraConfig = ''
          # Catppuccin theme settings (must be set BEFORE plugin loads)
          set -g @catppuccin_flavour "macchiato"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_background "default"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
        '';
      }
    ];

    extraConfig = ''
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

      # Status bar at top
      set-option -g status-position top

      # Transparent background (must be set after plugin loads)
      set -g status-style bg=default

      # Custom status bar content
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application} #{E:@catppuccin_status_session}"

      # Pane borders (must be set after theme)
      set -g pane-border-lines heavy
      set -g popup-border-lines rounded

      # Ensure UTF-8 support for borders
      set -gq utf8 on
    '';
  };
}
