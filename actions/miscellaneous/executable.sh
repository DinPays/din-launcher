#!/usr/bin/env bash

miscellaneous_launcher_executable()
{
    heading "Making Launcher executable..."

    chmod +x "${launcher_dir}/launcher.sh"

    success "Operation complete!"
}
