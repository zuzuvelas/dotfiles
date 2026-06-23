# Better ls — eza with colour, icons, git status, and hyperlinks
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --git --icons=auto --hyperlink'
  alias la='eza -lah --group-directories-first --git --icons=auto --hyperlink'
  alias lt='eza --tree --group-directories-first --icons=auto'
fi

# Better cat — bat with syntax highlighting and git integration
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# Better tree — erdtree (named profiles in ~/.config/erdtree/.erdtree.toml)
if command -v erd &>/dev/null; then
  alias tree='erd'
  alias erds='erd -c size'   # with logical file sizes (human-readable)
  alias erdl='erd -c lines'  # with line counts
  alias erdw='erd -c words'  # with word counts
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias mkdir='mkdir -p'
alias rm='rm -i'
