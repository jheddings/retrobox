FROM debian:buster

# this is the common root directory referenced by RetroPie
WORKDIR /opt/retropie

# update system packages
RUN apt-get update && apt-get upgrade --assume-yes

# install RetroPie setup dependencies and some helpful tools for the container.
# note that we don't install _every_ dependency here, since the setup script will
# handle the rest...  these are mostly required for setup to run properly and/or
# save a little time in future steps.

RUN apt-get install --assume-yes \
  git vim tree dialog unzip p7zip sudo curl wget systemd \
  lsb-release build-essential xmlstarlet python3-pyudev mame-tools \
  libudev-dev libavcodec-dev libavformat-dev libavdevice-dev

# we will install RetroPie packages using RetroPie-Setup
RUN git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git setup
WORKDIR /opt/retropie/setup
COPY etc/setup_datadir.patch .
RUN patch -p1 < setup_datadir.patch

# setup retropie user here so we can do the setup using sudo...
RUN useradd -d /home/player1 -G sudo -m player1
RUN usermod -aG adm,dialout,cdrom,audio,video,plugdev,games,users player1
COPY etc/sudo_player1 /etc/sudoers.d/player1

# RetroPie needs to be installed using sudo by target user
# XXX is there a cleaner way to do this w/out switching back and forth btwn player1 & root?
USER player1
RUN sudo bash retropie_packages.sh setup basic_install

# TODO install optional packages
# scraper
# reicast

# finish system setup as root...
USER root

# these can be helpful tools for troubleshooting - installed
# after retropie to avoid recompiling if we change things...
#RUN apt-get install --assume-yes sudo x11-apps glxgears

# cleanup after apt-get operations
RUN apt-get autoremove --assume-yes && apt-get clean

# set up the user content folder
USER player1
WORKDIR /home/player1

# setup emulator environment
ENV DISPLAY=host.docker.internal:0
ENV XDG_RUNTIME_DIR=/tmp

#ENTRYPOINT /usr/bin/emulationstation
ENTRYPOINT /bin/bash
