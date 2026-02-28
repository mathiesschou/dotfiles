{ config, pkgs, lib, ... }:

let
  # Build all Catppuccin GTK theme variants
  catppuccin-themes = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    # This will build all 4 variants: latte, mocha, frappe, macchiato
    variant = "mocha";
  };
in
{
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard+default";
      package = catppuccin-themes;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    # These will be overridden by switch-theme.sh dynamically
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # GTK theme will be set dynamically by switch-theme.sh
  # This is just the default fallback
  home.sessionVariables = {
    GTK_THEME = "catppuccin-mocha-blue-standard+default";
  };

  # Create symlinks for better compatibility
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import url("resource:///org/gtk/libgtk/theme/Default/gtk-contained.css");
  '';
}
