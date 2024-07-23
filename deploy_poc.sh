#!/bin/bash
# This Shell script will INIT a simple one node Swarm Cluster for the TRAEFIK_POC project, with the option to add more nodes.
# VARS
container_volumes_location=~/container-program-files
domain_name="rancherpoc.lan"

#Prep Env
mkdir $container_volumes_location 
chmod 755 $container_volumes_location 

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
domain_name=$domain_name container_volumes_location=$container_volumes_location docker stack deploy -c docker-compose/traefik/docker-compose.yml proxy
domain_name=$domain_name container_volumes_location=$container_volumes_location docker stack deploy -c docker-compose/wordpress/docker-compose.yml app

#Scale Stacks
docker service scale proxy_traefik=1
docker service scale app_wordpress=2
docker service scale app_db=1
docker service scale app_phpmyadmin=1

