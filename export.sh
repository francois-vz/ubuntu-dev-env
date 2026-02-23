#!/bin/bash
mkdir -p packages/vscode
apt-mark showmanual > packages/apt.txt
code --list-extensions  > packages/vscode/extensions.txt
cp ~/.config/Code/User/settings.json packages/vscode/settings.json
cp ~/.config/Code/User/keybindings.json packages/vscode/keybindings.json
