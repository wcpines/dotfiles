What started as some humble Bash settings and a few Vim defaults has grown into a large set of custom configs.  Over time I wanted all of the programs I've come to rely on to be installed and configured (mostly) automatically, and any changes to be tracked in version control.

In this repo there are a few configs I use across machines, a set of macos settings to be programmatically installed on any new macs, a manifest of apps and programs (the brewfile), and a script to pull it all together. I hope you find something in here that's uesful!


### Bootstrapping a new Mac

1. Download `init/setup.sh` from the private bootstrap location.

2. Run `bash setup.sh`.

3. The script installs Homebrew, opens GitHub's browser-based login flow, and
   clones this repository over SSH. Complete that login from any available
   device. 1Password does not need to be installed first.

4. The script installs the Brewfile, links the dotfiles, installs the global
   Mise tools, and applies the macOS defaults.

5. Restart the Mac to apply all macOS settings.

### Karabiner-Elements

The `karabiner/` directory is the tracked Karabiner-Elements configuration.
The link script links it to `~/.config/karabiner`.

Use the Karabiner-Elements app to edit the configuration.
Then review and commit the changes in this repository.
Karabiner automatic backups are local recovery files and are not tracked.

### Rectangle

The `rectangle/RectangleConfig.json` file is the tracked Rectangle configuration.
Rectangle does not accept a symlink for its import file.

During setup, `init/prepare_rectangle_config.sh` copies the tracked file to Rectangle's one-time import location.
When Rectangle starts, select **Apply** to import it.
Rectangle renames the import file after it applies the configuration.

If you change Rectangle settings, export the configuration from Rectangle settings to `rectangle/RectangleConfig.json`.
Then review and commit the change.

### BetterTouchTool archive

`bettertouchtool/pre-migration.bttpreset` is the exported BetterTouchTool configuration before the migration.
It is an archive for rollback and reference.

### Assumptions

`setup.sh` is built to work on *this repo* or a repo that conforms to the (exact) structure of files in this one.  If you want to use it for your own bootstrapping, I recommend reading through the script and changing anything you may need to. For a more general purpose and less opinionated bootstrap approach, check out Mike McQuaid's [strap](https://github.com/MikeMcQuaid/strap).
