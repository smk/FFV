# FFV - Firefox Versions

**FFV** is a script that installs a selection of Firefox versions, creates profiles for each version and binds each version to it's profile. It also disables auto updates and the default browser check. 

It currently installs Firefox 3.6.9, 4.0.1, 5.0.1, 6.0.2, 7.0.1, 8.0.1, 9.0.1 & 10.0.1

**THIS SCRIPT IS VERY ALPHA**
I'm not the strongest bash scripter and I banged this out quickly tonight. Feel free to offer criticism and feedback and areas for improvement. Or fork and improve it :-)

This only works on OS X and it's entirely possible it relies on things specific to my system configuration. Please file an issue if that is the case. 

To install run 

	curl -s https://raw.github.com/micmcg/FFV/master/ffv.sh | bash

You'll probably notice Finder popping up as it mounts the .dmgs, just leave it to do it's thing, it will unmount them automatically once it's installed the app.  

###To Do

* Better checking of whether things already exist when creating them, (currently only checking the cached .dmg)
* Option to empty the cache and force a fresh download of the .dmgs 
* An uninstall option that removes the cache, the firefox apps and the profiles 
* A way to specify which versions you want to install
* Maybe scrape the firefox release page to work out when new major versions are released 
