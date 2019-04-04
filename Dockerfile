# From https://hub.docker.com/r/valian/docker-python-opencv-ffmpeg
# with the version changed to 3.4.5 (rather than 3.4.2)
# 
# https://www.learnopencv.com/install-opencv3-on-ubuntu/

FROM ubuntu:16.04
LABEL maintainer "clark.dorman@nextcentury.com"
ENV OPENCV_VERSION 3.4.5

# Install all dependencies for OpenCV
RUN apt-get -y update && \
    apt-get -y install \
        python3 \
        python3-dev \
        git \
        wget \
        unzip \
        cmake \
        build-essential \
        pkg-config \
        libatlas-base-dev \
        gfortran \
        libjasper-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libv4l-dev \
    && \

# install python dependencies
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip3 install numpy \
    && \

# Install OpenCV
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip -O opencv3.zip && \
    unzip -q opencv3.zip && \
    mv /opencv-$OPENCV_VERSION /opencv && \
    rm opencv3.zip && \
    wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip -O opencv_contrib3.zip && \
    unzip -q opencv_contrib3.zip && \
    mv /opencv_contrib-$OPENCV_VERSION /opencv_contrib && \
    rm opencv_contrib3.zip 


# Prepare build
RUN    mkdir /opencv/build && cd /opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
      -D BUILD_EXAMPLES=OFF \
      -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
      -D BUILD_opencv_python3=ON \
      -D BUILD_opencv_python2=OFF \
      -D WITH_IPP=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_V4L=ON ..


# Install
RUN    cd /opencv/build && \
    make -j$(nproc) && \
    make install && \
    ldconfig


# Set correct gcc version
RUN   apt-get install -y software-properties-common && \
      add-apt-repository ppa:ubuntu-toolchain-r/test && \
      apt-get -y update
      
RUN   apt-get install -y gcc-7 g++-7 && \
      rm /usr/bin/gcc /usr/bin/g++ && \
      ln -s /usr/bin/gcc-7 /usr/bin/gcc && \
      ln -s /usr/bin/g++-7 /usr/bin/g++
    
# Clean
RUN    apt-get -y remove \
        python3-dev \
        libatlas-base-dev \
        gfortran \
        libjasper-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libv4l-dev \
    && \
    apt-get clean && \
    rm -rf /opencv /opencv_contrib /var/lib/apt/lists/*

# Define default command.
CMD ["python3 --version"]