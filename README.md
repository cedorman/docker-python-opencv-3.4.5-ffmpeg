# docker-python-opencv-3.4.5-ffmpeg

Docker for opencv 3.4.5 with python and ffmpeg.  I created this
because the ones I found were opencv 3.4.2, and I needed some things
in 3.4.5.

The hard work of creating this is from
https://hub.docker.com/r/valian/docker-python-opencv-ffmpeg . I
changed the version changed to 3.4.5 (rather than 3.4.2).  In turn,
valian's docker file references:
https://www.learnopencv.com/install-opencv3-on-ubuntu/

In addition, I updated the version of gcc / g++ in the docker to 7.
