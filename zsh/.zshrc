eval "$(starship init zsh)"


export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias dd="hx"

# tmux
alias t="tmux"
alias ta="tmux attach -t"      # ta <name>
alias tn="tmux new -s"         # tn <name>
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t" # tk <name>
alias tks="tmux kill-server"
