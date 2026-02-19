# Suggested Dotfiles Upgrades

Audit performed Feb 2026. Work through these incrementally — each section is independent.

---

## 1. iTerm2 Settings Sync

The `init/macos` script has an iTerm2 section but it only configures Terminal.app, not iTerm2 itself. Add these to sync iTerm2 preferences via Tresorit:

```bash
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/Tresorit/Colby/iTerm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

Also verify in iTerm2 GUI: **Settings > General > Preferences > "Load preferences from a custom folder or URL"**

**If settings differ between machines:** iTerm2 switched from plist to JSON-based config. If one machine has the old format, delete its local prefs and let it pull fresh from the sync folder. Check `~/Library/Preferences/com.googlecode.iterm2.plist` vs the custom folder contents.

---

## 2. Fix Symlink Script Bug

`init/symlink_script.sh` uses a relative path that only works by accident:

```bash
# Current (broken if not run from $HOME):
ln -s $dir/$file ~/.$file

# Fixed:
ln -s $HOME/$dir/$file ~/.$file
```

---

## 3. Clean Up Brewfile

### Remove deprecated taps
These are now built into Homebrew and produce warnings:
```
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"
tap "homebrew/services"
```

### Remove redundant/stale packages
- `hub` — superseded by `gh` (which is already in the Brewfile)
- `python@3.8` — EOL since Oct 2024
- `shpotify` — unmaintained, Spotify removed the local API it depended on

### Consolidate container runtime
You have `brew "docker"`, `brew "colima"`, and `cask "docker-desktop"`. Pick one approach:
- **Colima + docker CLI** (lighter weight, no license concerns)
- **Docker Desktop** (GUI, easier but requires license for orgs >250 people)

### Run a diff on both machines
```bash
brew bundle cleanup --file=$HOME/dotfiles/Brewfile
```
This shows what's installed but not in the Brewfile (and vice versa). Good way to catch drift.

---

## 4. Deduplicate macos Defaults Script

`init/macos` and `init/macos.sh` are identical files. `setup.sh` calls `init/macos`. Delete `init/macos.sh` or consolidate to one file.

---

## 5. Audit macos Defaults for Current macOS

Some keys to verify still work on current macOS version:

- `com.apple.menuextra.battery ShowPercent` — now managed via System Settings > Control Center on Ventura+
- `com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)"` — may no longer affect modern Bluetooth codecs
- `com.apple.Music ignore-devices 1` — verify this still prevents auto-open

Test defaults on a fresh machine by running the script, then checking System Settings to confirm each took effect. Remove or comment out any that are no-ops.

---

## 6. Consider mise as asdf Successor

`asdf` still works but `mise` (formerly `rtx`) is a drop-in replacement that's faster and adds task running. Migration is straightforward — it reads `tool-versions` files natively.

```bash
brew install mise
# mise reads your existing .tool-versions automatically
```

Low priority — only worth doing if asdf is causing friction.

---

## 7. Modernize setup.sh

### Shell choice
`setup.sh` runs `chsh -s /bin/bash`. macOS defaults to zsh since Catalina. This is fine if intentional, but worth a conscious decision. If staying on bash, no changes needed.

### Solarized download
The script downloads Solarized from `ethanschoonover.com` which may not be reliable. Consider either:
- Removing it (most terminal emulators ship with Solarized built in now, including iTerm2)
- Switching to the GitHub repo URL as a fallback

### SCM Breeze
Still clones and installs SCM Breeze. Verify you still use it — if not, remove that block.

### Neovim setup
The script installs neovim bindings via `gem install neovim`, `pip3 install neovim`, `npm install neovim`. Your vim config uses lazy.nvim now — check if these are still needed by your plugin setup.

---

## 8. Add Other App Sync Paths to macos Script

Your manual steps list apps that need settings imported from cloud sync. Automate the ones that support `defaults write`:

```bash
# Alfred — set sync folder
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "$HOME/Tresorit/Colby/Alfred"

# BTT — set preset sync (BTT uses its own sync mechanism, may need manual setup)

# Karabiner — config lives at ~/.config/karabiner/karabiner.json
# Consider symlinking or adding to the symlink_script.sh files list
```

This would reduce the manual steps list in setup.sh.

---

## 9. Add a Makefile or Just Targets

You already have `just` in your `tool-versions`. Consider adding a `justfile` to make common operations discoverable:

```just
# Apply macOS defaults
macos:
    sh init/macos

# Install Homebrew packages
brew:
    brew bundle --file=Brewfile

# Create symlinks
link:
    sh init/symlink_script.sh

# Full bootstrap
setup:
    sh init/setup.sh

# Diff Brewfile against installed packages
brew-audit:
    brew bundle cleanup --file=Brewfile
```

---

## 10. Gitignore Cleanup

Your global `.gitignore` includes `.claude*` which will prevent committing `.claude/` directories in any repo. This is probably fine for settings files but verify it's not blocking anything you want tracked (e.g., `CLAUDE.md` project instructions). Consider narrowing to `.claude/settings.local.json` if needed.
