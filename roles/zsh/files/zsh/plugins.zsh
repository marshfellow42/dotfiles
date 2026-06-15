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

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
# https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/docs/highlighters
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting

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