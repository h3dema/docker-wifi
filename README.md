# docker-wifi

This repository contains a set of scripts that, together, get a container up and running on a machine.
The dockerfile uses Ubuntu 14.04.

* The script *pidbind.sh* copies the machine wifi network interface to the container
   * Basically following [this tutorial](https://github.com/fgg89/docker-ap/wiki/Container-access-to-wireless-network-interface).
* The script run.sh runs the container and calls pidbind on the background.

# Creating and running the docker container

Use docker build to download the dockerfile and the other files from this repository.
After the cointainer is build, you should run using ''run.sh''.

```bash
$ cd /opt
$ git clone /https://github.com/h3dema/docker-wifi.git
$ cd docker-wifi
$ docker build -t wifi-container github.com/h3dema/docker-wifi
$ bash run.sh
```

''run.sh'' starts the container named *wifi-container * and redirects the USB interface to the container.
To run this script, pidbind.sh should be in the same directory.

# Running Examples

In the running container, you can create an access point or a station.
We provide two examples with the configuration files.

## creating an access point

Run:

```bash
$ hostapd /home/hostap/hostapd/hostapd.conf
```

## creating a wireless station

Run:
```bash
$ wpa_supplicant -i wlan0 -D nl80211 /home/hostap/wpa/wpa_supplicant.conf
```
