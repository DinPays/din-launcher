#!/usr/bin/env bash

relay_start ()
{
    ascii

    heading "Starting Relay..."

    (pm2 start "$DINPAY_DIR/packages/base/bin/dinpay" --name dinpay-base-relay -- relay --data "$DINPAY_DB" --config "$DINPAY_PRESET" --token "$DINPAY_TOKEN" --network "$DINPAY_NETWORK") | tee -a "$launcher_log"

    relay_status

    success "Started Relay!"
}

relay_restart ()
{
    ascii

    heading "Restarting Relay..."

    pm2 restart dinpay-base-relay | tee -a "$launcher_log"

    relay_status

    success "Restarted Relay!"
}

relay_stop ()
{
    ascii

    heading "Stopping Relay..."

    pm2 stop dinpay-base-relay | tee -a "$launcher_log"

    relay_status

    success "Stopped Relay!"
}

relay_delete ()
{
    ascii

    heading "Deleting Relay..."

    pm2 delete dinpay-base-relay | tee -a "$launcher_log"

    relay_status

    success "Deleted Relay!"
}

relay_logs ()
{
    clear
    echo -e "\n$(text_yellow " Use Ctrl+C to return to menu")\n"
    trap : INT

    pm2 logs dinpay-base-relay
}

relay_status ()
{
    local status=$(pm2 status 2>/dev/null | fgrep "dinpay-base-relay" | awk '{print $10}')

    if [[ "$status" == "online" ]]; then
        STATUS_RELAY="On"
    else
        STATUS_RELAY="Off"
    fi
}
