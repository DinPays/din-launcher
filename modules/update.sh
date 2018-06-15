#!/usr/bin/env bash

launcher_update ()
{
    cd "$launcher_dir"

    local remote_version=$(git rev-parse origin/master)
    local local_version=$(git rev-parse HEAD)

    if [[ "$remote_version" == "$local_version" ]]; then
        STATUS_LAUNCHER_UPDATE="No"

        info "You already have the latest DinPay Launcher version that we support."
    else
        STATUS_LAUNCHER_UPDATE="Yes"

        read -p "An update is available for DinPay Launcher, do you want to install it? [Y/n] : " choice

        if [[ -z "$choice" || "$choice" =~ ^(yes|y|Y) ]]; then
            heading "Starting Update..."
            git reset --hard | tee -a "$launcher_log"
            git pull | tee -a "$launcher_log"
            success "Update OK!"

            STATUS_LAUNCHER_UPDATE="No"

            press_to_continue
        fi
    fi
}
