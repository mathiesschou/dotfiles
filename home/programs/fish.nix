{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # direnv hook
      if command -v direnv &> /dev/null
        set -gx DIRENV_LOG_FORMAT ""
        direnv hook fish | source
      end

      # History configuration
      set -g HISTSIZE 10000
      set -g HISTFILESIZE 10000

      # Add npm global bin to PATH
      fish_add_path $HOME/.npm-global/bin

      # Load Context7 API key from file
      if test -f ~/.context7-api-key
        set -gx CONTEXT7_API_KEY (cat ~/.context7-api-key)
      end
    '';

    shellAliases = {
      ll = "ls -lah";
      la = "ls -a";
      v = "nvim";
      g = "git";
      lg = "lazygit";
    };

    functions = {
      # Home-manager rebuild function
      dr = {
        description = "Rebuild home-manager config";
        body = ''
          home-manager switch --flake ~/dotfiles#mathies-linux
          and exec fish
        '';
      };
    };
  };

  # Use Starship prompt (works great with fish)
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "blue bold";
      };

      git_branch = {
        symbol = " ";
        style = "purple";
      };

      git_status = {
        style = "red";
      };

      rust = {
        symbol = " ";
      };

      python = {
        symbol = " ";
      };

      nodejs = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
      };
    };
  };
}
