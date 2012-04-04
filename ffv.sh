#!/usr/bin/env bash

mkdir -p /Applications/Firefox-Versions
mkdir -p ~/.ffv && cd ~/.ffv

versions=('3.6.9' '4.0.1' '5.0.1' '6.0.2' '7.0.1' '8.0.1' '9.0.1' '10.0.1')

for i in "${versions[@]}"; do
    echo "### INSTALLING FIREFOX $i ###"
    if [ -f ./Firefox-$i.dmg ]
        then
            echo "  # Skipping download Firefox $i #"
        else
            echo "  # Downloading Firefox $i #"
            curl -L ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$i/mac/en-GB/Firefox%20$i.dmg -o ./Firefox-$i.dmg
    fi
    hdiutil mount ./Firefox-$i.dmg
    echo "  # Copying application to /Applications/Firefox-Versions/Firefox-$i #"
    cp -R /Volumes/Firefox/Firefox.app/ /Applications/Firefox-Versions/Firefox-$i.app
    hdiutil unmount /Volumes/Firefox/

    echo "  # Creating profile for Firefox-$i #"
    /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin -CreateProfile Firefox-$i

    echo ""
    echo "  # Disabling auto update and default browser check for Firefox-$i #"
    find ~/Library/Application\ Support/Firefox/Profiles/*.Firefox-$i -name prefs.js -print0 -exec sh -c 'echo "
    user_pref(\"app.update.auto\", false);
    user_pref(\"app.update.disable_button.showUpdateHistory\", false);
    user_pref(\"app.update.enabled\", false);
    user_pref(\"browser.shell.checkDefaultBrowser\", false);
    user_pref(\"browser.rights.3.shown\", true);" >> $1' -- {} \;

    echo "  # Binding profile for Firefox-$i #"
    mv /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig
    mv /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-orig
    echo "#!/bin/bash
    exec \"/Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig\" -P Firefox-$i" > /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin
    chmod +x /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin
    ln -s /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox

    echo "### FINISHED INSTALLING FIREFOX $i ###"
    echo ""
done
