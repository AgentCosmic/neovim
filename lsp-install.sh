#!/bin/env bash

set -e

ROOT=~/.local/share/nvim/lsp

# init
if [ ! -d "$ROOT"  ]; then
	mkdir "$ROOT"
	cd "$ROOT"
	npm init -y
	python -m venv .venv
fi

cd "$ROOT"

# essential
if [ "$#" -ne 1 ]; then
	# efm
	EFM="efm-langserver_v0.0.44_linux_$(dpkg --print-architecture)"
	if [ ! -f "efm-langserver" ]; then
		wget "https://github.com/mattn/efm-langserver/releases/download/v0.0.44/$EFM.tar.gz"
		tar -xf "$EFM.tar.gz"
		mv "$EFM/efm-langserver" .
		rm "$EFM.tar.gz" "$EFM" -rf
	fi

	# bashls
	BLS="shellcheck-stable.linux.$(uname -m)"
	wget "https://github.com/koalaman/shellcheck/releases/download/stable/$BLS.tar.xz"
	tar -xf "$BLS.tar.xz"
	mv shellcheck-stable/shellcheck .
	rm "$BLS.tar.xz"

	# common & web
	npm i \
		bash-language-server@^5.1.2 \
		yaml-language-server@^1.6.0 \
		prettier@^2.6.2 \
		vscode-langservers-extracted@^4.1.0 \
		typescript-language-server@^3.3.2 \
		stylelint-lsp@^1.2.4

	# python
	npm i pyright@^1.1.239
	.venv/bin/pip install \
		isort==5.12.0 \
		black==23.7.0
fi

# optional

if [ "$1" = "go" ]; then
	go install golang.org/x/tools/gopls@v0.12.2
fi

if [ "$1" = "solidity" ]; then
	npm i @nomicfoundation/solidity-language-server@^0.7.1 prettier-plugin-solidity@^1.1.3
fi

if [ "$1" = "vue" ]; then
	npm i @volar/vue-language-server@^1.2.0
fi
