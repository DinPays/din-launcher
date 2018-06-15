#!/usr/bin/env bash

pgsql_start ()
{
    heading "Starting PostgreSQL..."

    sudo systemctl start postgresql | tee -a "$launcher_log"

    pgsql_status

    success "Started PostgreSQL!"
}

pgsql_stop ()
{
    heading "Stopping PostgreSQL..."

    sudo systemctl stop postgresql | tee -a "$launcher_log"

    pgsql_status

    success "Stopped PostgreSQL!"
}

pgsql_restart ()
{
    heading "Restarting PostgreSQL..."

    sudo systemctl restart postgresql | tee -a "$launcher_log"

    pgsql_status

    success "Restarted PostgreSQL!"
}

pgsql_install ()
{
    heading "Installing PostgreSQL..."

    (sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg main") | tee -a "$launcher_log"
    (sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -) | tee -a "$launcher_log"

    sudo apt-get update | tee -a "$launcher_log"
    sudo apt-get install -y postgresql-10 | tee -a "$launcher_log"

    pgsql_start

    success "Installed PostgreSQL!"
}

pgsql_status ()
{
    local status=$(sudo pgrep -x postgres)

    if [[ -z "$status" ]]; then
        STATUS_PGSQL="Off"
    else
        STATUS_PGSQL="On"
    fi
}
