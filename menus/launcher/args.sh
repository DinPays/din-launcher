#!/usr/bin/env bash

menu_manage_launcher_parse_args ()
{
    local choice

    read -p "$(text_blue "    Please enter your choice: ")" choice

    case "$choice" in
        r|R)
            launcher_configure_repo

            press_to_continue
        ;;
        a|A)
            launcher_configure_base_directory

            press_to_continue
        ;;
        d|D)
            launcher_configure_data_directory

            press_to_continue
        ;;
        c|C)
            launcher_configure_config_directory

            press_to_continue
        ;;
        t|T)
            launcher_configure_token

            press_to_continue
        ;;
        n|N)
            launcher_configure_token_network

            press_to_continue
        ;;
        s|S)
            launcher_configure_explorer_repo

            press_to_continue
        ;;
        e|E)
            launcher_configure_explorer_directory

            press_to_continue
        ;;
        h|H)
            menu_manage_launcher_help
        ;;
        x|X)
            menu_main
        ;;
        *)
            echo -e "$(text_yellow "    Invalid option chosen, please select a valid option and try again.")"
            wait_to_continue
            menu_manage_launcher
        ;;
    esac
}
