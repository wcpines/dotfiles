What started as some humble Bash settings and a few Vim defaults has grown into a large set of custom configs.  Over time I wanted all of the programs I've come to rely on to be installed and configured (mostly) automatically, and any changes to be tracked in version control.

In this repo there are a few configs I use across machines, a set of macos settings to be programmatically installed on any new macs, a manifest of apps and programs (the brewfile), and a script to pull it all together. I hope you find something in here that's uesful!


### Bootstrapping a new Mac
If you want to use the setup script in this repo:

1. Pull down the bootstrap files (_stored in private gist_)

2. Fill out `env_vars.sh` with your information

3. Run the setup file (`setup.sh`)

4. Profit

### Assumptions

`setup.sh` is built to work on *this repo* or a repo that conforms to the (exact) structure of files in this one.  If you want to use it for your own bootstrapping, I recommend reading through the script and changing anything you may need to. For a more general purpose and less opinionated bootstrap approach, check out Mike McQuaid's [strap](https://github.com/MikeMcQuaid/strap).
