#!/bin/sh
docker run --rm -it -e SUPER_USER=admin -e AUTO_SIGNUP=true -p 3735:3735 victorrds/etesync
