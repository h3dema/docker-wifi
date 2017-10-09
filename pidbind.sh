#!/bin/bash
#If positive, moves the interface to the namespace of the container

#Checks if the container has already loaded. 
LINES=`docker ps -a | grep wifi-container | grep Up | wc -l`
while [[ $LINES != 1 ]];
do
	LINES=`docker ps -a | grep wifi-container | grep Up | wc -l`
done

# network name space directory
NETNS=`ls /var/run | grep netns | wc -l`
# create if doesn't exist
if [ $NETNS == 0 ]
then
    sudo mkdir /var/run/netns
fi

#Gets the PID of the running container
# PID=$(docker inspect -f '{{.State.Pid}}' wifi-container)
PID=`ps axf | grep wifi-container | grep -v grep | grep docker | awk '{print $1}'`

#Make a link for the interface inside the process PID
sudo ln -s /proc/$PID/ns/net /var/run/netns/$PID

INTF_NAME="wlan0"
INTF_PHY="phy0"

# Move the interface to the process' namespace
# NOTE: the following command only works if the interface driver is installed in the physical computer
#       otherwise **iw** don't know about the interface
sudo iw phy $INTF_PHY set netns $PID

#Bring up the interface inside the container
sudo ip netns exec $PID ip link set $INTF_NAME up

#After these steps, the interface will be shown inside the container.
#Run 'ifconfig' (inside the container) and you will see INTF_NAME, with no IP address set, but up and running	
