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
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox "dark"
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

      # Pane resizing med prefix + h/j/k/l (repeatable)
      unbind -n M-h
      unbind -n M-j
      unbind -n M-k
      unbind -n M-l
      bind -r h resize-pane -L 3
      bind -r j resize-pane -D 3
      bind -r k resize-pane -U 3
      bind -r l resize-pane -R 3

      # Alternativ: hold prefix og tryk H/J/K/L for grovere resize (repeatable)
      bind -r H resize-pane -L 6
      bind -r J resize-pane -D 6
      bind -r K resize-pane -U 6
      bind -r L resize-pane -R 6

      # Status bar at top
      set-option -g status-position top

      # Pane borders
      set -g pane-border-lines heavy
      set -g popup-border-lines rounded
      set -g pane-border-indicators both
      set -g pane-active-border-style "fg=#fabd2f,bold"
      set -g pane-border-style "fg=#504945"

      # Ensure UTF-8 support for borders
      set -gq utf8 on
    '';
  };
}
