#!/bin/bash

docker build . -t discord

git clone 
git clone https://github.com/egee-irl/andro-wrcon.git
cd andro-wrcon
sed -i s/localhost/redis/g main.coffee
docker build . -t wrcon

cd .. && docker-compose up