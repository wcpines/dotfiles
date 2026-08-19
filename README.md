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

### Assumptions

`setup.sh` is built to work on *this repo* or a repo that conforms to the (exact) structure of files in this one.  If you want to use it for your own bootstrapping, I recommend reading through the script and changing anything you may need to. For a more general purpose and less opinionated bootstrap approach, check out Mike McQuaid's [strap](https://github.com/MikeMcQuaid/strap).
