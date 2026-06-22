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
AGE_KEY_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/age-key.txt"

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

# --- age key setup ---
setup_age_key() {
  if [[ -f "$AGE_KEY_PATH" ]]; then
    success "age key found"
    return
  fi

  if [[ "$OS" == "linux" ]]; then
    error "age key not found at $AGE_KEY_PATH. On Linux, install the Bitwarden CLI manually,\n       run: bw login && bw unlock\n       then: bw get notes chezmoi-age-key > $AGE_KEY_PATH && chmod 600 $AGE_KEY_PATH\n       then re-run this script."
  fi

  info "age key not found — retrieving from Bitwarden..."

  if ! command -v bw &>/dev/null; then
    brew install bitwarden-cli
  fi

  local bw_status
  bw_status=$(bw status 2>/dev/null | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "unauthenticated")

  if [[ "$bw_status" == "unauthenticated" ]]; then
    info "Log into Bitwarden..."
    bw login
  fi

  info "Unlock your Bitwarden vault..."
  export BW_SESSION=$(bw unlock --raw)

  bw sync --quiet

  mkdir -p "$(dirname "$AGE_KEY_PATH")"
  bw get notes "chezmoi-age-key" > "$AGE_KEY_PATH"
  chmod 600 "$AGE_KEY_PATH"
  success "age key saved to $AGE_KEY_PATH"
}

setup_age_key

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
