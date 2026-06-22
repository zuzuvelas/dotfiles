#!/usr/bin/env bash
set -euo pipefail

# --- Output helpers ---
info()    { printf '\n\033[0;34m==>\033[0m %s\n' "$*"; }
success() { printf '\033[0;32m  ✓\033[0m %s\n' "$*"; }
warn()    { printf '\033[0;33m  !\033[0m %s\n' "$*" >&2; }
error()   { printf '\033[0;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

REPO_URL="https://github.com/zuzuvelas/dotfiles"
GITHUB_USERNAME="zuzuvelas"
CHEZMOI_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"

# --- OS detection ---
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)  OS="linux" ;;
  *)      error "Unsupported OS: $(uname -s)" ;;
esac

info "Bootstrapping dotfiles on $OS"

# --- macOS: Homebrew first ---
if [[ "$OS" == "macos" ]]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Apple Silicon: /opt/homebrew/bin is not on PATH in a fresh session
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew ready"
fi

# --- chezmoi + dotfiles ---
if [[ "$OS" == "macos" ]]; then
  if ! command -v chezmoi &>/dev/null; then
    info "Installing chezmoi..."
    brew install chezmoi
  fi
  info "Applying dotfiles..."
  if [[ -d "$CHEZMOI_DIR" ]]; then
    chezmoi apply
  else
    chezmoi init --apply "$REPO_URL"
  fi
else
  # Linux: install chezmoi and init dotfiles in one shot
  info "Installing chezmoi and applying dotfiles..."
  sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply "$GITHUB_USERNAME"
fi
success "Dotfiles applied"

# --- macOS: packages and runtimes ---
if [[ "$OS" == "macos" ]]; then
  PROFILE="$(chezmoi data 2>/dev/null \
    | grep -o '"profile":"[^"]*"' \
    | cut -d'"' -f4 \
    || echo "personal")"

  info "Installing packages (profile: $PROFILE)..."
  brew bundle --file "$CHEZMOI_DIR/Brewfile" --no-lock
  success "Brewfile done"

  if [[ "$PROFILE" == "work" ]]; then
    brew bundle --file "$CHEZMOI_DIR/Brewfile.work" --no-lock
    success "Brewfile.work done"
  fi

  info "Installing runtimes via mise..."
  mise install
  success "Runtimes ready"
fi

# --- Linux: manual steps reminder ---
if [[ "$OS" == "linux" ]]; then
  warn "Linux detected — package installation is not automated yet."
  warn "Install tools manually or via your distro's package manager."
  warn "Then run: mise install"
fi

success "Done. Open a new shell to get started."
