#!/bin/bash
# This Shell script will INIT a simple one node Swarm Cluster for the TRAEFIK_POC project, with the option to add more nodes.

# VARS
container_volumes_location=~/container-program-files
domain_name="traefikpoc.lan"
ip_address=192.168.0.6

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

# Source stack locations into a list
docker_stacks=(
    "docker-compose/traefik/docker-compose.yml proxy"
    "docker-compose/pihole/docker-compose.yml dns"
    "docker-compose/wordpress/docker-compose.yml app"
) 

for entry in "${docker_stacks[@]}"; do
    # Split the entry into file and stack name
    IFS=' ' read -r compose_file stack_name <<< "$entry"
    
    # Deploy the Docker stack
    domain_name=$domain_name container_volumes_location=$container_volumes_location docker stack deploy -c "$compose_file" "$stack_name"
done

# Scale Services
services_to_scale=(
    "dns_pihole=1"
    "app_wordpress=1"
    "app_db=1"
    "app_phpmyadmin=1"
    "proxy_traefik=1"
) 

for entry in "${services_to_scale[@]}"; do
    # Scale the service
    docker service scale "$entry"
done


echo "Services have been scaled."

# Set DNS
rm -f $container_volumes_location/pihole/custom.list >/dev/null 2>&1
custom_list_file="${container_volumes_location}/pihole/custom.list"

# Ensure the custom.list file exists
touch "$custom_list_file"

# List of DNS entries
entries=(
    "$ip_address $domain_name"
    "$ip_address whoami.$domain_name"
    "$ip_address wordpress.$domain_name"
    "$ip_address proxy.$domain_name"
    "$ip_address dns.$domain_name"
    "$ip_address phpmyadmin.$domain_name"
)

# Add entries to custom.list
for entry in "${entries[@]}"; do
    grep -qxF "$entry" "$custom_list_file" || echo "$entry" >> "$custom_list_file"
done

docker service update dns_pihole --force
echo "DNS entries have been updated."

