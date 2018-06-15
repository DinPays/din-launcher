#!/usr/bin/env bash

explorer_install ()
{
    ascii

    heading "Installing DinPay Explorer..."

    sudo mkdir "$EXPLORER_DIR" | tee -a "$launcher_log"
    sudo chown "$USER":"$USER" "$EXPLORER_DIR" | tee -a "$launcher_log"

    git clone "$EXPLORER_REPO" "$EXPLORER_DIR" | tee -a "$launcher_log"
    cd "$EXPLORER_DIR"

    info "Installing dependencies..."
    yarn install | tee -a "$launcher_log"
    success "Installed dependencies!"

    info "Building..."
    yarn build:"$DINPAY_NETWORK" | tee -a "$launcher_log"
    success "Building!"

    success "Installed DinPay Explorer!"
}

explorer_uninstall ()
{
    ascii

    explorer_stop

    heading "Uninstalling DinPay Explorer..."

    sudo rm -rf "$EXPLORER_DIR"

    success "Uninstalled DinPay Explorer!"
}

explorer_update ()
{
    ascii

    cd "$EXPLORER_DIR"

    local remote_version=$(git rev-parse origin/master)
    local local_version=$(git rev-parse HEAD)

    if [[ "$remote_version" == "$local_version" ]]; then
        STATUS_EXPLORER_UPDATE="No"

        info "You already have the latest DinPay Explorer version that we support."
    else
        STATUS_EXPLORER_UPDATE="Yes"

        read -p "An update is available for DinPay Explorer, do you want to install it? [Y/n] : " choice

        if [[ "$choice" =~ ^(yes|y|Y) ]]; then
            explorer_stop

            heading "Starting Update..."
            git reset --hard | tee -a "$launcher_log"
            git pull | tee -a "$launcher_log"
            success "Update OK!"

            explorer_start

            STATUS_EXPLORER_UPDATE="No"
        fi
    fi
}

explorer_start ()
{
    ascii

    heading "Starting Explorer..."

    EXPLORER_HOST="0.0.0.0" EXPLORER_PORT=4200 pm2 start "$EXPLORER_DIR/express-server.js" --name dinpay-explorer >> "$launcher_log" 2>&1

    success "Started Explorer!"
}

explorer_restart ()
{
    ascii

    heading "Restarting Explorer..."

    pm2 restart dinpay-explorer >> "$launcher_log" 2>&1

    success "Restarted Explorer!"
}

explorer_stop ()
{
    ascii

    heading "Stopping Explorer..."

    pm2 stop dinpay-explorer >> "$launcher_log" 2>&1

    success "Stopped Explorer!"
}

explorer_logs ()
{
    clear
    echo -e "\n$(text_yellow " Use Ctrl+C to return to menu")\n"
    trap : INT

    pm2 logs dinpay-explorer
}

explorer_status ()
{
    local status=$(pm2 status 2>/dev/null | fgrep "dinpay-explorer" | awk '{print $10}')

    if [[ "$status" == "online" ]]; then
        STATUS_EXPLORER="On"
    else
        STATUS_EXPLORER="Off"
    fi
}
