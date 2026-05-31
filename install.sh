#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_src="$repo_dir/nvim"
config_dst="$HOME/.config/nvim"
backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)"

install_arch_deps() {
  if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not found; skipping Arch dependencies"
    return
  fi

  sudo pacman -S --needed \
    neovim git curl tar unzip gzip npm python make clang \
    ripgrep fd tree-sitter-cli lazygit sed \
    evince hunspell-ru
}

case "${1:-}" in
  --arch-deps)
    install_arch_deps
    ;;
  "")
    ;;
  *)
    echo "Usage: ./install.sh [--arch-deps]"
    exit 1
    ;;
esac

mkdir -p "$HOME/.config"
mkdir -p "$config_src/spell"
touch "$config_src/spell/ru.utf-8.add"

if [ -e "$config_dst" ] || [ -L "$config_dst" ]; then
  mv "$config_dst" "$backup_dir"
  echo "Backup saved to: $backup_dir"
fi

ln -s "$config_src" "$config_dst"

echo "Neovim config linked: $config_dst -> $config_src"
echo "Open nvim and run :Lazy sync if plugins do not install automatically."
echo "Mason LSP packages install on first file open; check progress with :Mason."
