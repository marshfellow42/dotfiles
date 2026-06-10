[[ -f ~/.zprofile ]] && source ~/.zprofile

(cat ~/.cache/wal/sequences &)

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.toml)"

zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes false

setopt append_history inc_append_history share_history

# Lines configured by zsh-newuser-install
HISTFILE="$XDG_CACHE_HOME/.zsh_history"
HISTCONTROL=ignoreboth
HISTSIZE=1000000
SAVEHIST=1000000
# End of lines configured by zsh-newuser-install

WORDCHARS=''

autoload -U select-word-style
select-word-style normal

bindkey '^W' backward-kill-word
bindkey '^Z' undo

select-whole-line() {
    # Move cursor to the end of the line
    zle end-of-line
    # Set the anchor point (mark) for selection
    zle set-mark-command
    # Move cursor to the beginning of the line, highlighting everything in between
    zle beginning-of-line
}

# Define the function as a Zsh Line Editor (ZLE) widget
zle -N select-whole-line

# Bind Ctrl + A (^A) to the new widget
bindkey '^A' select-whole-line

custom-backspace() {
    if (( REGION_ACTIVE )); then
        # If text is highlighted (selected), kill the whole region
        zle kill-region
    else
        # Otherwise, perform a normal backspace delete
        zle backward-delete-char
    fi
}

zle -N custom-backspace

# Binds to the standard Backspace/Erase key
bindkey '^?' custom-backspace

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light jirutka/zsh-shift-select

alias g-dl="$(xdg-user-dir PROJECTS)/Gists/smart-gallery-dl.py"

GPG_TTY=$(tty)
export GPG_TTY
