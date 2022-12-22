#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode

vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    function clear(){
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    }
fi

PROMPT_COMMAND='echo -ne "\033]0;\h:\w\007"'

PS1='[\u@\h:\w] '

vterm_prompt_end(){
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
PS1=$PS1'\[$(vterm_prompt_end)\]'


vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

find_file() {
    vterm_cmd find-file "$(realpath "$@")"
}

say() {
    vterm_cmd message "%s" "$*"
}

alias ll='ls -ltra'

# Update the system and upgrade all system packages.
alias pacu='sudo pacman -Syu'

# Install a specific package from repos added to the system
alias paci='sudo pacman -S'

# Install specific package that has been downloaded to the local system
alias pacl='sudo pacman -U'

# Display information about a given package located in the repositories
alias paci='pacman -Si'

# Search for package or packages in the repositories
alias pacs='pacman -Ss'

# Remove the specified package or packages but retain its configuration and required dependencies
alias pacr='sudo pacman -R'

# Remove the specified package or packages , its configuration and all unwanted dependencies
alias pacrall='sudo pacman -Rns'

# Display information about a given package in the local database
alias pacsl='pacman -Qi'

# Search for package/packages in the local database'
alias paclocs='pacman -Qs'

# List all packages which are orphaned
alias paclo='pacman -Qdt'

# Clean cache - delete all the package files in the cache
alias paccc='sudo pacman -Sc'

# List all files installed by a given package
alias paclf='pacman -Ql'

# Show package(s) owning the specified file(s)
alias pacp='pacman -Qo'

# Remove orphans
alias pacdo='pacman -Qtdq | sudo pacman -Rns -'

# List installed packages
alias pacli='pacman -Qqe'

alias gitlog='git log --oneline'
alias gitchk='git checkout HEAD .'

export HISTCONTROL=ignoreboth:erasedups

#setxkbmap -option caps:hyper
#setxkbmap -option caps:none


alias estart='systemctl start --user emacs'
alias estop='systemctl stop --user emacs'
