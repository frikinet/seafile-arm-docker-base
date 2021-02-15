# Seafile Docker image for ARM

## About

Currently SQLITE only.

This project uses [a forked version]( https://github.com/frikinet/seafile-rpi ) of the [Seafile for Raspberry PI]( https://github.com/haiwen/seafile-rpi ) build script.

## Build

Update the `USER` variable in the `build-image.sh` script, then run it.

Script usage:

```
./build-image.sh
    -t              Add a tag. Could be used several times.
    -l <platform>   Load to the local images. One <platform> at time only.
    -p              Push the image(s) to the remote registry. Incompatible with -p
```

Example:

```
./build-image.sh -t 8.0.3 -t latest -l arm/v7
```

##  Run

Installation:

```
docker run -it --rm -v /path/to/seafile/data/:/shared frikinet/seafile-arm /docker_entrypoint.sh init
```

Run:

```
docker run -v /path/to/seafile/data/:/shared frikinet/seafile-arm
```

>Note: You may have to expose some ports with `-p` depending on what you're trying to achieve.
