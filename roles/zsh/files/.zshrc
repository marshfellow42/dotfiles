[[ -f $HOME/.zprofile ]] && source $HOME/.zprofile

source $XDG_CACHE_HOME/wal/colors.sh

OMP_CACHE="$XDG_CACHE_HOME/omp-wal-theme.toml"
cat $XDG_CONFIG_HOME/oh-my-posh/config.toml $XDG_CACHE_HOME/wal/colors.toml > "$OMP_CACHE"
eval "$(oh-my-posh init zsh --config $OMP_CACHE)"

for conf in "$XDG_CONFIG_HOME/zsh/"*.zsh; do
  source "${conf}"
done
unset conf

export GPG_TTY=$(tty)

eval "$(zoxide init zsh)"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'