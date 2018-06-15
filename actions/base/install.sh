#!/usr/bin/env bash

base_install ()
{
    ascii

    if [[ -d "$DINPAY_DIR" ]]; then
        error "We found an existing DinPay Core installation! Please use the uninstall option first."
    else
        heading "Installing DinPay Core..."

        sudo mkdir "$DINPAY_DIR" >> "$launcher_config"
        sudo chown "$USER":"$USER" "$DINPAY_DIR" >> "$launcher_config"
        sudo rm -rf "$DINPAY_DIR" >> "$launcher_config"
        git clone "$DINPAY_REPO" "$DINPAY_DIR" >> "$launcher_config"
        cd "$DINPAY_DIR"
        lerna bootstrap >> "$launcher_config"

        base_configure

        success "Installed DinPay Core!"
    fi
}
