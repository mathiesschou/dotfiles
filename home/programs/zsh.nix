{ config, pkgs, lib, ... }:

{
  # Install powerlevel10k
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  # Link zshrc configuration
  home.file.".zshrc".source = ../../zsh/.zshrc;

  # Link p10k configuration
  home.file.".p10k.zsh".source = ../../p10k/.p10k.zsh;
}
