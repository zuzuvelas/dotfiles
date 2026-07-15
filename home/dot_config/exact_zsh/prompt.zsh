# Starship cross-shell prompt, Zuppuccin theme

# Some terminals miscalculate Nerd Font column widths, which leads
# to the cursor positioning to land in the wrong spot. Remove the
# `right_format` line in these cases.
if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
  jetbrains_config="${TMPDIR:-/tmp}/starship-jetbrains.toml"
  grep -v '^right_format' "$STARSHIP_CONFIG" >| "$jetbrains_config"
  export STARSHIP_CONFIG="$jetbrains_config"
  unset jetbrains_config
fi

eval "$(starship init zsh)"
