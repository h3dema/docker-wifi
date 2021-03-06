FROM ubuntu:14.04

RUN apt-get update && \
    apt-get -y install apt-utils curl libssl-dev && \
    apt-get -y install build-essential make cmake git pkg-config man && \
    apt-get -y install libnl-dev libnl1

RUN apt-get -y install python python-pip
RUN apt-get -y install ca-certificates vim openssh-client openssh-server
RUN apt-get -y install net-tools iputils-ping usbutils bridge-utils iptables wireless-tools 

RUN git clone git://w1.fi/srv/git/hostap.git /home/compile
ADD hostapd/config /home/compile/hostapd/.config
RUN cd /home/compile/hostapd && \
    make && \
    make install

# compile and install iw
RUN cd /home/compile && \
    wget -c https://www.kernel.org/pub/software/network/iw/iw-4.9.tar.gz && \
    tar zxvf iw-4.9.tar.gz && \
    cd iw-4.9  && \
    make  && \
    make install

RUN apt-get install -y wpasupplicant
RUN apt-get install -y rfkill

# compile and install wpa_supplicant
#RUN cd /home/compile/wpa_supplicant && \
#    cp defconfig .config && \
#    echo "CONFIG_IEEE80211R=y" >> .config && \
#    echo "CONFIG_IEEE80211R_AP=y" >> .config && \
#    echo "CONFIG_IEEE80211N=y" >> .config && \
#    echo "CONFIG_IEEE80211AC=y" >> .config && \
#    echo "CONFIG_AP=y" >> .config && \
#    echo "CONFIG_P2P=y" >> .config && \
#    echo "CONFIG_WPS=y" >> .config && \
#    echo "CONFIG_WPS2=y" >> .config && \
#    make && \
#    make install
    
ADD hostapd/hostapd.conf /home/hostapd.conf
ADD wpa/wpa_supplicant.conf /home/wpa_supplicant.conf
