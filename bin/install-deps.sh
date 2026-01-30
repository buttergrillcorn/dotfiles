#!/usr/bin/env bash
# --- Generated from packages-table ---

REPO_PKGS="yazi thunar kitty"
AUR_PKGS=""

# Standard Repo Installation
if [ -n "$REPO_PKGS" ]; then
    echo "Installing repo packages: $REPO_PKGS"
    sudo pacman -S --needed --noconfirm $REPO_PKGS
fi

# AUR Installation (Assumes paru, change to yay if needed)
if [ -n "$AUR_PKGS" ]; then
    echo "Installing AUR packages: $AUR_PKGS"
    paru -S --needed --noconfirm $AUR_PKGS
fi
