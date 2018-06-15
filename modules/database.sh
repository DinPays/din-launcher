#!/usr/bin/env bash

database_drop_user ()
{
    heading "Dropping Database User..."
    sudo -u postgres dropuser --if-exists "$USER" | tee -a "$launcher_log"
    success "Dropped Database User!"
}

database_destroy ()
{
    heading "Destroying Database..."
    sudo -u postgres dropdb --if-exists "dinpay_${DINPAY_NETWORK}" | tee -a "$launcher_log"
    success "Destroyed Database!"
}

database_create ()
{
    heading "Creating Database..."
    wait_to_continue
    sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD 'password' CREATEDB;" | tee -a "$launcher_log"
    wait_to_continue
    createdb "dinpay_${DINPAY_NETWORK}"
    success "Created Database!"
}

database_close ()
{
    heading "Closing Database..."
    sudo -u postgres psql -c "UPDATE pg_database SET datallowconn = false WHERE datname = 'dinpay_${DINPAY_NETWORK}';" | tee -a "$launcher_log"
    sudo -u postgres psql -c "SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'dinpay_${DINPAY_NETWORK}' AND pid <> pg_backend_pid();" | tee -a "$launcher_log"
    success "Closed Database!"
}
