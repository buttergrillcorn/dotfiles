# Wallpapers

This directory contains wallpapers used by the window manager.

## Adding Wallpapers

Copy your wallpaper images here:

```sh
cp ~/path/to/your/wallpaper.jpg ~/dotfile/wallpapers/
```

## Setting Default Wallpaper

Create a symlink to your preferred wallpaper:

```sh
cd ~/dotfile/wallpapers
ln -sf your-wallpaper.jpg default.jpg
```

## Changing Wallpaper

Edit `wallpaper` variable in `dotfiles.org`:

```org
#+name: wallpaper
#+begin_src text
~/dotfile/wallpapers/your-wallpaper.jpg
#+end_src
```

Then re-tangle and reload sway:
```sh
./scripts/tangle.sh
swaymsg reload
```

## Recommended

- Keep wallpapers minimal and small file size
- Use `.jpg` for photos, `.png` for graphics
- Suggested filenames: `minimal-plant.jpg`, `dark-water.jpg`, `palm-shadow.jpg`
