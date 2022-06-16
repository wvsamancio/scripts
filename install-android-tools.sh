#!/bin/bash

dependencies='curl zip openjdk-11-jdk'
url_cmd_line_tools='https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip'
build_tools='build-tools;30.0.3'
platforms='platforms;android-30'

set -e

echo $'\nInstalling dependencies...\n'
sudo apt -qq update && sudo apt -yqq install $dependencies

echo $'\nDownloading command line yools...\n'
curl $url_cmd_line_tools > tools.zip

echo $'\nConfiguring tools settings...\n'
sudo mkdir -p /opt/android-sdk/cmdline-tools && sudo unzip -q tools.zip -d /opt/android-sdk/cmdline-tools
sudo mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest
sudo ln -s /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager /usr/bin/sdkmanager

echo $'\nDownloading sdk tools...\n'
sudo sdkmanager --install $build_tools $platforms <<< "y" > /dev/null 2>&1

echo $'\nRemoving "tools.zip"...\n'
rm -f tools.zip

sdkmanager --list_installed

echo $'\nScript Done!\n'