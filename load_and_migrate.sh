#!/bin/bash

redis-cli -p 6000 flushall

# Load the data
ruby generate_data.rb | redis-cli -p 6000 --pipe

# Show how much keys we created and the memory usage
redis-cli -p 6000 info | grep -e 'db0:keys=' -e 'used_memory_human'


# make the

redis-cli -p 6001 replicaof redis5 6379

watch --differences --interval 5 ./check_replication.sh

# wait for replication. Keys should be equal in all databases
# # Keyspace
# db0:keys=9971,expires=0,avg_ttl=0
# Keyspace
# db0:keys=9971,expires=0,avg_ttl=0

echo "Make new server accept writes"
redis-cli -p 6001 CONFIG SET slave-read-only no

echo
echo "-> deploy the app pointing to the new server"
echo "-> redis-cli -p 6000 monitor # until you see no more usage and connections on old server"

redis-cli -p 6000 monitor

echo "pause the old server for 5 minutes"
redis-cli -p 6000 CLIENT PAUSE 300000

echo
echo "check the new server"
read -p "Press ENTER to stop the replicaof the old server"
redis-cli -p 6001 replicaof no one

echo
echo "Now, kill the old server, and enjoy"
