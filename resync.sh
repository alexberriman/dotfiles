#!/bin/zsh
set -e

# Utility script to completely re-sync chezmoi from this dotfiles repo
# This removes the existing chezmoi state and re-initializes from scratch

echo "🗑️  Removing existing chezmoi state..."
rm -rf ~/.local/share/chezmoi

echo "🔄 Re-initializing chezmoi from current directory..."
chezmoi init --apply "$(pwd)"

echo "🔃 Reloading shell configuration..."
source ~/.zshrc

echo "✅ Chezmoi re-sync complete!"
