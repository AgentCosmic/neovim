# Neovim

Personal Neovim setup.

## Dependencies

- [Neovim](https://github.com/neovim/neovim/releases)
- [Node.js](https://nodejs.org/en/download/)
- [Python](https://www.python.org/downloads/)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [Universal ctags](https://github.com/universal-ctags/ctags-win32/releases)

## Getting Started

- Change the `$ROOT` variable defined in `/init.vim` to the location of this repository.
- Install the fonts in `/fonts`.
- Install LSP servers in `/lsp`. Install the dependencies into `/lsp/.venv` and `/lsp/node_modules`. Refer to LSP
	section for other languages that requires manual installation.
- *Optional*: Copy snippets from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets/tree/main/snippets)
	into `/home/snippets` and customize them.
- Install plugins by runnig this command in neovim `:PlugInstall`.

## GUI

This project is configure for [neovim-qt](https://github.com/equalsraf/neovim-qt). See `/ginit.vim` for configs.
