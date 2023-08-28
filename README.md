# Redis migration from 5.0.5 to 7.2 - POC

This POC assumes you already have docker and ruby instaled to run the scripts.

## booting

```sh
docker-compose up
```

## Alter the generate_data.rb script (optional)

`generate_data.rb` will create about 1.5GB of data among 4 basic redis data types. If you wanna more data, alter the script and change the `@num_keys` variable or the `@value_size` or both and run:

To run the script alone run:

```shell
ruby generate_data.rb | redis-cli -p 6000 --pipe
```

Some errors will happen on HSET command, it's safe to ignore.

## Running the load_and_migrate.sh script

Run the script until the last step of monitor the connections

```
./load_and_migrate.sh
```

## Break the replication and shutdown the old server

```
shutdown_old_server.sh
```

# Documentation

- Upgrading or restarting a Redis instance without downtime:
https://redis.io/docs/management/admin/

