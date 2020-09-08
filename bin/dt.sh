#!/usr/bin/env bash

NODES="bigdata01 bigdata02 bigdata03"

for i in $NODES; do
  echo "-------------- $i 同步时间 ---------------"
  ssh -t $i "sudo timedatectl set-ntp false; sudo date -s $1"
done