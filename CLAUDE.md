# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a minimal Arch Linux dotfiles repository managed with **org-mode** and **GNU Stow**. All configuration is written in a single `dotfiles.org` file using org-babel's literate programming features, then tangled into individual config files and deployed via stow.

## Architecture

### Single-Source Philosophy

The entire configuration lives in `dotfiles.org`:
- **Shared configuration** (colors, fonts, variables) defined once as named org-babel blocks
- **Package-specific configs** reference shared blocks using noweb syntax (`<<block-name>>`)
- Each package section has a `:tangle` header specifying output path in `packages/`

### Workflow

1. Edit `dotfiles.org` (the source of truth)
2. Run `./scripts/tangle.sh` to generate configs into `packages/*/`
3. Run `./scripts/stow-pkg.sh [packages...]` to symlink to `~/`

The `packages/` directory is gitignored - only the org source is tracked.

## Common Commands

### Generate configs from org file
```sh
./scripts/tangle.sh
```

### Deploy all packages to home directory
```sh
./scripts/stow-pkg.sh sway waybar mako fuzzel foot yazi qutebrowser swaylock swayidle zsh pywal
```

### Deploy specific package
```sh
./scripts/stow-pkg.sh sway
```

### Remove/unstow package
```sh
stow -d packages -t ~ -D sway
```

### Switch window managers
```sh
# Unstow current WM, stow new one
stow -d packages -t ~ -D sway
stow -d packages -t ~ river
```

## Key Design Principles

1. **Minimal** - Fewest lines of code, no bloat
2. **Modular** - Each package is independent, can be stowed/unstowed separately
3. **DRY via noweb** - Shared variables (colors, fonts) defined once, referenced everywhere
4. **Single file** - All config in `dotfiles.org` for easy searching and cross-referencing

## Extending the Configuration

Add new sections to `dotfiles.org`:

```org
* NewPackage
#+begin_src conf :tangle packages/newpackage/.config/newpackage/config
# Use shared variables
font=<<font>>
<<colors>>
#+end_src
```

Then tangle and stow as usual.

## Scripts

- `scripts/tangle.sh` - Runs Emacs in batch mode to extract code blocks from dotfiles.org
- `scripts/stow-pkg.sh` - Helper wrapper around stow for deploying packages
- `scripts/select-wm.sh` - WM launcher for getty auto-login (called from .zshrc)

## Target Stack

sway, waybar, mako, fuzzel, foot, yazi, qutebrowser, waylock, swayidle, zsh, pywal
