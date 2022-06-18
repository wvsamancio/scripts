#!/bin/bash

dependencies=''
url_flutter='https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_1.22.5-stable.tar.xz'

set -e

echo $'\nChecking dependencies...\n'

[ ! $(which bash) ] && dependencies+=' bash'
[ ! $(which curl) ] && dependencies+=' curl'
[ ! $(which file) ] && dependencies+=' file'
[ ! $(which git) ] && dependencies+=' git'
[ ! $(which mkdir) ] && dependencies+=' mkdir'
[ ! $(which rm) ] && dependencies+=' rm'
[ ! $(which unzip) ] && dependencies+=' zip'
[ ! $(which xz) ] && dependencies+=' xz-utils'

if [ "$dependencies" ]; then
    echo $'\nInstalling dependencies...\n'
    sudo apt -qq update && sudo apt -yqq install $dependencies
else
    echo $'\nDependencies are already installed.\n'
fi

echo $'\nDownloading flutter...\n'

curl $url_flutter > flutter.tar.xz

echo $'\nConfiguring flutter...\n'

tar xf flutter.tar.xz && mv flutter .flutter
if [ $(pwd) != "$HOME" ]; then
    mv .flutter ~
fi
tee -a ~/.bashrc <<<'
export PATH="$PATH:$HOME/.flutter/bin"
' > /dev/null 2>&1

echo $'\nDownloading flutter tools...\n'

${HOME}/.flutter/bin/flutter precache
yes | ${HOME}/.flutter/bin/flutter doctor --android-licenses
${HOME}/.flutter/bin/flutter doctor

echo $'\nRemoving "tools.zip"...\n'

rm -f flutter.tar.xz

echo $'\nScript Done!\n'