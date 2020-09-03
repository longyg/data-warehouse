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
	ssh $i "java -jar /opt/software/log-generator/log-generator-1.0-SNAPSHOT-jar-with-dependencies.jar $1 $2 >/dev/null 2>&1 &"
done