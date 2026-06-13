# Status and log
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'

# Staging and committing
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'

# Branching — git switch is the modern replacement for git checkout (branch ops)
alias gsw='git switch'
alias gswc='git switch -c'
alias gb='git branch'
alias gbd='git branch -d'

# Remote
alias gp='git push'
alias gpu='git push -u origin HEAD'  # push current branch and set upstream
alias gpl='git pull'
alias gf='git fetch'

# Diff and stash
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
