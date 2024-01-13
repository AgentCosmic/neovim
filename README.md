# Neovim

Personal Neovim setup.

## Dependencies

- [Neovim](https://github.com/neovim/neovim/releases)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)

## Getting Started

- Install neovim.
- Set the environment variable `VIMINIT` to `let $MYVIMRC = {root}/init.vim' | source $MYVIMRC`, replacing `{root}`
	with the project directory.

## LSP

LSP installation instruction for Linux.

### Dependencies

- [Node.js](https://nodejs.org/en/download/)
- [Python](https://www.python.org/downloads/)
- [Go](https://go.dev/)

### Installation

All LSP servers are installed at neovim standard path: `:echo stdpath('data') . '/lsp'`. Run `./lsp-install.sh [lsp]`
to install language servers. Leave the first argument empty to install only essential servers.

## GUI

- [neovim-qt](https://github.com/equalsraf/neovim-qt) - see `/ginit.vim` for configs.
