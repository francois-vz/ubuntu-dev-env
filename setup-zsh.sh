#!/bin/bash
set -e

# Install zsh
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    sudo apt update && sudo apt install -y zsh
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattained
fi

# Create plugins directory
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

# Install plugins
echo "Installing plugins..."

# autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# syntax highlighting
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# fzf history search
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]; then
    git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
fi

# Install fzf
echo "Installing fzf..."
sudo apt install -y fzf

# Install powerline fonts (critical for agnoster theme)
echo "Installing powerline fonts..."
sudo apt install -y fonts-powerline

# Add color support to .zshrc if not already present
if ! grep -q "export TERM=xterm-256color" ~/.zshrc; then
    echo "export TERM=xterm-256color" >> ~/.zshrc
fi

echo "Done! Plugins installed to ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
echo "Restart your shell or run: source ~/.zshrc"
