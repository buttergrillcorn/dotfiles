#!/usr/bin/env sh
cd "$(dirname "$0")/.." || exit 1

show_help() {
  echo "Usage: $0 [OPTIONS] [packages...]"
  echo ""
  echo "Options:"
  echo "  --all        Stow all packages"
  echo "  --minimal    Stow minimal set (sway, waybar, mako, fuzzel, foot)"
  echo "  --interactive  Select packages with fuzzel"
  echo "  -D           Unstow instead of stow"
  echo "  -h, --help   Show this help"
  echo ""
  echo "Available packages:"
  ls -1 packages/ 2>/dev/null || echo "  (none tangled yet - run ./scripts/tangle.sh first)"
}

if [ ! -d packages ] || [ -z "$(ls -A packages 2>/dev/null)" ]; then
  echo "No packages found. Run ./scripts/tangle.sh first."
  exit 1
fi

UNSTOW=0
PACKAGES=""

case "$1" in
  -h|--help)
    show_help
    exit 0
    ;;
  --all)
    PACKAGES=$(ls -1 packages/)
    ;;
  --minimal)
    PACKAGES="sway waybar mako fuzzel foot"
    ;;
  --interactive)
    if command -v fuzzel >/dev/null 2>&1; then
      PACKAGES=$(ls -1 packages/ | fuzzel --dmenu --prompt "Select packages (space to select):")
    else
      echo "Error: fuzzel not found. Install it or use manual selection."
      exit 1
    fi
    [ -z "$PACKAGES" ] && exit 0
    ;;
  -D)
    UNSTOW=1
    shift
    PACKAGES="$*"
    ;;
  "")
    echo "No packages specified."
    echo ""
    show_help
    exit 1
    ;;
  *)
    PACKAGES="$*"
    ;;
esac

if [ -z "$PACKAGES" ]; then
  echo "No packages to stow."
  exit 1
fi

if [ $UNSTOW -eq 1 ]; then
  echo "Unstowing: $PACKAGES"
  stow -d packages -t ~ -D $PACKAGES
else
  echo "Stowing: $PACKAGES"
  stow -d packages -t ~ $PACKAGES
fi
