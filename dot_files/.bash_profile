#!/bin/sh

# Profile file. Runs on login.

export PATH="$PATH:$HOME/.scripts"

[ -f ~/.bashrc ] && source ~/.bashrc
