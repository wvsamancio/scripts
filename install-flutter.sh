#!/bin/bash

dependencies=''
url_flutter='https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_1.22.5-stable.tar.xz'

echo -e "Checking dependencies...\n"

[ ! $(which bash) ] && dependencies+=' bash'
[ ! $(which curl) ] && dependencies+=' curl'
[ ! $(which file) ] && dependencies+=' file'
[ ! $(which git) ] && dependencies+=' git'
[ ! $(which mkdir) ] && dependencies+=' mkdir'
[ ! $(which rm) ] && dependencies+=' rm'
[ ! $(which unzip) ] && dependencies+=' zip'
[ ! $(which xz) ] && dependencies+=' xz-utils'

if [ "$dependencies" ]; then
    echo -e "Installing $dependencies...\n"
    sudo apt -qq update && sudo apt -yqq install $dependencies
else
    echo -e "Dependencies are already installed.\n"
fi

echo -e "Downloading flutter...\n"

curl $url_flutter > flutter.tar.xz

echo -e "Configuring flutter...\n"

tar xf flutter.tar.xz && mv flutter .flutter
if [ $(pwd) != "$HOME" ]; then
    mv .flutter ~
fi

echo -e "Configuring environment...\n"

export PATH="$PATH:$HOME/.flutter/bin"

tee -a ~/.bashrc <<<'
export PATH="$PATH:$HOME/.flutter/bin"
'

echo -e "Downloading flutter tools...\n"

flutter precache
flutter doctor
yes | flutter doctor --android-licenses
flutter --version

echo -e "Removing \"flutter.tar.xz\"...\n"

rm -f flutter.tar.xz

echo -e "Script Done!"