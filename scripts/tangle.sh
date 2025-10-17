#!/usr/bin/env sh
emacs --batch --eval "(require 'org)" --eval "(org-babel-tangle-file \"dotfiles.org\")"
