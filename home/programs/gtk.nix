{ config, pkgs, lib, ... }:

let
  # Build all Catppuccin GTK theme variants
  # We need all 4 variants for the theme switcher to work
  catppuccin-latte = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    variant = "latte";
  };
  catppuccin-mocha = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    variant = "mocha";
  };
  catppuccin-frappe = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    variant = "frappe";
  };
  catppuccin-macchiato = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    variant = "macchiato";
  };
in
{
  # Install all theme variants so switch-theme.sh can switch between them
  home.packages = [
    catppuccin-latte
    catppuccin-mocha
    catppuccin-frappe
    catppuccin-macchiato
  ];

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard+default";
      package = catppuccin-mocha;
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
