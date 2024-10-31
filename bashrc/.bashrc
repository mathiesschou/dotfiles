#
# ~/.bashrc
#

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Alias for backlight keys
alias kl0='echo 0 | sudo tee /sys/class/leds/tpacpi::kbd_backlight/brightness'
alias kl1='echo 1 | sudo tee /sys/class/leds/tpacpi::kbd_backlight/brightness'
alias kl2='echo 2 | sudo tee /sys/class/leds/tpacpi::kbd_backlight/brightness'

