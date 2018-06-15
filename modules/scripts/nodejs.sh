#!/usr/bin/env bash

nodejs_install ()
{
    heading "Installing node.js & npm..."

    sudo rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*}
    sudo rm -rf ~/{.npm,.forever,.node*,.cache,.nvm}

    (sudo wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -) | tee -a "$launcher_log"
    (echo "deb https://deb.nodesource.com/node_9.x $(lsb_release -s -c) main" | sudo tee /etc/apt/sources.list.d/nodesource.list) | tee -a "$launcher_log"
    sudo apt-get update | tee -a "$launcher_log"
    sudo apt-get install nodejs -y | tee -a "$launcher_log"

    success "Installed node.js & npm!"
}
