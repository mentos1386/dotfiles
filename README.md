# My dotfiles configuration

Supported OSes:
 * Ubuntu
 * MacOS
 * [mentos1386/os](https://github.com/mentos1386/os)

```bash
# Install GUI tools with personal specialization
./install --gui --env personal
# A variation for macos
./install --gui --env personal-macos
# Skip GUI tools and only apply work specialization
./install --env work
```

## Dark and Light themes

Neovim and Kitty are configured to follow Gnome's dark and light theme
changes.

By default they are initially light and in case of changes, they will start
to match the correct preferences.

To make this work, [night theme switcher](https://extensions.gnome.org/extension/2236/night-theme-switcher/)
extension is needed and configured to use `scripts/sunrise.sh` and `scripts/sunset.sh` as "run commands".
