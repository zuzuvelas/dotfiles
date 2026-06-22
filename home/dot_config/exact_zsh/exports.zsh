# Android SDK
if [[ $OSTYPE == darwin* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi
path=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools" "${path[@]}")

# Claude Code
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE='1'

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

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# SSH agent — macOS uses Keychain natively (see ~/.ssh/config); Linux needs manual start
if [[ $OSTYPE != darwin* && -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
export _ZO_EXCLUDE_DIRS="**/node_modules"
