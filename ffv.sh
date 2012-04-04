#!/usr/bin/env bash

mkdir -p /Applications/Firefox-Versions
mkdir -p ~/.ffv && cd ~/.ffv

versions=('3.6.9' '4.0.1' '5.0.1' '6.0.2' '7.0.1' '8.0.1' '9.0.1' '10.0.1')

force=false
clean=false

while getopts ":f :c" opt; do
    case $opt in
    f)
        echo "Enabling -Force mode, will overwrite applications and profiles" >&2
        force=true
        ;;
    c)
        echo "Enabling -Clean mode, will download fresh copies of the installers" >&2
        clean=true
        ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

for i in "${versions[@]}"; do
    echo ""
    echo "### INSTALLING FIREFOX $i ###"
    if ! $clean && [ -f ./Firefox-$i.dmg ]
        then
            echo "  # Skipping download Firefox $i #"
        else
            echo "  # Downloading Firefox $i #"
            curl -L ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$i/mac/en-GB/Firefox%20$i.dmg -o ./Firefox-$i.dmg
    fi
    if ! $force && [ -d /Applications/Firefox-Versions/Firefox-$i.app ]
        then
            echo "  # Skipping copying application #"
        else
            echo "  # Copying application to /Applications/Firefox-Versions/Firefox-$i #"
            if [ -d /Volumes/Firefox ]
                then
                    echo "  # Unmounting existing Firefox Installer"
                    hdiutil unmount /Volumes/Firefox/
            fi
            hdiutil mount ./Firefox-$i.dmg
            if [ -d /Applications/Firefox-Versions/Firefox-$i.app ]
                then
                    rm -rf /Applications/Firefox-Versions/Firefox-$i.app
            fi
            cp -R /Volumes/Firefox/Firefox.app/ /Applications/Firefox-Versions/Firefox-$i.app
            hdiutil unmount /Volumes/Firefox/
    fi
    if ! $force && [ -f ~/Library/Application\ Support/Firefox/Profiles/*.Firefox-$i/prefs.js ]
        then
            echo "  # Skipping profile creation #"
        else
            if [ -d ~/Library/Application\ Support/Firefox/Profiles/*.Firefox-$i ]
                then
                echo "  # Deleting existing profile Firefox-$i #"
                rm -rf ~/Library/Application\ Support/Firefox/Profiles/*.Firefox-$i
            fi

            echo "  # Creating profile for Firefox-$i #"
            if [ -f /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig ]
                then
                    /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig -CreateProfile Firefox-$i
                else
                    /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin -CreateProfile Firefox-$i
            fi
            echo ""
            echo "  # Disabling auto update and default browser check for Firefox-$i #"
            find ~/Library/Application\ Support/Firefox/Profiles/*.Firefox-$i -name prefs.js -print0 -exec sh -c 'echo "
            user_pref(\"app.update.auto\", false);
            user_pref(\"app.update.disable_button.showUpdateHistory\", false);
            user_pref(\"app.update.enabled\", false);
            user_pref(\"browser.shell.checkDefaultBrowser\", false);
            user_pref(\"browser.rights.3.shown\", true);" >> $1' -- {} \;
            echo ""
    fi

    if ! $force && [ -f /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig ]
        then
            echo "  # Skipping profile binding #"
        else
            echo "  # Binding profile for Firefox-$i #"
            mv /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig
            echo "#!/bin/bash
            exec \"/Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin-orig\" -P Firefox-$i" > /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin
            chmod +x /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin

            if [ -f /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox ]
                # Newer versions of Firefox use firefox not firefox-bin
                then
                    mv /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-orig
                    ln -s /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox-bin /Applications/Firefox-Versions/Firefox-$i.app/Contents/MacOS/firefox
            fi
    fi

    echo "### FINISHED INSTALLING FIREFOX $i ###"
    echo ""
done

echo "### FINISHED INSTALLING ALL FIREFOXES ###"


