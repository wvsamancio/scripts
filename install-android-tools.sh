#!/bin/bash

dependencies=''
url_cmd_line_tools='https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip'
build_tools='build-tools;30.0.3'
platforms='platforms;android-30'

echo -e "Checking dependencies...\n"

[ ! $(which curl) ] && dependencies+=' curl'
[ ! $(which zip) ] && dependencies+=' zip'
[ ! $(which java) ] && dependencies+=' openjdk-11-jdk'

if [ "$dependencies" ]; then
    echo -e "Installing $dependencies...\n"
    sudo apt -qq update && sudo apt -yqq install $dependencies
else
    echo -e "Dependencies are already installed.\n"
fi

echo -e "Downloading command line tools...\n"

curl $url_cmd_line_tools > tools.zip

echo -e "Configuring tools settings...\n"

mkdir -p ~/.android/android-sdk/cmdline-tools && unzip -q tools.zip -d ~/.android/android-sdk/cmdline-tools
mv ~/.android/android-sdk/cmdline-tools/cmdline-tools ~/.android/android-sdk/cmdline-tools/latest

echo -e "Configuring environment...\n"

export PATH="$PATH:$HOME/.android/android-sdk/cmdline-tools/latest/bin"
export ANDROID_HOME="$HOME/.android/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.android/android-sdk"

tee -a ~/.bashrc <<<'
export PATH="$PATH:$HOME/.android/android-sdk/cmdline-tools/latest/bin"
export ANDROID_HOME="$HOME/.android/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.android/android-sdk"
'

echo -e "Downloading sdk tools...\n"

yes | sdkmanager --install $build_tools $platforms > /dev/null 2>&1

echo -e "Removing \"tools.zip\"...\n"

rm -f tools.zip

sdkmanager --list_installed

echo -e "Script Done!"