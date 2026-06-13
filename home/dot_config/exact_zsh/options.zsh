# shellcheck disable=SC2034  # zsh special parameters are read by the shell, not this script

# ZLE (Zsh Line Editor)
typeset -g WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  # excludes / so ctrl+w stops at path boundaries
setopt COMBINING_CHARS    # handle macOS NFD unicode correctly
setopt NO_BEEP

# Directory navigation
typeset -g DIRSTACKSIZE=9
setopt AUTO_CD            # bare directory name acts as cd
setopt AUTO_PUSHD         # cd pushes old dir onto stack; enables `cd -` history
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT       # suppress stack output on every cd
setopt PUSHD_TO_HOME      # pushd with no args goes home

# Completion
setopt COMPLETE_IN_WORD   # complete from both ends of cursor position

# Expansion and globbing
setopt EXTENDED_GLOB      # enables #, ~, ^ as glob operators
setopt GLOB_DOTS          # globs match dotfiles without a leading dot
setopt NO_NOMATCH         # unmatched globs pass through as literals rather than erroring

# Input/output
setopt NO_CLOBBER            # > won't overwrite existing files; use >! to force
setopt NO_FLOW_CONTROL       # disable ctrl+s / ctrl+q terminal freeze
setopt INTERACTIVE_COMMENTS  # allow # comments at the prompt
setopt RM_STAR_WAIT          # pause 10s before executing rm *

# Job control
setopt LONG_LIST_JOBS

# Prompting
setopt PROMPT_SUBST       # allow parameter/command expansion in prompt strings

# History — managed by atuin; disable zsh's own persistence
typeset -g SAVEHIST=0
unset HISTFILE
