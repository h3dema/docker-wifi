#!/bin/bash

DOCKER=`docker ps -f name=wifi-container | wc -l`

# checks if the container is already running
if (( $DOCKER == 1 ))
then
    # run the container
    docker run -dit --device /dev/rfkill:/dev/rfkill --net=bridge --cap-add=NET_ADMIN --cap-add=SYS_MODULE --name=wifi-container wifi-container
    # redirects USB wireless phy devices to the container
    /opt/docker-wifi/pidbind.sh &
fi

docker exec -ti wifi-container bash
