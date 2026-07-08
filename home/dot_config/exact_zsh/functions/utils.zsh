# Clipboard helper — reads from stdin, writes to system clipboard
# Supports macOS, Wayland, and X11
_copy_to_clipboard() {
  if [[ $OSTYPE == darwin* ]]; then
    pbcopy
  elif command -v wl-copy &>/dev/null; then
    wl-copy
  elif command -v xclip &>/dev/null; then
    xclip -selection clipboard
  else
    echo "copypath: no clipboard tool found (install wl-clipboard or xclip)" >&2
    return 1
  fi
}

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Copy the current working directory path to the clipboard
copypath() {
  pwd | tr -d '\n' | _copy_to_clipboard && echo "Copied: $(pwd)"
}

# Copy a file's contents to the clipboard
copyfile() {
  _copy_to_clipboard < "$1" && echo "Copied: $1"
}

# Print each PATH entry on its own line
path() {
  echo "$PATH" | tr ':' '\n'
}
