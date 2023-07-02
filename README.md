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

```sh
cp package.json ~/.config/nvim/package.json
cp requirements.txt ~/.config/nvim/requirements.txt
cp go.mod ~/.config/nvim/go.mod
```

Then install dependencies:

```sh
cd ~/.config/nvim
npm i
python -m venv .venv
.venv/bin/pip install -r requirements.txt
go install
# or just download binary for Go e.g.
wget https://github.com/mattn/efm-langserver/releases/download/v0.0.44/efm-langserver_v0.0.44_linux_amd64.tar.gz
```

## GUI

- [neovim-qt](https://github.com/equalsraf/neovim-qt) - see `/ginit.vim` for configs.
