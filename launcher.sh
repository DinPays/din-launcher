#!/usr/bin/env bash

# -------------------------
# Variables
# -------------------------

launcher=$(basename "$0")
launcher_dir="$(cd "$(dirname "$0")" && pwd)"
launcher_log="${launcher_dir}/logs/launcher.log"
launcher_config="${HOME}/.launcher"

# -------------------------
# Helpers
# -------------------------

. "${launcher_dir}/helpers/typography.sh"
. "${launcher_dir}/helpers/continue.sh"
. "${launcher_dir}/helpers/errors.sh"
. "${launcher_dir}/helpers/base.sh"

# -------------------------
# Scripts
# -------------------------

. "${launcher_dir}/modules/scripts/locale.sh"
. "${launcher_dir}/modules/scripts/nodejs.sh"
. "${launcher_dir}/modules/scripts/ntp.sh"
. "${launcher_dir}/modules/scripts/pm2.sh"
. "${launcher_dir}/modules/scripts/postgresql.sh"
. "${launcher_dir}/modules/scripts/redis.sh"
. "${launcher_dir}/modules/scripts/yarn.sh"

# -------------------------
# Menus
# -------------------------

. "${launcher_dir}/menus/ascii.sh"

# -------------------------
# Modules
# -------------------------

. "${launcher_dir}/modules/bootstrap.sh"
. "${launcher_dir}/modules/environment.sh"
. "${launcher_dir}/modules/versions.sh"
. "${launcher_dir}/modules/state.sh"
. "${launcher_dir}/modules/update.sh"
. "${launcher_dir}/modules/processes.sh"
. "${launcher_dir}/modules/database.sh"
. "${launcher_dir}/modules/dependencies.sh"

# -------------------------
# Actions
# -------------------------

. "${launcher_dir}/actions/apps/launcher.sh"
. "${launcher_dir}/actions/apps/explorer.sh"
. "${launcher_dir}/actions/apps/forger.sh"
. "${launcher_dir}/actions/apps/relay.sh"
. "${launcher_dir}/actions/base/configure.sh"
. "${launcher_dir}/actions/base/install.sh"
. "${launcher_dir}/actions/base/uninstall.sh"
. "${launcher_dir}/actions/base/update.sh"
. "${launcher_dir}/actions/miscellaneous/alias.sh"
. "${launcher_dir}/actions/miscellaneous/executable.sh"
. "${launcher_dir}/actions/miscellaneous/updates.sh"
. "${launcher_dir}/actions/log.sh"
. "${launcher_dir}/actions/process_monitor.sh"

# -------------------------
# Menus - Items
# -------------------------

. "${launcher_dir}/menus/launcher/help.sh"
. "${launcher_dir}/menus/launcher/args.sh"
. "${launcher_dir}/menus/launcher/menu.sh"
. "${launcher_dir}/menus/base/help.sh"
. "${launcher_dir}/menus/base/args.sh"
. "${launcher_dir}/menus/base/menu.sh"
. "${launcher_dir}/menus/explorer/help.sh"
. "${launcher_dir}/menus/explorer/args.sh"
. "${launcher_dir}/menus/explorer/menu.sh"
. "${launcher_dir}/menus/forger/help.sh"
. "${launcher_dir}/menus/forger/args.sh"
. "${launcher_dir}/menus/forger/menu.sh"
. "${launcher_dir}/menus/miscellaneous/help.sh"
. "${launcher_dir}/menus/miscellaneous/args.sh"
. "${launcher_dir}/menus/miscellaneous/menu.sh"
. "${launcher_dir}/menus/relay/help.sh"
. "${launcher_dir}/menus/relay/args.sh"
. "${launcher_dir}/menus/relay/menu.sh"
. "${launcher_dir}/menus/main/help.sh"
. "${launcher_dir}/menus/main/args.sh"
. "${launcher_dir}/menus/main/menu.sh"

# -------------------------
# Start
# -------------------------

main ()
{
    setup_environment
    miscellaneous_install_updates
    launcher_update

    if [[ -d "$DINPAY_DIR" ]]; then
        base_update
    else
        STATUS_BASE_UPDATE="n/a"
    fi

    if [[ -d "$EXPLORER_DIR" ]]; then
        explorer_update
    fi

    while true; do
        menu_main
    done

    trap cleanup SIGINT SIGTERM SIGKILL
}

main "$@"
