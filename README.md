# Docker image for the Ubiquity Unifi controller software

Unifi controller software docker image.

All persistent data is stored in `/var/lib/unifi`, which is marked as a volume.

An example `docker-compose.yml` file is included, which also exports all required ports. Using 
`docker-compose` is the recommended way of running the controller, if you have it installed,
running an instance is as simple as:

* Copying the `docker-compose.yml` file from this repository
* Running `docker-compose up` in the directory where your fresh `docker-compose.yml` file is located.

## On the ports

This image requires quite a few ports to be open in order to function properly as a controller:

* 6789/tcp
* 8843/tcp
* 8880/tcp
* 8080/tcp
* 8443/tcp
* 3478/udp
* 10001/udp

