#!/usr/bin/env bash
set -euo pipefail
[ "$(uname)" = "Darwin" ] || exit 0

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 20
defaults write -g KeyRepeat -int 2

defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

killall SystemUIServer Dock Finder 2>/dev/null || true
