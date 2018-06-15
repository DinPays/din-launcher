#!/usr/bin/env bash

menu_manage_base_parse_args ()
{
    local choice

    read -p "$(text_blue "    Please enter your choice: ")" choice

    case "$choice" in
        u|U)
            base_update

            press_to_continue
        ;;
        p|P)
            base_uninstall

            press_to_continue
        ;;
        c|C)
            base_configure

            press_to_continue
        ;;
        h|H)
            menu_manage_base_help
        ;;
        x|X)
            menu_main
        ;;
        *)
            echo -e "$(text_yellow "    Invalid option chosen, please select a valid option and try again.")"
            wait_to_continue
            menu_manage_base
        ;;
    esac
}
