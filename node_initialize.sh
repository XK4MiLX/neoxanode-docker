#!/usr/bin/env bash

function get_ip() {

    WANIP=$(curl --silent -m 15 https://api4.my-ip.io/ip | tr -dc '[:alnum:].')

    if [[ "$WANIP" == "" ]]; then
      WANIP=$(curl --silent -m 15 https://checkip.amazonaws.com | tr -dc '[:alnum:].')
    fi

    if [[ "$WANIP" == "" ]]; then
      WANIP=$(curl --silent -m 15 https://api.ipify.org | tr -dc '[:alnum:].')
    fi
}

get_ip
RPCUSER=$(pwgen -1 8 -n)
PASSWORD=$(pwgen -1 20 -n)

if [[ -f /root/.firo/firo.conf ]]; then
  rm  /root/.firo/firo.conf
fi

touch /root/.firo/firo.conf
cat << EOF > /root/.firo/firo.conf
rpcuser=$RPCUSER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
txindex=1
znode=1
externalip=$WANIP:8168
znodeblsprivkey=$KEY
EOF

while true; do
firod -daemon
sleep 10000
done
