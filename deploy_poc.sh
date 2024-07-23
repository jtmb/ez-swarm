#!/bin/bash

env_file="DOMAIN_NAME=rancherpoc.lan"

# This Shell will INIT a simple one node Swarm Cluster for the TRAEFIK_POC project, with the option to add more nodes

# Init a new swarm with default parameters
docker swarm init

# Create overlay network for secure communication between containers in this swarm
docker network create --scope=swarm --attachable -d overlay container-swarm-network 

# Create overlay network for secure communication between databases in this swarm
docker network create --scope=swarm --attachable -d overlay db-network

# Export vars
swarm_join_command=$(docker swarm join-token manager) >/dev/null 2>&1
echo $swarm_join_command

# Deploy Stacks
docker stack deploy -c docker-compose/traefik/docker-compose.yml proxy
docker stack deploy -c docker-compose/wordpress/docker-compose.yml app

#Scale Stacks
docker service scale proxy_traefik=1
docker service scale app_wordpress=2
docker service scale app_db=1
docker service scale app_phpmyadmin=1

