#!/bin/bash

read -p "Delete existent containers ? (y/N): " deletecontainers
read -p "Delete existent volumes ? (y/N): " deletevolumes
read -p "Delete existent images ? (y/N): " deleteimages
read -p "Docker prune ? (y/N): " dockerprune

if [[ "$deletecontainers" = "y" ]]; then
    echo "Delete existent containers"
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
fi

if [[ "$deletevolumes" = "y" ]]; then
    echo "Delete existent volumes"
    docker volume rm $(docker volume ls -q)
    rm -rf ./volumes/*
fi

if [[ "$deleteimages" = "y" ]]; then
    echo "Delete existent images"
    docker rmi $(docker images -a -q)
fi

if [[ "$dockerprune" = "y" ]]; then
    echo "Docker prune"
    docker system prune
fi

docker-compose up -d

## Fix the troubleshooting : Error: Unable to open log file xxxx for writing.
sudo chmod -R 777 ./volumes/