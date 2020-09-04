#!/usr/bin/env bash


ps -ef | grep org.apache.hive.service.server.HiveServer2 | grep -v grep | awk '{print $2}' | xargs kill