#!/usr/bin/env bash

menu_miscellaneous_help ()
{
    ascii

    text_yellow "    Install OS Updates (U)"
    text_white "    checks for OS updates and installs them if available."
    echo

    text_yellow "    Create Launcher Executable (E)"
    text_white "    lets you create an executable so you can do “./launcher.sh” instead of “bash ./launcher.sh” to start the Launcher."
    echo

    text_yellow "    Create Launcher Alias (A)"
    text_white "    lets you create an alias so you can start Launcher by inputting “launcher” instead of “bash ./launcher.sh”."
    echo

    text_yellow "    Show Help (H)"
    text_white "    opens the help file where all this information is available."

    divider

    text_blue "    For more information head on over to https://dinpay.io/docs/"
    echo

    press_to_continue

    menu_main
}
