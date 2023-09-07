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

if [[ -f /root/.neoxa/neoxa.conf ]]; then
  rm  /root/.neoxa/neoxa.conf
fi

touch /root/.neoxa/neoxa.conf
cat << EOF > /root/.neoxa/neoxa.conf
rpcuser=$RPCUSER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
txindex=1
znode=1
externalip=$WANIP:8788
znodeblsprivkey=$KEY
EOF

while true; do
 if [[ $(pgrep firod) == "" ]]; then 
   firod -daemon
 fi
sleep 120
done
