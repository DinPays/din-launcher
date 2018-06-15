#!/usr/bin/env bash

base_required ()
{
    if [[ ! -d "$DINPAY_DIR" ]]; then
        error "DinPay Core needs to be installed for this action!"

        press_to_continue

        menu_main
    fi
}

base_not_required ()
{
    if [[ -d "$DINPAY_DIR" ]]; then
        error "DinPay Core needs to be NOT installed for this action!"

        press_to_continue

        menu_main
    fi
}
