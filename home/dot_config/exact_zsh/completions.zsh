# shellcheck disable=SC1036,SC1073,SC1072,SC1009

# complist enables colours in the menu select interface
zmodload zsh/complist

# Docker CLI completions (installed by Docker Desktop)
if command -v docker &>/dev/null; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

# Cache directories
_zsh_cache="$XDG_CACHE_HOME/zsh"
_zsh_completions="$_zsh_cache/completions"
[[ -d "$_zsh_cache" ]] || mkdir -p "$_zsh_cache"
[[ -d "$_zsh_completions" ]] || mkdir -p "$_zsh_completions"

# Add generated completions dir to fpath before compinit
fpath=("$_zsh_completions" $fpath)

# Generate completions for tools that provide them dynamically
# Delete $_zsh_completions to force regeneration after tool updates
if command -v atuin &>/dev/null && [[ ! -f "$_zsh_completions/_atuin" ]]; then
  atuin gen-completions --shell zsh > "$_zsh_completions/_atuin"
fi
if command -v bun &>/dev/null && [[ ! -f "$_zsh_completions/_bun" ]]; then
  bun completions > "$_zsh_completions/_bun"
fi
if command -v chezmoi &>/dev/null && [[ ! -f "$_zsh_completions/_chezmoi" ]]; then
  chezmoi completion zsh > "$_zsh_completions/_chezmoi"
fi
if command -v erd &>/dev/null && [[ ! -f "$_zsh_completions/_erd" ]]; then
  erd --completions zsh > "$_zsh_completions/_erd"
fi
if command -v mise &>/dev/null && [[ ! -f "$_zsh_completions/_mise" ]]; then
  mise completions zsh > "$_zsh_completions/_mise"
fi
if command -v ng &>/dev/null && [[ ! -f "$_zsh_completions/_ng" ]]; then
  ng completion script > "$_zsh_completions/_ng"
fi
if command -v sheldon &>/dev/null && [[ ! -f "$_zsh_completions/_sheldon" ]]; then
  sheldon completions --shell zsh > "$_zsh_completions/_sheldon"
fi

# Initialise completion system with 24h cache
# m-24: file fresh (< 24h) → use -C (skip rescan); missing or old → full rescan
# -nt: full rescan if completions dir is newer than compdump (new file was generated)
# -i: silence warnings about insecure directories (common with Homebrew on macOS)
_zcompdump="$_zsh_cache/compdump"
autoload -Uz compinit
# zsh glob qualifier, not valid POSIX
if [[ -n "$_zcompdump"(#qNm-24) && ! "$_zsh_completions" -nt "$_zcompdump" ]]; then
  compinit -i -C -d "$_zcompdump"
else
  compinit -i -d "$_zcompdump"
fi
unset _zsh_cache _zsh_completions _zcompdump

# Completion behaviour
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"

# --- Completion menu (choose one) ---
# The descriptions format differs: fzf receives raw text so %F{} sequences appear literally;
# menu select runs through zsh prompt expansion so color codes work there.

# fzf-tab: replaces the completion menu with a live fuzzy-filter interface
# Requires: fzf installed + fzf-tab in plugins.toml
# To revert to standard menu: comment this block, uncomment the menu select block below
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Standard menu: arrow-key navigable list, no extra dependencies
# To use: comment the fzf-tab block above, uncomment below
# zstyle ':completion:*' menu select
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
