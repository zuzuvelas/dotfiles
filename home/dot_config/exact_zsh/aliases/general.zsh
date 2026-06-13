# Better ls — eza with colour, git status, and icons
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lh --group-directories-first --git'
  alias la='eza -lah --group-directories-first --git'
  alias lt='eza --tree --group-directories-first'
fi

# Better cat — bat with syntax highlighting and git integration
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# Better tree — erdtree
if command -v erd &>/dev/null; then
  alias tree='erd'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias mkdir='mkdir -p'
alias rm='rm -i'
