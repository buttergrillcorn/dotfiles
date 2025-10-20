#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ORG_FILE="$DOTFILES_DIR/dotfiles.org"

# Print colored message
print_msg() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

print_error() { print_msg "$RED" "✗ Error:" "$@"; }
print_success() { print_msg "$GREEN" "✓" "$@"; }
print_info() { print_msg "$BLUE" "→" "$@"; }
print_warning() { print_msg "$YELLOW" "⚠" "$@"; }

# Cleanup function
cleanup() {
    if [ -n "${TEMP_OUTPUT:-}" ] && [ -f "$TEMP_OUTPUT" ]; then
        rm -f "$TEMP_OUTPUT"
    fi
}
trap cleanup EXIT

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    if ! command -v emacs >/dev/null 2>&1; then
        print_error "Emacs is not installed. Please install it first."
        exit 1
    fi

    if [ ! -f "$ORG_FILE" ]; then
        print_error "dotfiles.org not found at: $ORG_FILE"
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Run tangle operation
run_tangle() {
    print_info "Tangling dotfiles.org..."

    TEMP_OUTPUT=$(mktemp)

    # Run emacs tangle and capture output
    if emacs --batch \
        --eval "(require 'org)" \
        --eval "(setq org-confirm-babel-evaluate nil)" \
        --eval "(org-babel-tangle-file \"$ORG_FILE\")" \
        > "$TEMP_OUTPUT" 2>&1; then

        # Count tangled blocks
        TANGLED_COUNT=$(grep -c "Tangled" "$TEMP_OUTPUT" 2>/dev/null || echo "0")

        if [ "$TANGLED_COUNT" -gt 0 ]; then
            print_success "Successfully tangled $TANGLED_COUNT code blocks"
        else
            print_warning "Tangle completed but no blocks were reported"
            print_info "Emacs output:"
            cat "$TEMP_OUTPUT"
        fi

        return 0
    else
        print_error "Tangle operation failed!"
        print_info "Emacs output:"
        cat "$TEMP_OUTPUT"
        return 1
    fi
}

# Verify output
verify_output() {
    print_info "Verifying generated packages..."

    if [ ! -d "$DOTFILES_DIR/packages" ]; then
        print_error "packages/ directory not created"
        return 1
    fi

    PACKAGE_COUNT=$(find "$DOTFILES_DIR/packages" -mindepth 1 -maxdepth 1 -type d | wc -l)

    if [ "$PACKAGE_COUNT" -eq 0 ]; then
        print_warning "No packages generated in packages/ directory"
        return 1
    fi

    print_success "Generated configs for $PACKAGE_COUNT packages"

    # List packages
    print_info "Packages:"
    find "$DOTFILES_DIR/packages" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | sed 's/^/  - /'
}

# Main execution
main() {
    echo ""
    print_info "=== Dotfiles Tangle Script ==="
    echo ""

    check_prerequisites

    if run_tangle; then
        echo ""
        verify_output
        echo ""
        print_success "Tangle completed successfully!"
        echo ""
        print_info "Next steps:"
        echo "  1. Run ./scripts/stow-pkg.sh <package> to deploy"
        echo "  2. Or run swaymsg reload to reload sway config"
        echo ""
        return 0
    else
        echo ""
        print_error "Tangle failed. Please check the errors above."
        echo ""
        return 1
    fi
}

# Run main
main "$@"
