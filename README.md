# Ubuntu Dev Environment

Personal development environment configuration for **Ubuntu 24.04.4 LTS**.

This repository contains my shell, window management, and package configuration so I can reliably recreate my development setup on a fresh machine.

---

## 🎯 Purpose

This repo exists to:

- Bootstrap a clean Ubuntu install into my preferred dev environment
- Keep terminal, tiling behavior, and tooling consistent across machines
- Version-control system configuration over time
- Document what is installed and why

---

## 📦 What’s Included

### 🐚 Zsh Configuration
- `zshrc`
- Oh My Zsh with the `agnoster` theme
- Custom prompt tweaks
- Plugin configuration (git, fzf, autosuggestions, etc.)
- Optional Conda + NVM integration

### 🪟 Tiling / Desktop
- GNOME configuration for **Tiling Assistant**
- Window management preferences tuned for keyboard-driven workflow

### 📦 APT Packages
- Explicitly installed packages exported using:

```bash
apt-mark showmanual > packages/apt.txt