#!/bin/bash

redis-cli -p 6000 flushall

# Load the data
echo "Loading data"
echo "ruby generate_data.rb | redis-cli -p 6000 --pipe"
ruby generate_data.rb | redis-cli -p 6000 --pipe

# Show how much keys we created and the memory usage
echo "redis-cli -p 6000 info | grep -e 'db0:keys=' -e 'used_memory_human'"
redis-cli -p 6000 info | grep -e 'db0:keys=' -e 'used_memory_human'


# make the

echo "Connect servers to replicate"
echo "redis-cli -p 6001 replicaof redis5 6379"
redis-cli -p 6001 replicaof redis5 6379

watch --differences --interval 5 ./check_replication.sh

# wait for replication. Keys should be equal in all databases
# # Keyspace
# db0:keys=9971,expires=0,avg_ttl=0
# Keyspace
# db0:keys=9971,expires=0,avg_ttl=0

echo
echo "Make new server accept writes"
echo "redis-cli -p 6001 CONFIG SET slave-read-only no"
redis-cli -p 6001 CONFIG SET slave-read-only no

echo
echo "-> deploy the app pointing to the new server"
echo
echo "redis-cli -p 6000 monitor"
redis-cli -p 6000 monitor
