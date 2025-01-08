#!/usr/bin/env bash

# NOTE: dev container以外では何もしない　
[ "$REMOTE_CONTAINERS" != "true" ] && exit 0

DIR=$(dirname $0)

cp -R "$DIR"/.zshrc .zsh.d ~
source "$DIR"/.zshrc
