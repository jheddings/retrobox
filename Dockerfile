FROM debian:buster

# update system packages
RUN apt-get update && apt-get upgrade --assume-yes

# install RetroPie dependencies (and some helpful tools)
RUN apt-get install --assume-yes curl git vim tree dialog unzip

# cleanup after apt-get
RUN apt-get autoremove --assume-yes && apt-get clean

WORKDIR /opt/retropie

# install RetroPie packages
RUN git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
RUN cd RetroPie-Setup && bash retropie_packages.sh setup basic_install

# setup retropie user
RUN useradd -d /home/player1 -m player1
RUN usermod -aG adm,dialout,cdrom,audio,video,plugdev,games,users player1

#RUN apt-get install --assume-yes mesa-utils libgl1-mesa-glx
#RUN apt-get install --assume-yes x11-apps xserver-xorg-video-intel

USER player1
WORKDIR /home/player1

# setup emulator environment
ENV DISPLAY=host.docker.internal:0
ENV XDG_RUNTIME_DIR=/tmp

#ENTRYPOINT /usr/bin/emulationstation
ENTRYPOINT /bin/bash

#CMD su - player1 -c "export HOME=/home/player1;export DISPLAY=:0;/usr/bin/emulationstation"
