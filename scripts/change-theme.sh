#!/usr/bin/env sh
# Change wallpaper and generate theme with pywal

if [ $# -eq 0 ]; then
  echo "Usage: $0 <wallpaper-path>"
  echo ""
  echo "Available wallpapers:"
  ls -1 ~/dotfile/wallpapers/*.{jpg,png} 2>/dev/null
  exit 1
fi

WALLPAPER="$1"

if [ ! -f "$WALLPAPER" ]; then
  echo "Error: Wallpaper not found: $WALLPAPER"
  exit 1
fi

# Generate colors with pywal
wal -i "$WALLPAPER" -n

# Reload waybar (picks up new colors)
pkill -SIGUSR2 waybar

# Reload mako (picks up new colors)
makoctl reload

echo "Theme changed to: $WALLPAPER"
