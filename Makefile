# Makefile for idlebot

BASEDIR ?= $(PWD)
SRCDIR ?= $(BASEDIR)/src

APPNAME ?= retrobox
APPVER ?= 0.1

################################################################################
.PHONY: all

all: build

################################################################################
.PHONY: build

build:
	docker image build --tag $(APPNAME):dev $(BASEDIR)

################################################################################
.PHONY: rebuild

rebuild:
	docker image build --pull --no-cache --tag $(APPNAME):dev $(BASEDIR)

################################################################################
.PHONY: release

release: build
	docker image tag $(APPNAME):dev $(APPNAME):latest
	docker image tag $(APPNAME):latest $(APPNAME):$(APPVER)

################################################################################
.PHONY: run

run: build
	DISPLAY=:0 /usr/X11/bin/xhost + 127.0.0.1
	docker container run --rm --interactive --tty --privileged \
		--volume "$(BASEDIR)/system:/home/player1/RetroPie" \
		$(APPNAME):dev

################################################################################
.PHONY: clean

clean:
	docker image rm --force $(APPNAME):dev

################################################################################
.PHONY: clobber

clobber: clean
	docker image rm --force $(APPNAME):latest
