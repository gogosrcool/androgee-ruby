#!/bin/bash

sed -i s/_RUSTIP_/$RUST_IP/ dockerfile
sed -i s/_REDIS_/$REDIS/ dockerfile
sed -i s/_DISCORDTOKEN_/$DISCORD_TOKEN/ dockerfile
sed -i s/_RUSTPASSWORD_/$RUST_PASSWORD/ dockerfile
sed -i s/_EGEEIOSERVER_/$EGEEIO_SERVER/ dockerfile
