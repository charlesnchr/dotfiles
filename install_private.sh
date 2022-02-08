#!/bin/bash

git config --global user.name "Charles Christensen"
git config --global user.email "charles.n.chr@gmail.com"

echo 'setup private'
git submodule add git@github.com:charlesnchr/dotfiles_private
stow dotfiles_private
