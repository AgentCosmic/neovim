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
- Create folders at `/swap` and  `/undo` in the project directory.
- Install the fonts in `/fonts`.
- Refer to [LSP](lsp/README.md) to set up LSP.
- *Optional*: Copy snippets from [friendly-snippets](https://github.com/rafamadriz/friendly-snippets/tree/main/snippets)
	into `/home/snippets` and customize them.

## GUI

- [neovim-qt](https://github.com/equalsraf/neovim-qt) - see `/ginit.vim` for configs.
- [neovide](https://neovide.dev/) - see GUI section in `/init.vim` for configs.
