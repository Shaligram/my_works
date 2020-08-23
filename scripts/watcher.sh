#!/bin/sh
while true; do
    eval $1  | tee -a /tmp/watcher-output.log
    sleep 60
done
