#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${DOTFILES_NVIM_REPO:-$HOME/.dotfiles/dotfiles.nvim}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
COMMIT=0
PUSH=0
DRY_RUN=0
COMMIT_MESSAGE="Update Neovim config"

usage() {
  cat <<USAGE
Usage: ./mk_dotfiles.nvim.sh [options]

Copies the current Neovim config from:
  $NVIM_CONFIG_DIR

to the dotfiles repository:
  $REPO_DIR

Options:
  --repo DIR        repository directory, default: ~/.dotfiles/dotfiles.nvim
  --config DIR      Neovim config directory, default: ~/.config/nvim
  --commit          create a git commit if there are changes
  --message TEXT    commit message, default: "Update Neovim config"
  --push            push after commit
  --dry-run         show what would be done without changing files
  -h, --help        show this help

Examples:
  ./mk_dotfiles.nvim.sh
  ./mk_dotfiles.nvim.sh --commit
  ./mk_dotfiles.nvim.sh --commit --message "Update LSP config" --push
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_DIR="$2"
      shift 2
      ;;
    --config)
      NVIM_CONFIG_DIR="$2"
      shift 2
      ;;
    --commit)
      COMMIT=1
      shift
      ;;
    --message|-m)
      COMMIT_MESSAGE="$2"
      shift 2
      ;;
    --push)
      PUSH=1
      COMMIT=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] %q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

write_file_if_missing() {
  local path="$1"
  local mode="$2"
  local content="$3"

  if [[ -e "$path" ]]; then
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] create $path"
    return
  fi

  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$content" > "$path"
  chmod "$mode" "$path"
}

if [[ ! -d "$NVIM_CONFIG_DIR" ]]; then
  echo "Neovim config directory not found: $NVIM_CONFIG_DIR" >&2
  exit 1
fi

SRC_REAL="$(realpath -m "$NVIM_CONFIG_DIR")"
REPO_REAL="$(realpath -m "$REPO_DIR")"
DST_REAL="$(realpath -m "$REPO_DIR/nvim")"

echo "Source config: $SRC_REAL"
echo "Repo dir:      $REPO_REAL"
echo "Repo nvim:     $DST_REAL"

run mkdir -p "$REPO_DIR"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  run git -C "$REPO_DIR" init
  run git -C "$REPO_DIR" branch -M main
fi

if [[ "$SRC_REAL" == "$DST_REAL" ]]; then
  echo "Current config already points to repo nvim/. Nothing to copy."
else
  echo "Syncing nvim config..."
  run rm -rf "$REPO_DIR/nvim"
  run mkdir -p "$REPO_DIR/nvim"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy $NVIM_CONFIG_DIR/. -> $REPO_DIR/nvim/"
  else
    cp -a "$NVIM_CONFIG_DIR"/. "$REPO_DIR/nvim"/
  fi
fi

write_file_if_missing "$REPO_DIR/.gitignore" 0644 '# Neovim runtime/state must not be committed
.nvimlog
.DS_Store

# local temp files
*.tmp
*.bak
*.swp
*.swo

# keep config, do not keep runtime caches
.local/
'

write_file_if_missing "$REPO_DIR/install.sh" 0755 '#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/nvim"
TARGET="$HOME/.config/nvim"

if [[ "${1:-}" == "--arch-deps" ]]; then
  sudo pacman -S --needed neovim git curl tar unzip gzip npm python make clang ripgrep fd tree-sitter-cli sed lazygit evince hunspell-ru
fi

if [[ ! -d "$SRC" ]]; then
  echo "Missing nvim config directory: $SRC" >&2
  exit 1
fi

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  BACKUP="$HOME/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)"
  mv "$TARGET" "$BACKUP"
  echo "Backup saved to: $BACKUP"
fi

mkdir -p "$HOME/.config"
ln -s "$SRC" "$TARGET"
echo "Linked: $TARGET -> $SRC"
echo "Now run: nvim"
'

write_file_if_missing "$REPO_DIR/README.md" 0644 '# dotfiles.nvim

Personal Neovim IDE config.

## Install

```bash
./install.sh
```

## Update repo from current system config

```bash
./mk_dotfiles.nvim.sh --commit
```
'

write_file_if_missing "$REPO_DIR/SOURCE.md" 0644 '# SOURCE.md

- `nvim/` — actual Neovim configuration copied from `~/.config/nvim`.
- `install.sh` — installs the repo config as `~/.config/nvim` symlink.
- `mk_dotfiles.nvim.sh` — updates this repo from the current system config.
'

# Ensure this script is present in the repository too, even when run from elsewhere.
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
SCRIPT_TARGET="$REPO_DIR/mk_dotfiles.nvim.sh"
if [[ "$(realpath -m "$SCRIPT_SOURCE")" != "$(realpath -m "$SCRIPT_TARGET")" ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy $SCRIPT_SOURCE -> $SCRIPT_TARGET"
  else
    cp "$SCRIPT_SOURCE" "$SCRIPT_TARGET"
    chmod +x "$SCRIPT_TARGET"
  fi
fi

run git -C "$REPO_DIR" add .

echo
echo "Git status:"
git -C "$REPO_DIR" status --short

if [[ "$COMMIT" -eq 1 ]]; then
  if git -C "$REPO_DIR" diff --cached --quiet && git -C "$REPO_DIR" diff --quiet; then
    echo "No changes to commit."
  else
    run git -C "$REPO_DIR" commit -m "$COMMIT_MESSAGE"
  fi
fi

if [[ "$PUSH" -eq 1 ]]; then
  run git -C "$REPO_DIR" push
fi

echo
echo "Done. Repo: $REPO_DIR"
echo "Next: cd $REPO_DIR && git status"
