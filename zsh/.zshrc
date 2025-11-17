# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k theme (installed via Nix)
source $HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null || true

# Load p10k configuration if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Nix-darwin function (rebuilds and reloads shell)
unalias dr 2>/dev/null || true
dr() {
  sudo darwin-rebuild switch --flake ~/dotfiles && exec zsh
}

# Aliases
alias ll='ls -lah'
alias la='ls -a'

# Add npm global bin to PATH
export PATH="$HOME/.npm-global/bin:$PATH"
