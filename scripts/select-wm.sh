#!/usr/bin/env sh
WM="${1:-sway}"

case "$WM" in
  sway|river|niri)
    exec "$WM"
    ;;
  *)
    echo "Unknown WM: $WM"
    exit 1
    ;;
esac
