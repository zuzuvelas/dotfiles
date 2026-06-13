# Clean home — redirect tools that default to $HOME
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# PATH — prepend user-installed tool bins
# path=("$FOO_HOME/bin" $path) # set FOO_HOME export above

# Homebrew (macOS)
if [[ $OSTYPE == darwin* ]]; then
  export HOMEBREW_NO_ANALYTICS='1'
  export HOMEBREW_CLEANUP_MAX_AGE_DAYS='7'
  export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS='7'
  export HOMEBREW_DISPLAY_INSTALL_TIMES='1'
  export HOMEBREW_NO_ENV_HINTS='1'
  export HOMEBREW_NO_EMOJI='1'
fi

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
