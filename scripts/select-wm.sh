#!/usr/bin/env sh
WM="${1:-hyprland}"

case "$WM" in
  hyprland|sway|river|niri)
    # Special handling for hyprland executable
    if [ "$WM" = "hyprland" ]; then
      exec Hyprland
    else
      exec "$WM"
    fi
    ;;
  *)
    echo "Unknown WM: $WM"
    exit 1
    ;;
esac
