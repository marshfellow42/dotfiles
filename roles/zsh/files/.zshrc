[[ -f ~/.zprofile ]] && source ~/.zprofile

source ~/.cache/wal/colors.sh

printf "\e]10;$foreground\a"   # font color
printf "\e]11;$background\a"   # background color

OMP_CACHE="$XDG_CACHE_HOME/omp-wal-theme.toml"
cat $XDG_CONFIG_HOME/oh-my-posh/config.toml $XDG_CACHE_HOME/wal/colors.toml > "$OMP_CACHE"
eval "$(oh-my-posh init zsh --config $OMP_CACHE)"

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

bindkey '^[[1;5C' forward-word   # Ctrl + Right
bindkey '^[[1;5D' backward-word  # Ctrl + Left

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

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]="fg=$color2,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=$color2,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=$color6,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=$color4,bold"
ZSH_HIGHLIGHT_STYLES[path]="fg=$color4,underline"
ZSH_HIGHLIGHT_STYLES[string]="fg=$color3"
ZSH_HIGHLIGHT_STYLES[comment]="fg=$color8"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$color1,bold"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=$color5"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=$color6"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=$color3"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=$color3"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=$color3"
ZSH_HIGHLIGHT_STYLES[assign]="fg=$color6"

alias g-dl="$(xdg-user-dir PROJECTS)/Gists/smart-gallery-dl.py"

export GPG_TTY=$(tty)