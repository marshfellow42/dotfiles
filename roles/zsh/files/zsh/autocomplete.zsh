zmodload zsh/complist
autoload -Uz compinit
autoload -Uz colors

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes false