#!/usr/bin/env bash

menu_miscellaneous ()
{
    ascii

    text_white "    U. Install OS Updates"
    text_white "    E. Create Launcher Executable"
    text_white "    A. Create Launcher Alias"

    divider

    text_white "    H. Show Help"

    divider

    text_white "    X. Back to Main Menu"

    divider

    menu_miscellaneous_parse_args
}
