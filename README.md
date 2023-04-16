# Neovim

Personal Neovim setup.

## Dependencies

- [Neovim](https://github.com/neovim/neovim/releases)
- [Node.js](https://nodejs.org/en/download/)
- [Python](https://www.python.org/downloads/)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [Universal ctags](https://github.com/universal-ctags/ctags-win32/releases)

## Getting Started

- Install neovim.
- Set the environment variable `VIMINIT` to `let $MYVIMRC = {root}/init.vim' | source $MYVIMRC`, replacing `{root}`
	with the project directory.
- Install the fonts in `/fonts`.
- Refer to [LSP](lsp/README.md) to set up LSP.

## GUI

- [neovim-qt](https://github.com/equalsraf/neovim-qt) - see `/ginit.vim` for configs.
- [neovide](https://neovide.dev/) - see GUI section in `/init.vim` for configs.

## LSP

This instruction is for Linux.

All LSP servers dependencies are installed at neovim standard path: `:echo stdpath('config')`.

Link the package files to neovim's config directory:
```sh
cp package.json ~/.config/nvim/package.json
cp requirements.txt ~/.config/nvim/requirements.txt
cp go.mod ~/.config/nvim/go.mod
cp go.sum ~/.config/nvim/go.sum
```

Then install dependencies:
```sh
cd ~/.config/nvim
npm i
python -m venv .venv
.venv/bin/pip install -r requirements.txt
go install
# or just download binary
wget https://github.com/mattn/efm-langserver/releases/download/v0.0.44/efm-langserver_v0.0.44_linux_amd64.tar.gz
```
