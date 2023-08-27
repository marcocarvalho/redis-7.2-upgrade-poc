#!/bin/bash

echo "old server"
redis-cli -p 6000 info keyspace
echo
echo "new server"
redis-cli -p 6001 info keyspace
