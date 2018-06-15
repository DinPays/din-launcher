#!/usr/bin/env bash

setup_environment ()
{
    sudo echo "Requesting sudo permissions for $USER"

    sudo updatedb

    set_locale

    if [[ $(systemd-detect-virt) == "lxc" ]] || [[ $(systemd-detect-virt) == "openvz" ]]; then
        CONTAINER=1
    else
        CONTAINER=0
    fi

    if [[ ! -f "$launcher_config" ]]; then
        ascii

        install_base_dependencies
        install_program_dependencies
        install_nodejs_dependencies
        install_system_updates

        touch "$launcher_config"

        echo "DINPAY_REPO=https://github.com/dinpay/dinpay" >> "$launcher_config"
        echo "DINPAY_DIR=${HOME}/dinpay" >> "$launcher_config"
        echo "DINPAY_DB=${HOME}/.dinpay" >> "$launcher_config"
        echo "DINPAY_PRESET=${HOME}/.dinpay/config" >> "$launcher_config"
        echo "DINPAY_TOKEN=din" >> "$launcher_config"
        echo "DINPAY_NETWORK=devnet" >> "$launcher_config"
        echo "EXPLORER_REPO=https://github.com/dinpay/explorer" >> "$launcher_config"
        echo "EXPLORER_DIR=${HOME}/dinpay-explorer" >> "$launcher_config"

        success "All system dependencies have been installed! The system will restart now."

        press_to_continue

        sudo reboot
    fi

    if [[ -e "$launcher_config" ]]; then
        . "$launcher_config"
    fi
}
