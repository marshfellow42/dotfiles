zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -Uz colors && colors

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes false