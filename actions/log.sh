#!/usr/bin/env bash

utils_log ()
{
    clear
    echo -e "\n$(text_yellow " Use Ctrl+C to return to menu")\n"
    trap : INT

    local log_file=$(ls -t "${DINPAY_DB}/logs/base/${DINPAY_NETWORK}/" | head -n 1)
    tail -fn 50 "${DINPAY_DB}/logs/base/${DINPAY_NETWORK}/${log_file}"
}
