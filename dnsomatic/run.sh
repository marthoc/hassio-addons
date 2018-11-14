#!/bin/sh

# Credit to https://www.linuxjournal.com/content/validating-ip-address-bash-script for valid_ip function

CONFIG_PATH=/data/options.json

HOSTNAME=$(jq --raw-output ".hostname" $CONFIG_PATH)
USERNAME=$(jq --raw-output ".username" $CONFIG_PATH)
PASSWORD=$(jq --raw-output ".password" $CONFIG_PATH)
INTERVAL=$(jq --raw-output ".update_interval" $CONFIG_PATH)

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

while true
do
    IP=$(curl -s http://myip.dnsomatic.com/)

    if valid_ip $IP; then

        echo "Attempting to update $HOSTNAME with $IP..."
        curl -s -u "$USERNAME:$PASSWORD" "https://updates.dnsomatic.com/nic/update?myip=$IP&hostname=$HOSTNAME&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG"
        
        rc=$?
        if [[ $rc != 0 ]]; then
            
            echo "Error updating DNS-O-Matic with IP $IP..."
        
        fi

    else

        echo "Error getting current IP address, not attempting update..."
    
    fi

    echo ""
    echo "Waiting $INTERVAL seconds before next update..."
    sleep $INTERVAL
done
