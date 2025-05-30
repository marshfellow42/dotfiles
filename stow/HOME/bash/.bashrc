export GPG_TTY=$(tty)

export EDITOR=nano

export HYPRSHOT_DIR="$HOME/Pictures/Screenshots"
export XDG_PICTURES_DIR="$HOME/Pictures/"

eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/capr4n.omp.json)"

if [[ $- == *i* ]]; then
  echo
  echo
  fastfetch
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
