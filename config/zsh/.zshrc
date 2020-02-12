# -*- origami-fold-style: triple-braces -*-
# Partially stolen from https://github.com/LukeSmithxyz/voidrice and my own bashrc

# First Steps {{{

if [ "${SHELL_FIRST:-0}" = 0 ]; then
    SHELL_FIRST="$(date)"

    # Defer to a shell inside tmux, if not attached yet.
    if [ -t 1 ]; then
	if [ -z "${TMUX}" ]; then
	    if ! tmux has -t "scratch" &>/dev/null; then
		tm "scratch" detach
	    fi

	    exec tmux new
	fi
    fi
fi


# }}}
# Autoload Extensions {{{

autoload -U colors && colors

# Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files in autocomplete

# }}}
# Prompt {{{

PS1="%B%{$fg[green]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[green]%}]%{$reset_color%}$%b "

# }}}
# Exports {{{

export KEYTIMEOUT=1
export SHELL=/usr/bin/zsh

export PROJECTS="${HOME}/projects"
export DOTFILES="${PROJECTS}/dotfiles"

export EDITOR="emacs-ttyorgui emacsclient"
export TERMINAL="st"
export BROWSER="firefox"

export BAT_THEME="base16"
export GOPATH="${HOME}/.cache/go"

# }}}
# Vim bindings and cursor {{{

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes
zle-keymap-select() { # {{{
    if [[ ${KEYMAP} == vicmd ]] ||
	   [[ $1 = 'block' ]]; then
	echo -ne '\e[1 q'

    elif [[ ${KEYMAP} == main ]] ||
	     [[ ${KEYMAP} == viins ]] ||
	     [[ ${KEYMAP} = '' ]] ||
	     [[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
    fi
} # }}}
zle-line-init() { # {{{
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
} # }}}

zle -N zle-keymap-select
zle -N zle-line-init

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

# }}}
# Bindings {{{

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
	dir="$(cat "$tmp")"
	rm -f "$tmp"
	if [ -d "$dir" ]; then
	    if [ "$dir" != "$(pwd)" ]; then
		cd "$dir"
	    fi
	fi
    fi
}
bindkey -s '^O' '^Ulfcd\n'

# }}}
# Backend functions {{{
## Functions that usually aren't used only on the shell setup.

## Silently source a file, if it exists.
source-maybe() { # {{{
    if [ -f "${1}" ]; then
	source "${1}"
    else
	return 1
    fi
}
# }}}

## If ${1} is not in ${PATH}, append to it.
## Exit codes:
## 1 => Invalid arguments;
## 2 => ${1} already exists on ${PATH};
path-maybe() { # {{{
    [ $# != 1 ] && return 1

    if [[ ":${PATH}:" == *"${1}"* ]]; then
	return 2
    else
	export PATH="${PATH:+"${PATH}:"}${1}"
    fi
}
# }}}

## Check if a tmux session is attached.
tmux-attached() { # {{{
    if [ $# = 1 ]; then
	tmux ls | grep "^${1}.*(attached)\$" &>/dev/null
    else
	echo -e '\e[1m\e[34mUsage:\e[m ${0} SESSION-NAME'
	return 1
    fi
} # }}}

## Start a tmux session or reattach to it.
tmux-session() { # {{{
    if [[ -n "$1" ]]; then
	if tmux has -t="$1" &>/dev/null; then
	    tmux attach -t "$1"
	else
	    tmux new-session -s "$1" \; source-file "${HOME}/.local/lib/tmux-sessions/$1.proj" \; $2
	fi
    else
	echo -e '\e[1m\e[34mUsage:\e[m ${0} SESSION-NAME <optional-command>'
    fi
} # }}}

## Get the current git branch.
git-branch() { # {{{
    local branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
    if [ -n "${branch}" ]; then
	echo "${branch}"
    else
	return 1
    fi
} # }}}

# }}}
# User functions {{{
## Functions that were designed to be used in the shell.

rl() { source "${ZDOTDIR:-"${HOME}"}/.zshrc"; }
sy() { "${DOTFILES}/sync"; }
vp() { (cd "${PERSONAL}" && vi); }

rd() {
    local CHOICEPATH="${HOME}/persist/articles"
    local CHOICE="$(ls "${CHOICEPATH}" | grep '\.html$' | fzf)"
    open "${CHOICEPATH}/${CHOICE}" &
}

# }}}
# Sourcing {{{

source-maybe "${HOME}/.zshrc.local"
source-maybe "${DOTFILES}/config/zsh/fzf-completion"
source-maybe "${DOTFILES}/config/zsh/fzf-keybindings"
path-maybe "${HOME}/.local/bin"
path-maybe "${HOME}/.cache/go"
path-maybe "/opt/bin"

# }}}
# Aliases {{{

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'

alias t='task'
alias tt='t +TODAY or +OVERDUE'
alias to='t +TOMORROW'
alias tsh='tasksh'

alias tm='tmux-session'
alias du='du -shc'

alias py3='python3'
alias p3='python3'
alias jl='julia'

alias nvim='echo NeoVim is disabled for now, I guess. Yargs:'
alias vim='nvim' vi='nvim'
alias ec='echo -e "\\033[2 q" && emacsclient -nw'
alias emacs='emacs-ttyorgui emacs'

alias cp-sync='cp -ur'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# }}}
# Post Processing {{{

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null ||
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# }}}
# Settings {{{

# History
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt sharehistory
setopt extendedhistory

# less
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;35m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[33m'       # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ls; dir
test -r "${DOTFILES}/config/dircolors" \
                && eval "$(dircolors -b "${DOTFILES}/config/dircolors")" \
                || eval "$(dircolors -b)"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# }}}
