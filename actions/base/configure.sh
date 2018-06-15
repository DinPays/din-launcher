#!/usr/bin/env bash

base_configure ()
{
    ascii

    local configured=false

    if [[ -d "$CORE_CONFIG" ]]; then
        read -p "We found an DinPay configuration, do you want to overwrite it? [y/N] : " choice

        if [[ "$choice" =~ ^(yes|y|Y) ]]; then
            __base_configure_pre

            rm -rf "$CORE_CONFIG"

            __base_configure_network

            __base_configure_database

            __base_configure_post

            configured=true
        else
            warning "Skipping configuration..."
        fi
    else
        __base_configure_pre

        __base_configure_network

        __base_configure_database

        __base_configure_post

        configured=true
    fi

    if [[ "$configured" = true ]]; then
        read -p "DinPay has been configured, would you like to start the relay? [Y/n] : " choice

        if [[ "$choice" =~ ^(yes|y|Y) ]]; then
            relay_start
        fi
    fi
}

__base_configure_pre ()
{
    relay_stop
    forger_stop
}

__base_configure_post ()
{
    database_create
}

__base_configure_network ()
{
    info "Which network would you like to configure?"

    validNetworks=("live" "devnet" "testnet")

    select opt in "${validNetworks[@]}"; do
        case "$opt" in
            "live")
                __base_configure_base "live"
                __base_configure_launcher "live"
                break
            ;;
            "devnet")
                __base_configure_base "devnet"
                __base_configure_launcher "devnet"
                break
            ;;
            "testnet")
                __base_configure_base "testnet"
                __base_configure_launcher "testnet"
                break
            ;;
            *)
                echo "Invalid option $REPLY"
            ;;
        esac
    done

    . "$launcher_config"
}

__base_configure_database ()
{
    local envFile="${CORE_DATA}/.env"

    . "$envFile"

    local currentHost="$DINPAY_DB_HOST"
    local currentUsername="$DINPAY_DB_USER"
    local currentPassword="$DINPAY_DB_PASS"
    local currentDatabase="$DINPAY_DB"

    rm "$envFile"
    touch "$envFile"

    read -p "Please enter your database host [localhost]: " inputHost
    read -p "Please enter your database host [ark]: " inputUsername
    read -p "Please enter your database host [password]: " inputPassword
    read -p "Please enter your database host [ark_devnet]: " inputDatabase

    if [[ -z "$inputHost" ]]; then
        echo "DINPAY_DB_HOST=$DINPAY_DB_HOST" >> "$envFile" 2>&1
    else
        echo "DINPAY_DB_HOST=$inputHost" >> "$envFile" 2>&1
    fi

    if [[ -z "$inputUsername" ]]; then
        echo "DINPAY_DB_USER=$DINPAY_DB_USER" >> "$envFile" 2>&1
    else
        echo "DINPAY_DB_USER=$inputUsername" >> "$envFile" 2>&1
    fi

    if [[ -z "$inputPassword" ]]; then
        echo "DINPAY_DB_PASS=$DINPAY_DB_PASS" >> "$envFile" 2>&1
    else
        echo "DINPAY_DB_PASS=$inputPassword" >> "$envFile" 2>&1
    fi

    if [[ -z "$inputDatabase" ]]; then
        echo "DINPAY_DB=$DINPAY_DB" >> "$envFile" 2>&1
    else
        echo "DINPAY_DB=$inputDatabase" >> "$envFile" 2>&1
    fi

    . "$envFile"
}

__base_configure_base ()
{
    if [[ ! -d "$CORE_DATA" ]]; then
        mkdir "$CORE_DATA"
    fi

    cp -r "${CORE_DIR}/packages/base/lib/config/$1" "$CORE_CONFIG"
}

__base_configure_launcher ()
{
    rm "$launcher_config"
    touch "$launcher_config"


    echo "DINPAY_REPO=$DINPAY_REPO" | tee -a "$launcher_log"
    echo "DINPAY_DIR=$DINPAY_DIR" | tee -a "$launcher_log"
    echo "DINPAY_DB=$DINPAY_DB" | tee -a "$launcher_log"
    echo "DINPAY_PRESET=$DINPAY_PRESET" | tee -a "$launcher_log"
    echo "DINPAY_TOKEN=$DINPAY_TOKEN" | tee -a "$launcher_log"
    echo "DINPAY_NETWORK=$1" | tee -a "$launcher_log"
    echo "EXPLORER_REPO=$EXPLORER_REPO" | tee -a "$launcher_log"
    echo "EXPLORER_DIR=$EXPLORER_DIR" | tee -a "$launcher_log"
}
