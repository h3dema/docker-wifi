FROM ubuntu:14.04

RUN apt-get update && \
    apt-get -qy install apt-utils curl libssl-dev && \
    apt-get -y build-essential make cmake git pkg-config man && \
    apt-get -y libnl-dev libnl1 && \
    apt-get -y python python-pip && \
    apt-get -y ca-certificates net-tools iputils-ping usbutils && \
    apt-get -y vim openssh-client openssh-server && \
    apt-get -y bridge-utils iptables wireless-tools wpasupplicant

RUN git clone git://w1.fi/srv/git/hostap.git /home/hostap
ADD hostapd/config /home/hostap/hostapd/.config
RUN cd /home/hostap/hostapd && make && make install

# compile and install iw
RUN cd /home/hostap && \
    wget -c https://www.kernel.org/pub/software/network/iw/iw-4.9.tar.gz && \
    tar zxvf iw-4.9.tar.gz && \
    cd iw-4.9  && \
    make  && \
    make install

# TODO: compile and install wpa_supplicant


ADD hostapd/hostapd.conf /home/hostap/hostapd.conf
ADD wpa/wpa_supplicant.conf /home/hostap/wpa_supplicant.conf
