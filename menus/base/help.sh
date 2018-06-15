#!/usr/bin/env bash

menu_manage_base_help ()
{
    ascii

    divider

    text_yellow "    Update DinPay (U)"
    text_white "    update DinPay base if a new version is available."
    echo

    text_yellow "    Uninstall DinPay (P)"
    text_white "    uninstall DinPay Core from your system."
    echo

    text_yellow "    Configure DinPay (C)"
    text_white "    lets you select a network configuration and automatically creates the database for the config you chose."
    echo

    text_yellow "    Show Help (H)"
    text_white "    opens the help file where all this information is available."

    divider

    text_blue "    For more information head on over to https://dinpay.io/docs"
    echo

    press_to_continue

    menu_main
}
