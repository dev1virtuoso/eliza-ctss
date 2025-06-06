## Prerequisites

Like the main code, you will need a Unix like environment but one that
also includes the `expect` package. It may not be included by default.
This has been tested on

* Debian/Ubuntu/Mint

but may work on other Unix/Linux flavours.

## Docker start

If you'd like to run Eliza without the full process, e.g. on a server or for an unattended demo,
then this Dockerfile will create an image which contains all the software and runs CTSS. You can either telnet in
normally, or run the `telnet2docker.sh` scripts which does all the building and configuration for you!


* Install Docker according to the guidelines for your host OS
* Build an image with `docker build -t eliza .`
* Create a container from that image with `docker run -i -t -p 7094:7094 eliza`
    This will start, allowing you to connect to CTSS via port 7094 from another shell on the host machine
* Connect to this container from your host machine with `./telnet2docker.sh` (or use the manual steps in the main README.md in the root of this repo)
* Once you've finished, simply stop the container with `Ctrl+C`, `q` and `return` Because
    it's in a container you don't need the clean closedown sequence.
* Once you're bored, reclaim some disk space and remove the image with `docker image rm eliza`

## Sources and licences

The Dockerfile and telnet script has been open sourced under a [Creative Commons CC0 public domain license](https://creativecommons.org/publicdomain/zero/1.0/). 

