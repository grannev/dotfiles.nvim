# SOURCE.md

Short map of the config structure.

## Top level

```text
install.sh   installation script; backs up old config and symlinks nvim/
README.md    install guide and keymap reference
SOURCE.md    this file
nvim/        actual Neovim configuration
```

## nvim/init.lua

Entry point. Loads base config modules and then `config.lazy`, which bootstraps `lazy.nvim` and loads plugins from `lua/plugins/`.

## nvim/lua/config

### Base

```text
options.lua             editor options: numbers, tabs, clipboard, colorcolumn, undo
filetypes.lua           custom filetype detection for xhtml, asm, nasm, pascal, tex, etc.
keymaps.lua             global keymaps: splits, tabs, buffers, make/quickfix
which_key_groups.lua    names leader-key groups in which-key
user_commands.lua       :LspInfo and :LspClients helpers
lazy.lua                lazy.nvim bootstrap and plugin loader
```

### Editing behavior

```text
folds.lua               C/C++ body-only folds, zM/zR custom behavior, fold preview
restore_cursor.lua      restores last cursor position when reopening files
spell.lua               ru/en spellcheck for text files and spell hotkeys
smart_enter.lua         smart Enter inside existing pairs, without autopair insertion
runner.lua              <leader>rr runner from current working directory
```

### Project/session behavior

```text
sessions.lua            save/load/delete sessions by current working directory
```

This config intentionally does not auto-detect project root. The working root is where `nvim` was started, unless changed manually with `:cd`.

### LSP helpers

```text
lsp_highlight.lua       delayed document-highlight references under cursor
inlay_hints.lua         inlay hints toggle, disabled by default
```

## nvim/lua/plugins

### UI

```text
colorscheme.lua         Catppuccin Mocha
which-key.lua           keybinding popup
tabby.lua               native Vim tabline UI, not bufferline
lualine.lua             compact statusline with active LSP name
indent.lua              indentation guides
oil.lua                 floating file explorer
```

### Search/navigation

```text
telescope.lua           find files, live grep, buffers, help, ui-select integration
spectre.lua             project-wide search and replace
trouble.lua             diagnostics, references and quickfix UI
todo-comments.lua       TODO/FIXME/BUG highlighting and search
```

### Git/terminal

```text
gitsigns.lua            git hunks in signcolumn
toggleterm.lua          floating terminal and LazyGit integration
```

### Language support

```text
treesitter.lua          parser installation and TS highlighting start
mason.lua               Mason UI and automatic LSP installation
lsp.lua                 LSP config, diagnostics, hover, code actions, keymaps
completion.lua          blink.cmp completion
signature.lua           function signature help while typing arguments
vimtex.lua              LaTeX workflow with latexmk and Evince
```

### Comments

```text
comment.lua             block comments only; visual gc comments each selected line separately
```

## Important design choices

- Native Vim tabs are used instead of bufferline.
- `:q`, `:wq`, `:x`, `:tabnew`, `:tabclose` keep standard Vim behavior.
- No automatic project-root switching.
- Floating windows are preferred over permanent sidebars because this setup targets a small 12.5-inch screen.
- Inlay hints are available but disabled by default.
- Format-on-save is intentionally not enabled.
