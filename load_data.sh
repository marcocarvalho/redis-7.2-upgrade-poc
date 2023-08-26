#!/bin/bash

redis-cli -p 6000 flushall
ruby generate_data.rb | redis-cli -p 6000 --pipe