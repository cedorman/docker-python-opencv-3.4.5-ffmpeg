#!/bin/bash

export VITO_HOME=/home/HQ/cdorman/vito/VITO

docker run -it -v $VITO_HOME:/vito cedorman/docker-python-opencv-3.4.5-ffmpeg:android /bin/bash

