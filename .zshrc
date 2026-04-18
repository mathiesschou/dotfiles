export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export EDITOR="zed --wait"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

if command -v xcrun &> /dev/null; then
  export CC="$(xcrun --find clang)"
  export SDKROOT="$(xcrun --show-sdk-path)"
  export LIBRARY_PATH="$SDKROOT/usr/lib"
fi

eval "$(starship init zsh)"

alias ll='ls -lah'
alias la='ls -a'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
alias ta='tmux attach-session'
alias clang=/usr/bin/clang

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
