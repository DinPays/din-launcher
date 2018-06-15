#!/usr/bin/env bash

redis_start ()
{
    heading "Starting Redis..."

    sudo systemctl start redis-server | tee -a "$launcher_log"

    redis_status

    success "Started Redis!"
}

redis_stop ()
{
    heading "Stopping Redis..."

    sudo systemctl stop redis-server | tee -a "$launcher_log"

    redis_status

    success "Stopped Redis!"
}

redis_restart ()
{
    heading "Restarting Redis..."

    sudo systemctl restart redis-server | tee -a "$launcher_log"

    redis_status

    success "Restarted Redis!"
}

redis_install ()
{
    heading "Installing Redis..."

    yes "" | sudo add-apt-repository ppa:chris-lea/redis-server | tee -a "$launcher_log"
    sudo apt-get update | tee -a "$launcher_log"
    sudo apt-get -y install redis-server | tee -a "$launcher_log"

    sudo sed -i '/exit 0/iecho never > /sys/kernel/mm/transparent_hugepage/enabled\n' /etc/rc.local
    (echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf) | tee -a "$launcher_log"
    (echo "net.base.somaxconn=65535" | sudo tee -a /etc/sysctl.conf) | tee -a "$launcher_log"

    (echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled) | tee -a "$launcher_log"
    sudo sysctl -p /etc/sysctl.conf | tee -a "$launcher_log"

    sudo systemctl enable redis-server | tee -a "$launcher_log"

    redis_start

    success "Installed Redis!"
}

redis_status ()
{
    local status=$(sudo pgrep -x redis-server)

    if [[ -z "$status" ]]; then
        STATUS_REDIS="Off"
    else
        STATUS_REDIS="On"
    fi
}
