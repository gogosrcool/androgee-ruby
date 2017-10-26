#!/bin/bash

docker build . -t discord

git clone 
mkdir wrcon && cd wrcon
git clone https://github.com/egee-irl/andro-wrcon.git
docker build . -t wrcon

cd .. && docker-compose up