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

All LSP servers dependencies are installed at neovim standard path: `:echo stdpath('config')`.

Link/copy the package files to neovim's config directory:

    mkdir ~/.config/nvim
    cp package.json ~/.config/nvim/package.json
    cp requirements.txt ~/.config/nvim/requirements.txt
    cp efm.sh ~/.config/nvim/efm.sh
    cp gopls.sh ~/.config/nvim/gopls.sh

Then install dependencies:

    cd ~/.config/nvim
    npm i
    python -m venv .venv
    .venv/bin/pip install -r requirements.txt
    sh efm.sh
    sh gopls.sh

## GUI

- [neovim-qt](https://github.com/equalsraf/neovim-qt) - see `/ginit.vim` for configs.
