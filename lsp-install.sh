#!/bin/env bash

set -eu

ROOT=~/.local/share/nvim/lsp

# init
if [ ! -d "$ROOT"  ]; then
	mkdir -p "$ROOT"
	cd "$ROOT"
	npm init -y
fi

cd "$ROOT"

if [ "$#" -eq 0 ]; then
	echo "Usage: $0 [web] [bash] [lua] [yaml|yml] [py|python] [go] [solidity] [vue] [csharp] [java]"
	exit 1
fi

for arg in "$@"; do
	case "$arg" in
		web)
			npm i \
				oxfmt@^0.44.0 \
				oxlint@^1.59.0 \
				vscode-langservers-extracted@^4.1.0 \
				typescript-language-server@^5.0.0 \
				stylelint-lsp@^2.0.0
			;;

		sh|bash)
			# efm
			EFM="efm-langserver_v0.0.57_linux_$(dpkg --print-architecture)"
			curl -LO "https://github.com/mattn/efm-langserver/releases/download/v0.0.56/$EFM.tar.gz"
			echo "$EFM.tar.gz"
			tar -xf "$EFM.tar.gz"
			mv "$EFM/efm-langserver" .
			rm "$EFM.tar.gz" "$EFM" -rf
			# shellcheck
			SHELLCHECK="shellcheck-stable.linux.$(uname -m)"
			curl -LO "https://github.com/koalaman/shellcheck/releases/download/stable/$SHELLCHECK.tar.xz"
			tar -xf "$SHELLCHECK.tar.xz"
			mv shellcheck-stable/shellcheck .
			rm "$SHELLCHECK.tar.xz" shellcheck-stable -r
			# bashls
			npm i bash-language-server@^5.4.3
			;;

		lua)
			MACHINE_TYPE=$(uname -m)
			if [ "$MACHINE_TYPE" == 'x86_64' ]; then
				ARCH='x64'
			elif [ "$MACHINE_TYPE" == 'aarch64' ]; then
				ARCH='arm64'
			else
				echo Architecture not supported
				exit
			fi
			LUALS="lua-language-server-3.18.1-linux-$ARCH.tar.gz"
			curl -LO "https://github.com/LuaLS/lua-language-server/releases/download/3.18.1/$LUALS"
			mkdir -p lua_ls
			tar -xf "$LUALS" --directory "$PWD/lua_ls"
			rm "$LUALS"
			;;

		yaml|yml)
			npm i yaml-language-server@^1.6.0
			;;

		py|python)
			python -m venv .venv
			.venv/bin/pip install \
				basedpyright~=1.39 \
				ruff~=0.15.9
			;;

		go)
			go install golang.org/x/tools/gopls@v0.21.1
			;;

		solidity)
			npm i @nomicfoundation/solidity-language-server@^0.7.1 prettier-plugin-solidity@^1.1.3
			;;

		vue)
			npm i @vue/language-server@^2.2.0
			;;

		csharp)
			dotnet tool install --global csharp-ls
			;;

		java)
			mkdir jdtls
			curl -s -L 'https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz' | tar xz -C jdtls
			;;
	esac
done
