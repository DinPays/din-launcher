#!/usr/bin/env bash

miscellaneous_launcher_alias()
{
    heading "Installing alias..."

    echo "alias launcher='bash ${launcher_dir}/launcher.sh'" | tee -a "${HOME}/.bashrc"
    . "${HOME}/.bashrc"

    success "Installation complete!"
}
