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