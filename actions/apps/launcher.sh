#!/usr/bin/env bash

launcher_configure_repo ()
{
    info "Current: $DINPAY_REPO"
    read -p "Please enter the DinPay repository you would like to use: " choice

    __launcher_configure "$choice" "$DINPAY_DIR" "$DINPAY_DB" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$EXPLORER_DIR"

    if [[ -d "$DINPAY_DIR" ]]; then
        warning "DinPay Core will be pointed to ${DINPAY_REPO}. This will restart your node."

        press_to_continue

        relay_stop

        cd "$DINPAY_DIR"
        git reset --hard | tee -a "$launcher_log"
        git remote set-url origin "$DINPAY_REPO" | tee -a "$launcher_log"
        git pull | tee -a "$launcher_log"

        relay_start
    fi
}

launcher_configure_base_directory ()
{
    local current="$DINPAY_DIR"

    info "Current: $DINPAY_DIR"
    read -p "Please enter the DinPay directory you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$choice" "$DINPAY_DB" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$EXPLORER_DIR"

    if [[ -d "$DINPAY_DIR" ]]; then
        warning "DinPay Core will be stopped and moved to ${DINPAY_DIR}. This will restart your node."

        press_to_continue

        forger_stop
        relay_stop

        mv "$current" "$DINPAY_DIR"

        relay_start
    fi
}

launcher_configure_data_directory ()
{
    info "Current: $DINPAY_DB"
    read -p "Please enter the DinPay data directory you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$choice" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$EXPLORER_DIR"
}

launcher_configure_config_directory ()
{
    info "Current: $DINPAY_PRESET"
    read -p "Please enter the DinPay config directory you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$DINPAY_DB" "$choice" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$EXPLORER_DIR"
}

launcher_configure_token ()
{
    info "Current: $DINPAY_TOKEN"
    read -p "Please enter the token you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$DINPAY_DB" "$DINPAY_PRESET" "$choice" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$EXPLORER_DIR"
}

launcher_configure_token_network ()
{
    info "Current: $DINPAY_NETWORK"
    read -p "Please enter the network you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$DINPAY_DB" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$choice" "$EXPLORER_REPO" "$EXPLORER_DIR"
}

launcher_configure_explorer_repo ()
{
    info "Current: $EXPLORER_REPO"
    read -p "Please enter the explorer repository you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$DINPAY_DB" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$choice" "$EXPLORER_DIR"

    if [[ -d "$EXPLORER_DIR" ]]; then
        warning "DinPay Explorer will be pointed to ${EXPLORER_REPO}. This will restart your explorer."

        press_to_continue

        explorer_stop

        cd "$EXPLORER_DIR"
        git reset --hard | tee -a "$launcher_log"
        git remote set-url origin "$EXPLORER_REPO" | tee -a "$launcher_log"
        git pull | tee -a "$launcher_log"

        explorer_start
    fi
}

launcher_configure_explorer_directory ()
{
    local current="$EXPLORER_DIR"

    info "Current: $EXPLORER_DIR"
    read -p "Please enter the explorer directory you would like to use: " choice

    __launcher_configure "$DINPAY_REPO" "$DINPAY_DIR" "$DINPAY_DB" "$DINPAY_PRESET" "$DINPAY_TOKEN" "$DINPAY_NETWORK" "$EXPLORER_REPO" "$choice"

    if [[ -d "$EXPLORER_DIR" ]]; then
        warning "DinPay Explorer will be stopped and moved to ${EXPLORER_DIR}. This will restart your explorer."

        press_to_continue

        explorer_stop

        mv "$current" "$EXPLORER_DIR"

        explorer_start
    fi
}

__launcher_configure ()
{
    rm "$launcher_config"
    touch "$launcher_config"

    echo "DINPAY_REPO=$1" >> "$launcher_config"
    echo "DINPAY_DIR=$2" >> "$launcher_config"
    echo "DINPAY_DB=$3" >> "$launcher_config"
    echo "DINPAY_PRESET=$4" >> "$launcher_config"
    echo "DINPAY_TOKEN=$5" >> "$launcher_config"
    echo "DINPAY_NETWORK=$6" >> "$launcher_config"
    echo "EXPLORER_REPO=$7" >> "$launcher_config"
    echo "EXPLORER_DIR=$8" >> "$launcher_config"

    . "$launcher_config"

    success "The launcher configuration has been updated."
}
