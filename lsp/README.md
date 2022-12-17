# LSP

This instruction is for Linux.

Link the package files to neovim's config directory:
```sh
ln -s package.json ~/.config/nvim/package.json
ln -s package-lock.json ~/.config/nvim/package-lock.json
ln -s requirements.txt ~/.config/nvim/requirements.txt
ln -s go.mod ~/.config/nvim/go.mod
ln -s go.sum ~/.config/nvim/go.sum
```

Then install dependencies:
```sh
cd ~/.config/nvim
npm i
python3.11 -m venv .venv
.venv/bin/pip install -r requirements.txt
go install
# or just download binary
wget https://github.com/mattn/efm-langserver/releases/download/v0.0.44/efm-langserver_v0.0.44_linux_amd64.tar.gz
```
