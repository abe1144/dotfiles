#!/usr/bin/env bash
# install.sh — install packages and symlink this repo's configs into place.
# Safe to re-run. Anything already at a target path is moved to <path>.bak-<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L $dest && "$(readlink "$dest")" == "$src" ]]; then
    echo "  ok      $dest"
    return
  fi
  if [[ -e $dest || -L $dest ]]; then
    mv "$dest" "$dest.bak-$STAMP"
    echo "  backup  $dest -> $dest.bak-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "  link    $dest -> $src"
}

echo "==> Packages"
if command -v brew >/dev/null 2>&1; then
  brew bundle --file "$DOTFILES/Brewfile"
else
  echo "  Homebrew not found — install it from https://brew.sh, then re-run this script."
  exit 1
fi

echo "==> Symlinks"
link nvim               "$HOME/.config/nvim"
link tmux/tmux.conf     "$HOME/.config/tmux/tmux.conf"
link bin/dev            "$HOME/.local/bin/dev"

echo "==> Checks"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) echo "  ok      ~/.local/bin is on PATH" ;;
  *) echo "  WARNING ~/.local/bin is not on PATH. Add this to ~/.zshrc:"
     echo '            export PATH="$HOME/.local/bin:$PATH"' ;;
esac
command -v claude >/dev/null 2>&1 \
  && echo "  ok      claude is installed" \
  || echo "  NOTE    Claude Code not found: curl -fsSL https://claude.ai/install.sh | bash"

echo "==> Done. Open a new terminal, cd into a project, and run: dev"
