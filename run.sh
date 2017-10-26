#!/bin/bash

docker build . -t discord

git clone 
git clone https://github.com/egee-irl/andro-wrcon.git
cd andro-wrcon
docker build . -t wrcon

cd .. && docker-compose up