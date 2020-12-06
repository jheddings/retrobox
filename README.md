# retrobox

Running RetroPie in a Docker container, mostly for poking around when my Raspberry Pi is
not available - usually being used to play other games.

This is still a work in progress!  There are a lot of things that don't work quite right
if at all.

## Installation & Setup

Build the container using `make` (or `make rebuild`).  This will compile many files and
takes a while to complete (up to an hour).

Launch the container using `make run`.

Complete the RetroPie installation inside the container using the setup menu:
`sudo bash /opt/retropie/RetroPie-Setup/retropie_setup.sh`

Perform the Basic Install.

## Dependencies

You'll need XQuartz to run this on macOS.  Specifically, version 2.7.8 has been tested.
Other versions of XQuartz may work, but some have known issues with OpenGL.

Make sure that XQuartz is configured to allow network connections.

## Known Issues

Seems to be an issue with OpenGL on macOS that causes Emulation Station to flicker
endlessly.  glxgears seems frozen.  Other X-apps (like xeyes) are okay.

During automated package installation, the following error appears:

    stat: cannot stat '/proc/1/root/.': Permission denied

Performance is _really_ slow.  Make sure you have a snappy system.

Need to figure out the right order for container creation and system folder content.

Would prefer to move the `retropiemenu` folder into the mapped system folder.

