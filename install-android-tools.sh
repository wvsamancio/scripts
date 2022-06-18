#!/bin/bash

dependencies=''
url_cmd_line_tools='https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip'
build_tools='build-tools;30.0.3'
platforms='platforms;android-30'

set -e

echo $'\nChecking dependencies...\n'

[ ! $(which curl) ] && dependencies+=' curl'
[ ! $(which zip) ] && dependencies+=' zip'
[ ! $(which java) ] && dependencies+=' openjdk-11-jdk'

if [ "$dependencies" ]; then
    echo $'\nInstalling dependencies...\n'
    sudo apt -qq update && sudo apt -yqq install $dependencies
else
    echo $'\nDependencies are already installed.\n'
fi

echo $'\nDownloading command line yools...\n'

curl $url_cmd_line_tools > tools.zip

echo $'\nConfiguring tools settings...\n'

mkdir -p ~/.android/android-sdk/cmdline-tools && unzip -q tools.zip -d ~/.android/android-sdk/cmdline-tools
mv ~/.android/android-sdk/cmdline-tools/cmdline-tools ~/.android/android-sdk/cmdline-tools/latest
tee -a ~/.bashrc <<<'
export PATH="$PATH:$HOME/.android/android-sdk/cmdline-tools/latest/bin"
export ANDROID_HOME="$HOME/.android/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.android/android-sdk"
' > /dev/null 2>&1

echo $'\nDownloading sdk tools...\n'

${HOME}/.android/android-sdk/cmdline-tools/latest/bin/sdkmanager --install $build_tools $platforms <<< "y" > /dev/null 2>&1

echo $'\nRemoving "tools.zip"...\n'

rm -f tools.zip

echo $'\nScript Done!\n'

${HOME}/.android/android-sdk/cmdline-tools/latest/bin/sdkmanager --list_installed