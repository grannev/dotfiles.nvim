# dotfiles.nvim

Compact Neovim IDE config for a small laptop screen: Catppuccin Mocha, native tabs, LSP, Telescope, Oil, Treesitter, Git, LaTeX, sessions, snippets/completion, diagnostics, floating terminal and LazyGit.

## Requirements

Core:

```bash
neovim git curl tar unzip gzip npm python make clang ripgrep fd tree-sitter-cli sed
```

Optional but recommended:

```bash
lazygit evince hunspell-ru
```

On Arch Linux:

```bash
sudo pacman -S --needed neovim git curl tar unzip gzip npm python make clang ripgrep fd tree-sitter-cli sed lazygit evince hunspell-ru
```

LaTeX requires your TeX Live setup with `latexmk` and a TeX engine such as `pdflatex`, `xelatex` or `lualatex`.

## Install

```bash
tar -xf dotfiles.nvim.tar.gz
cd dotfiles.nvim
./install.sh
nvim
```

Or install common Arch dependencies too:

```bash
./install.sh --arch-deps
```

The script backs up existing `~/.config/nvim` and symlinks this repo's `nvim/` directory to `~/.config/nvim`.

Inside Neovim:

```vim
:Lazy sync
:Mason
```

Mason installs these LSP servers automatically:

```text
lua_ls pyright bashls html cssls jsonls texlab gopls rust_analyzer
```

`clangd` is expected from the system `clang` package.

## Main keys

Leader is `Space`.

### Files and search

```text
<leader>e   floating file explorer
-           open parent directory
<leader>ff  find files
<leader>fg  live grep
<leader>fb  buffers
<Esc>       clear / search highlight
```

### Native tabs

```text
<leader>tt      new tab
<leader>tc      close tab
<leader>to      only current tab
Alt+Left        previous tab
Alt+Right       next tab
Alt+Shift+Left  move tab left
Alt+Shift+Right move tab right
Alt+1..9        jump to tab
```

### LSP

```text
gd          definition
gD          declaration
gi          implementation
gr          references
K           hover
<leader>gt  implementation in new tab
<leader>rn  rename
<leader>ca  code action
<leader>ld  line diagnostics
[d / ]d     previous / next diagnostic
<leader>ih  toggle inlay hints
```

Diagnostics under cursor show after 500 ms. Normal hover appears after 3 seconds.

### Git

```text
]c / [c     next / previous hunk
<leader>gp  preview hunk
<leader>gr  reset hunk
<leader>gb  blame line
<leader>gg  LazyGit floating UI
```

### Terminal and run

```text
Ctrl+\      floating terminal
<Esc>       leave terminal mode
<leader>rr  run current file
```

### Build and problems

```text
<leader>mm  :make
<leader>xq  Trouble quickfix
<leader>xx  project diagnostics
<leader>xb  buffer diagnostics
<leader>xr  references in Trouble
```

### Folds

```text
za          toggle fold
zM          close all C/C++ function-body folds
zR          open all folds
<leader>zp  preview folded signature
```

For C/C++, folds hide only function bodies and keep headers visible.

### Sessions

```text
<leader>ss  save session for current cwd
<leader>sl  load session for current cwd
<leader>sd  delete session
:SessionInfo
```

The config does not auto-detect project root. Current working directory is the directory where you ran `nvim`, unless you manually use `:cd`.

### LaTeX

```text
<leader>ll  compile
<leader>lv  view PDF in Evince
<leader>le  errors
<leader>lt  TOC
<leader>lk  stop compiler
<leader>lc  clean aux files
<leader>li  VimTeX info
```

### Spellcheck

Enabled automatically for `tex`, `markdown`, `text`, `gitcommit`.

```text
]s / [s      next / previous spelling issue
z=           suggestions
zg           add word permanently
<leader>sp   toggle spellcheck
<leader>sa   add word
<leader>sA   add word for this session
<leader>su   undo add word
<leader>sf   suggestions
```

### Search and replace

```text
<leader>sr  project search/replace
<leader>sR  replace word under cursor
<leader>sF  replace in current file
```

### TODO comments

```text
]t / [t      next / previous TODO/FIXME
<leader>ft   find TODOs
<leader>xt   TODOs in Trouble
```

## GitHub upload

Manual Git:

```bash
cd dotfiles.nvim
git init
git branch -M main
git add .
git commit -m "Initial Neovim dotfiles"
git remote add origin git@github.com:YOUR_USERNAME/dotfiles.nvim.git
git push -u origin main
```

Using GitHub CLI:

```bash
cd dotfiles.nvim
gh auth login
git init
git branch -M main
git add .
git commit -m "Initial Neovim dotfiles"
gh repo create dotfiles.nvim --public --source=. --remote=origin --push
```

For a private repository, replace `--public` with `--private`.

## Updating this repo from your current config

When you change `~/.config/nvim` and want to copy the current system config back into this repository:

```bash
./mk_dotfiles.nvim.sh
```

With a commit:

```bash
./mk_dotfiles.nvim.sh --commit --message "Update Neovim config"
```

With push:

```bash
./mk_dotfiles.nvim.sh --commit --push
```

By default it syncs:

```text
~/.config/nvim -> ~/.dotfiles/dotfiles.nvim/nvim
```

You can override paths:

```bash
DOTFILES_NVIM_REPO=~/.dotfiles/dotfiles.nvim NVIM_CONFIG_DIR=~/.config/nvim ./mk_dotfiles.nvim.sh
```
