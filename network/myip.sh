#!/usr/bin/env bash

ADAPTER=$(ip route get 1.1.1.1 | awk 'NR==1{print $5}')
GATEWAY=$(ip route get 1.1.1.1 | awk 'NR==1{print $3}')

LOCAL_IP=$(ip address show dev ${ADAPTER} | grep -w inet | awk '{print $2}')
PUBLIC_IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com)
echo Local IP: $LOCAL_IP
echo Gateway: $GATEWAY
echo Public IP: $PUBLIC_IP
