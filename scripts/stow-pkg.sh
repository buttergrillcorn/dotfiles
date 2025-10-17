#!/usr/bin/env sh
cd "$(dirname "$0")/.." || exit 1

if [ $# -eq 0 ]; then
  echo "Usage: $0 [package...]"
  echo "Available packages:"
  ls -1 packages/ 2>/dev/null || echo "  (none tangled yet)"
  exit 1
fi

stow -d packages -t ~ "$@"
