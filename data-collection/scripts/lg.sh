#!/usr/bin/env bash

for i in bigdata02 bigdata03; do
	ssh $i "java -jar /home/bigdata/module/data-collection-1.0-SNAPSHOT-jar-with-dependencies.jar $1 $2 >/dev/null 2>&1 &"
done