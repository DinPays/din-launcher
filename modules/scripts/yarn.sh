#!/usr/bin/env bash

yarn_install ()
{
    heading "Installing Yarn..."

    (curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -) | tee -a "$launcher_log"
    (echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list) | tee -a "$launcher_log"

    sudo apt-get update | tee -a "$launcher_log"
    sudo apt-get install -y yarn | tee -a "$launcher_log"

    success "Installed Yarn!"
}
