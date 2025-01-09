#!/usr/bin/env bash

# NOTE: dev container以外では何もしない　
[ "$REMOTE_CONTAINERS" != "true" ] && exit 0

DIR=$(dirname $0)

apt-get update
apt-get install less -y

ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.zsh.d ~/.zsh.d
source ~/.zshrc
