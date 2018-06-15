#!/usr/bin/env bash

base_uninstall ()
{
    ascii

    heading "Uninstalling DinPay Core..."

    forger_delete

    relay_delete

    database_destroy

    database_drop_user

    sudo rm -rf "$DINPAY_DIR"
    sudo rm -rf "$DINPAY_DB"

    success "Uninstalled DinPay Core!"
}
