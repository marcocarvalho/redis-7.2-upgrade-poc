#!/bin/bash

echo "pause the old server for 5 minutes"
echo "redis-cli -p 6000 CLIENT PAUSE 300000"
redis-cli -p 6000 CLIENT PAUSE 300000

echo
echo "check the new server"
read -p "Press ENTER to stop the replicaof the old server"
echo "redis-cli -p 6001 replicaof no one"
redis-cli -p 6001 replicaof no one

echo
echo "Now, kill the old server, and enjoy"