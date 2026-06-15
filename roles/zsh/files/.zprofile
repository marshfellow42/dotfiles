# Export all XDG user directories
[ -f "$HOME/.config/user-dirs.dirs" ] && \
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^# ]] && continue
    export "$key=$(eval echo "$value")"
  done < "$HOME/.config/user-dirs.dirs"

export BROWSER="librewolf"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"