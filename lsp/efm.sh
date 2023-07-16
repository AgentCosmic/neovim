#!/bin/env sh

NAME="efm-langserver_v0.0.44_linux_$(dpkg --print-architecture)"

wget "https://github.com/mattn/efm-langserver/releases/download/v0.0.44/$NAME.tar.gz"
tar -xf "$NAME.tar.gz"
mv "$NAME/efm-langserver" .
rm "$NAME.tar.gz" "$NAME" -rf
