#!/usr/bin/env bash

menu_manage_base ()
{
    ascii

    forger_status

    text_white "    U. Update DinPay"
    text_white "    P. Uninstall DinPay"
    text_white "    C. Configure DinPay"

    divider

    text_white "    H. Show Help"

    divider

    text_white "    X. Back to Main Menu"

    divider

    menu_manage_base_parse_args
}
