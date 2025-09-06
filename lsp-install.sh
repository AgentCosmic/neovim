#!/bin/env bash

set -e

ROOT=~/.local/share/nvim/lsp

# init
if [ ! -d "$ROOT"  ]; then
	mkdir -p "$ROOT"
	cd "$ROOT"
	npm init -y
fi

cd "$ROOT"

# essential
if [ "$#" -ne 1 ]; then
	# efm
	EFM="efm-langserver_v0.0.54_linux_$(dpkg --print-architecture)"
	if [ ! -f "efm-langserver" ]; then
		curl -LO "https://github.com/mattn/efm-langserver/releases/download/v0.0.54/$EFM.tar.gz"
		echo "$EFM.tar.gz"
		tar -xf "$EFM.tar.gz"
		mv "$EFM/efm-langserver" .
		rm "$EFM.tar.gz" "$EFM" -rf
	fi
	# common & web
	npm i \
		yaml-language-server@^1.6.0 \
		prettier@^3.5.0 \
		vscode-langservers-extracted@^4.1.0 \
		typescript-language-server@^4.3.1 \
		stylelint-lsp@^2.0.0
fi

# optional

if [ "$1" = 'bash' ]; then
	SHELLCHECK="shellcheck-stable.linux.$(uname -m)"
	curl -LO "https://github.com/koalaman/shellcheck/releases/download/stable/$SHELLCHECK.tar.xz"
	tar -xf "$SHELLCHECK.tar.xz"
	mv shellcheck-stable/shellcheck .
	rm "$SHELLCHECK.tar.xz" shellcheck-stable -r
	npm i bash-language-server@^5.4.3
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
	LUALS="lua-language-server-3.13.6-linux-$ARCH.tar.gz"
	curl -LO "https://github.com/LuaLS/lua-language-server/releases/download/3.13.6/$LUALS"
	mkdir -p lua_ls
	tar -xf "$LUALS" --directory "$PWD/lua_ls"
	rm "$LUALS"
fi

if [ "$1" = 'python' ]; then
	python -m venv .venv
	.venv/bin/pip install \
		basedpyright==1.27.1 \
		ruff==0.9.6
fi

if [ "$1" = 'go' ]; then
	go install golang.org/x/tools/gopls@v0.17.1
fi

if [ "$1" = 'solidity' ]; then
	npm i @nomicfoundation/solidity-language-server@^0.7.1 prettier-plugin-solidity@^1.1.3
fi

if [ "$1" = 'vue' ]; then
	npm i @vue/language-server@^2.2.0
fi

if [ "$1" = 'csharp' ]; then
	dotnet tool install --global csharp-ls
fi

if [ "$1" = 'java' ]; then
	mkdir jdtls
	curl -s -L 'https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz' | tar xz -C jdtls
fi
