# alpine-joyce

[![Docker Repository on Quay](https://quay.io/repository/mbayreut/alpine-joyce/status "Docker Repository on Quay")](https://quay.io/repository/mbayreut/alpine-joyce)


After encapsulating operating systems like MS-DOS into containers, I decided to go one step further back in history.
Now I am extending to the **ancient** [Zilog Z80 processor](https://en.wikipedia.org/wiki/Zilog_Z80).
The [Z80](https://en.wikipedia.org/wiki/Zilog_Z80) and the original [Intel 8080](https://en.wikipedia.org/wiki/Intel_8080)
were 8-Bit processors. They had 16 address pins to address RAM, which translates to 64k of addressable RAM. 

At the time Amstrad had some Z80 based machines on the market. They were called Joyce and Anne.
So why not put them into a container.

## Purpose

To allow old CP/M applications to run (for nostalgia reasons) and to ensure that old operating systems
can participate in CI/CD scenarios. In this project I am not using qemu but go for the very nice
Amstrad Joyce / Anne emulator by John Elliot. With that it is possible to encapsulate and automate workloads
that run on the CP/M operating system which dates back to the 1970-ies.

## Concept

- OCI container image based on Alpine Linux
- two step container build, with a builder step compiling of Joyce for Unix and the actual packaging step
- some helper tools and scripts

## Build

    podman build .
or

    docker build .

Then tag the resulting image as you like

    podman tag <image hash> alpine-joyce:1.0
or

    docker tag <image hash> alpine-joyce:1.0

## Usage

To prepare your working CP/M, you need some boot floppy images to bootstrap your environment.
Place them in a place that you will then volume mount into the container.

Example:

    podman run -it --rm \
    -p 5901:5901 \
    -v /host-machine/some-floppy-path:/tmp/floppies \
    alpine-joyce:1.0

Some wrapper shell scripts are included. They illustrate how to work with the container.
The GUI of the image / the screen is exposed via VNC on display :1 (= port 5901).
