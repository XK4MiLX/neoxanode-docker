#!/usr/bin/env bash

function get_ip() {
    WANIP=$(curl --silent -m 15 https://api4.my-ip.io/ip | tr -dc '[:alnum:].')
    if [[ "$WANIP" == "" || "$WANIP" = *htmlhead* ]]; then
        WANIP=$(curl --silent -m 15 https://checkip.amazonaws.com | tr -dc '[:alnum:].')    
    fi  
    if [[ "$WANIP" == "" || "$WANIP" = *htmlhead* ]]; then
        WANIP=$(curl --silent -m 15 https://api.ipify.org | tr -dc '[:alnum:].')
    fi
}

get_ip
RPCUSER=$(pwgen -1 8 -n)
PASSWORD=$(pwgen -1 20 -n)

if [[ -f /root/.neoxacore/neoxa.conf ]]; then
  rm  /root/.neoxacore/neoxa.conf
fi

touch /root/.neoxacore/neoxa.conf
cat << EOF > /root/.neoxacore/neoxa.conf
rpcuser=$RPCUSER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
externalip=$WANIP:8788
smartnodeblsprivkey=$KEY
EOF

while true; do
 if [[ $(pgrep neoxad) == "" ]]; then 
   neoxad -daemon
 fi
sleep 120
done
