#!/bin/bash

dependencies='curl zip openjdk-11-jdk'
url_cmd_line_tools='https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip'
build_tools='build-tools;30.0.3'
platforms='platforms;android-30'

set -e

echo "Installing Dependencies..."
sudo apt -qq update && sudo apt -yqq install $dependencies

echo "Downloading Command Line Tools..."
curl $url_cmd_line_tools > tools.zip && unzip -q tools.zip

echo "Configuring Tools Directory..."
mkdir -p ${HOME}/Android && mv cmdline-tools ${HOME}/Android

echo "Downloading Android Tools..."
${HOME}/Android/cmdline-tools/bin/sdkmanager \
    --sdk_root=${HOME}/Android/ \
    --install $build_tools $platforms <<< "y" > /dev/null 2>&1

${HOME}/Android/cmdline-tools/bin/sdkmanager \
    --sdk_root=${HOME}/Android/ \
    --list_installed

echo "Removing \"tools.zip\"..."
rm -f tools.zip

echo "Script Done!"