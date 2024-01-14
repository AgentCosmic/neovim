#!/bin/env bash

set -e

ROOT=~/.local/share/nvim/lsp

# init
if [ ! -d "$ROOT"  ]; then
	mkdir "$ROOT"
	cd "$ROOT"
	npm init -y
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
	# common & web
	npm i \
		yaml-language-server@^1.6.0 \
		prettier@^2.6.2 \
		vscode-langservers-extracted@^4.1.0 \
		typescript-language-server@^3.3.2 \
		stylelint-lsp@^1.2.4
fi

# optional

if [ "$1" = 'bash' ]; then
	SHELLCHECK="shellcheck-stable.linux.$(uname -m)"
	wget "https://github.com/koalaman/shellcheck/releases/download/stable/$SHELLCHECK.tar.xz"
	tar -xf "$SHELLCHECK.tar.xz"
	mv shellcheck-stable/shellcheck .
	rm "$SHELLCHECK.tar.xz" shellcheck-stable -r
	npm i bash-language-server@^5.1.2
fi

if [ "$1" = 'lua' ]; then
	MACHINE_TYPE=$(uname -m)
	if [ "$MACHINE_TYPE" == 'x86_64' ]; then
		ARCH='x64'
	elif [ "$MACHINE_TYPE" == 'aarch64' ]; then
		ARCH='arm64'
	else
		echo Architecture not supported
		exit
	fi
	LUALS="lua-language-server-3.7.4-linux-$ARCH.tar.gz"
	wget "https://github.com/LuaLS/lua-language-server/releases/download/3.7.4/$LUALS"
	mkdir lua_ls
	tar -xf "$LUALS" --directory "$PWD/lua_ls"
	rm "$LUALS"
fi

if [ "$1" = 'python' ]; then
	npm i pyright@^1.1.239
	python -m venv .venv
	.venv/bin/pip install \
		isort==5.12.0 \
		black==23.7.0
fi

if [ "$1" = 'go' ]; then
	go install golang.org/x/tools/gopls@v0.12.2
fi

if [ "$1" = 'solidity' ]; then
	npm i @nomicfoundation/solidity-language-server@^0.7.1 prettier-plugin-solidity@^1.1.3
fi

if [ "$1" = 'vue' ]; then
	npm i @volar/vue-language-server@^1.2.0
fi
