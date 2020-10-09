#!/usr/bin/env bash

#########################################
#
# Generate event logs on multiple nodes
#
# Usage:
#      lg.sh
#
#########################################

NODES="bigdata01 bigdata02"

for i in $NODES; do
	ssh $i "cd /opt/software/data-generation/log; java -jar gmall2020-mock-log-2020-04-01.jar >/dev/null 2>&1 &"
done