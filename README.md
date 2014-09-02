# FFVesr - Firefox Versions (ESR)

This script is a fork of https://github.com/micmcg/FFV.

**FFVesr** is a script that installs a selection of Firefox ESR versions, creates profiles for each version and hard binds each version to it's profile. It also disables auto updates and the default browser check.

It currently installs lastest Firefox ESR **10.0.x**, **17.0.x**, **24.x**, **31.x**.

This script assumes that you are probably running a standard, autoupdating copy of Firefox with a configured profile and will leave it alone. It's perfectly safe to run this along side a standard Firefox install.

**THIS SCRIPT IS VERY BETA**
Feel free to offer criticism and feedback and areas for improvement. Or fork and improve it :-)

This only works on OS X and it's entirely possible it relies on things specific to my system configuration. Please file an issue if that is the case.

To install run

	curl -s https://raw.github.com/smk/FFV/master/ffv.sh | bash

By default it will use the cached installers if they exist and won't overwrite existing applications and profiles. This should mean when a new version comes out (and I update the script) you can just run it again and it will only download and install the new version

You'll probably notice Finder popping up as it mounts the .dmgs, just leave it to do it's thing, it will unmount them automatically once it's installed the app.

It will take a while to install all versions when downloading the installers for the first time, set it running and go make a cup of tea.

There are a couple of options you can pass in as well

**CLEAN=true** - Clean install, tell the script to redownload the installers

	curl -s https://raw.github.com/smk/FFV/master/ffv.sh | CLEAN=true bash

**FORCE=true** - Force the script to overwrite existing applications & profiles

	curl -s https://raw.github.com/smk/FFV/master/ffv.sh | FORCE=true bash

So if you ever get stuck, **CLEAN=true FORCE=true** should get you back to a pristine state

	curl -s https://raw.github.com/smk/FFV/master/ffv.sh | CLEAN=true FORCE=true bash

**UNINSTALL=true** - If you decide you don't like FFV, this will remove the installers cache, the FFV versions of the Firefox app and the FFV Firefox profiles.

	curl -s https://raw.github.com/smk/FFV/master/ffv.sh | UNINSTALL=true bash

If you have a local copy of the script you can use command line flags instead, `-c`, `-f` and `-u` respectively, e.g

	./ffv.sh -c -f

The Firefox versions are installed to `/Applications/Firefox-Versions/` and the installer cache is in `~/.ffv`. Profiles will be named with the form `Firefox-X.Y.Z-FFV`

##To Do

* A way to specify which versions you want to install
* ~~Better checking of whether things already exist when creating them, (currently only checking the cached .dmg)~~
* ~~Option to empty the cache and force a fresh download of the .dmgs~~
* ~~An uninstall option that removes the cache, the firefox apps and the profiles~~
* Maybe scrape the firefox release page to work out when new major versions are released
