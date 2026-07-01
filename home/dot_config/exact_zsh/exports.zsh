# Android SDK
if [[ $OSTYPE == darwin* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
path=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools" "${path[@]}")

# Claude Code
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE='1'

# fzf — fuzzy finder defaults
# Colors use ANSI terminal slots: inherits Zuppuccin palette from Ghostty
export FZF_DEFAULT_OPTS="\
  --color=dark,fg:-1,bg:-1,hl:4,fg+:7,bg+:0,gutter:0,hl+:4,info:8,border:8,prompt:4,pointer:3,marker:3,spinner:8,header:6 \
  --height=40% \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --no-separator \
  --bind=ctrl-f:half-page-down \
  --bind=ctrl-b:half-page-up"

# File preview via bat when using ctrl+T (file search only — not history or dir jump)
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# GPG — tell the agent which terminal to use for passphrase prompts
GPG_TTY=$(tty)
export GPG_TTY
gpgconf --launch gpg-agent 2>/dev/null

# Gradle — redirect from $HOME; the cache can grow to several GB
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# Homebrew (macOS)
if [[ $OSTYPE == darwin* ]]; then
  export HOMEBREW_NO_ANALYTICS='1'
  export HOMEBREW_CLEANUP_MAX_AGE_DAYS='7'
  export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS='7'
  export HOMEBREW_DISPLAY_INSTALL_TIMES='1'
  export HOMEBREW_NO_ENV_HINTS='1'
  export HOMEBREW_NO_EMOJI='1'
fi

# JetBrains Toolbox CLI launchers (idea, studio, etc.)
if [[ $OSTYPE == darwin* ]]; then
  path=("$HOME/Library/Application Support/JetBrains/Toolbox/scripts" "${path[@]}")
elif [[ $OSTYPE == linux* ]]; then
  path=("$HOME/.local/share/JetBrains/Toolbox/scripts" "${path[@]}")
fi

# Less
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

# Pager
export PAGER='bat'
export MANPAGER='sh -c "col -bx | bat -l man -p"'

# SSH agent — macOS uses Keychain natively (see ~/.ssh/config); Linux needs manual start
if [[ $OSTYPE != darwin* && -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
export _ZO_EXCLUDE_DIRS="**/node_modules"
