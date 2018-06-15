#!/usr/bin/env bash

forger_start ()
{
    ascii

    heading "Starting Forger..."

    local bip38=$(jq -r '.bip38 // empty' "$DINPAY_PRESET/delegates.json")

    if [[ -z "$bip38" ]]; then
        __forger_start_without_bip38
    else
        __forger_start_with_bip38
    fi

    forger_status

    success "Started Forger!"
}

forger_restart ()
{
    ascii

    heading "Restarting Forger..."

    pm2 restart dinpay-core-forger | tee -a "$launcher_log"

    forger_status

    success "Restarted Forger!"
}

forger_stop ()
{
    ascii

    heading "Stopping Forger..."

    pm2 stop dinpay-core-forger | tee -a "$launcher_log"

    forger_status

    success "Stopped Forger!"
}

forger_delete ()
{
    ascii

    heading "Deleting Forger..."

    pm2 delete dinpay-core-forger | tee -a "$launcher_log"

    forger_status

    success "Deleted Forger!"
}

forger_logs ()
{
    clear
    echo -e "\n$(text_yellow " Use Ctrl+C to return to menu")\n"
    trap : INT

    pm2 logs dinpay-core-forger
}

forger_status ()
{
    local status=$(pm2 status 2>/dev/null | fgrep "dinpay-core-forger" | awk '{print $10}')

    if [[ "$status" == "online" ]]; then
        STATUS_FORGER="On"
    else
        STATUS_FORGER="Off"
    fi
}

forger_configure ()
{
    ascii

    read -p "Would you like to use secure bip38 encryption? [Y/n] : " choice

    if [[ -z "$choice" || "$choice" =~ ^(yes|y|Y) ]]; then
        __forger_configure_bip38
    else
        __forger_configure_plain
    fi
}

__forger_configure_plain ()
{
    read -sp "Please enter your delegate secret: " inputSecret
    echo

    $(node "$DINPAY_DIR/packages/base/bin/dinpay" forger-plain --config "$DINPAY_PRESET" --secret "$inputSecret")

    local status=$?

    if [[ $status -ne 0 ]]; then
        error "Sorry, an unknown error occurred. Please try again." | tee -a "$launcher_log"
    else
        read -p "The forger has been configured, would you like to start the forger? [Y/n] : " choice

        if [[ -z "$choice" || "$choice" =~ ^(yes|y|Y) ]]; then
            forger_start
        fi
    fi
}

__forger_configure_bip38 ()
{
    read -sp "Please enter your delegate secret: " inputSecret
    echo
    read -sp "Please enter your bip38 password: " inputBip38
    echo

    warning "Hang in there while we encrypt your secret..."

    $(node "$DINPAY_DIR/packages/base/bin/dinpay" forger-bip38 --config "$DINPAY_PRESET" --token "$DINPAY_TOKEN" --network "$DINPAY_NETWORK" --secret "$inputSecret" --password "$inputBip38")

    local status=$?

    if [[ $status -ne 0 ]]; then
        error "Sorry, an unknown error occurred. Please try again." | tee -a "$launcher_log"
    else
        read -p "The forger has been configured, would you like to start the forger? [Y/n] : " choice

        if [[ -z "$choice" || "$choice" =~ ^(yes|y|Y) ]]; then
            forger_start
        fi
    fi
}

__forger_start_with_bip38 ()
{
    local bip38=$(jq -r '.bip38' "$DINPAY_PRESET/delegates.json")

    read -sp "Please enter your bip38 password: " password

    pm2 start "$DINPAY_DIR/packages/base/bin/dinpay" --name dinpay-core-forger -- forger --data "$DINPAY_DB" --config "$DINPAY_PRESET" --token "$DINPAY_TOKEN" --network "$DINPAY_NETWORK" --bip38 "$bip38" --password "$password" | tee -a "$launcher_log"
}

__forger_start_without_bip38 ()
{
    pm2 start "$DINPAY_DIR/packages/base/bin/dinpay" --name dinpay-core-forger -- forger --data "$DINPAY_DB" --config "$DINPAY_PRESET" --token "$DINPAY_TOKEN" --network "$DINPAY_NETWORK" | tee -a "$launcher_log"
}
