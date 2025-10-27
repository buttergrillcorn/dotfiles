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

### Deploy all packages to home directory (Hyprland)
```sh
./scripts/stow-pkg.sh hyprland mako fuzzel foot yazi qutebrowser zsh matugen
```

### Deploy all packages to home directory (Sway)
```sh
./scripts/stow-pkg.sh sway mako fuzzel foot yazi qutebrowser swaylock swayidle zsh matugen
```

### Deploy specific package
```sh
./scripts/stow-pkg.sh hyprland
```

### Remove/unstow package
```sh
stow -d packages -t ~ -D hyprland
```

### Switch window managers
```sh
# Unstow current WM, stow new one (waybar is bundled in each WM package)
stow -d packages -t ~ -D hyprland
stow -d packages -t ~ sway
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

### System Scripts
- `scripts/tangle.sh` - Runs Emacs in batch mode to extract code blocks from dotfiles.org
- `scripts/stow-pkg.sh` - Helper wrapper around stow for deploying packages
- `scripts/select-wm.sh` - WM launcher for getty auto-login (called from .zshrc)

### User Scripts (in packages/matugen/.local/bin/)
- `bitwarden-fuzzel` - Custom Bitwarden password manager with fuzzel interface
- `select-wallpaper.sh` - Interactive wallpaper selector with matugen integration
- `screenshot.sh` - Screenshot tool with fuzzel menu
- `waybar-pomodoro` - Minimal pomodoro timer for waybar
- `waybar-updates` - Package update checker for waybar
- `waybar-battery` - Smart dual battery monitor for waybar
- `mako-actions` - Interactive notification actions menu

## ZSH Configuration

The zsh configuration is comprehensive and feature-rich, built with zinit plugin manager:

### Features
- **Starship prompt** - Fast, minimal prompt with git integration
- **zinit** - Plugin manager for fast loading
- **Enhanced completions** - Case-insensitive, colored, with descriptions
- **Improved history** - 50k lines, shared across sessions, smart deduplication
- **Syntax highlighting** - Real-time command validation (fast-syntax-highlighting)
- **Autosuggestions** - Fish-like suggestions from history
- **History substring search** - Search history with arrow keys
- **FZF integration** - Fuzzy finding for files, directories, and history
- **Smart navigation** - Auto-cd, directory stack, zoxide integration
- **Key bindings** - VIM-style with custom enhancements
- **Developer tools** - Git, Docker, npm completions and aliases

### First Run
On first run, zinit will automatically install itself and all plugins to `~/.local/share/zinit/`.

### Performance
Configuration is optimized for fast startup (<100ms target):
- Lazy loading for heavy plugins
- Completion caching
- Optional profiling with `zprof`

## Doom Emacs & Denote

The repository includes a comprehensive Doom Emacs configuration with Denote note-taking system.

### Denote Git Sync

Denote is configured with **automatic git synchronization** for seamless multi-device note-taking:

**Features:**
- Auto-sync on save (commits and pushes when saving files in `~/denote`)
- Auto-pull on daemon startup (pulls latest changes when Emacs starts)
- Periodic sync every 15 minutes
- Idle sync after 5 minutes of inactivity
- Offline support (commits locally when offline, auto-pushes when back online)
- Smart commit messages with file names and timestamps
- Conflict detection with clear notifications

**Safety mechanisms:**
- Detects ongoing git operations (merge/rebase) and skips sync
- Single operation lock prevents concurrent syncs
- Handles all file types: modifications, additions, deletions, renames
- All operations run asynchronously (non-blocking)

**Configuration location:** `dotfiles.org` under `*** Denote > **** Git Sync`

**Keybindings:**
- `SPC d g s` - Manual sync
- `SPC d g t` - Toggle auto-sync on/off

### Deployment
```sh
./scripts/stow-pkg.sh doom
doom sync
```

## Target Stack

**Primary:** hyprland (includes waybar), hyprpaper, hypridle, hyprlock, mako, fuzzel, foot, yazi, qutebrowser, doom emacs, denote, zsh, matugen

**Alternative:** sway (includes waybar), swaybg, swayidle, swaylock, mako, fuzzel, foot, yazi, qutebrowser, doom emacs, denote, zsh, matugen

**Note:** Both Hyprland and Sway are fully supported. Hyprland is the primary/default WM, with Sway as an alternative.

### Important Notes
- **Waybar is WM-specific**: Each WM package includes its own waybar configuration (hyprland/workspaces vs sway/workspaces module)
- Don't stow hyprland and sway together! Only stow one at a time.
- Hyprland is currently the primary/configured WM
- Always make sure changes are updated in README.org where necessary
- Escape "* " in codeblocks in ".org" files with ". * " as it'll otherwise be recognised as a org-mode heading.
- Always make sure to update documentation (README).
- When a change is made relating to hyprland or any window manager/compositor, make sure to update the help menu script to reflect the changes.
- Never edit anything in ./packages/ since it's all auto-generated.