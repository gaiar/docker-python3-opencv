FROM python:3.7
LABEL maintainer="gaiar@baimuratov.ru"

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        build-essential \
        libjpeg-dev libtiff5-dev libjasper-dev libpng-dev \
        libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
        libfontconfig1-dev libcairo2-dev \
        libgdk-pixbuf2.0-dev libpango1.0-dev \
        libgtk2.0-dev libgtk-3-dev \
        libatlas-base-dev gfortran \
        libhdf5-dev libhdf5-serial-dev libhdf5-103 \
        libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install numpy

WORKDIR /
ENV OPENCV_VERSION="4.1.1"
RUN wget -O opencv-${OPENCV_VERSION}.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& wget -O opencv_contrib-${OPENCV_VERSION}.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&& unzip opencv-${OPENCV_VERSION}.zip \
&& unzip opencv_contrib-${OPENCV_VERSION}.zip \
&& mv opencv-4.1.1 opencv \
&& mv opencv_contrib-4.1.1 opencv_contrib \
&& mkdir /opencv/cmake_binary \
&& cd /opencv/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
  -DENABLE_NEON=ON \
  -DENABLE_VFPV3=ON \
  -DOPENCV_ENABLE_NONFREE=ON \
  -DCMAKE_SHARED_LINKER_FLAGS=-latomic \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.7 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.7) \
  -DPYTHON_INCLUDE_DIR=$(python3.7 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make install \
&& rm /opencv-${OPENCV_VERSION}.zip \
&& rm /opencv_contrib-${OPENCV_VERSION}.zip \
&& rm -r /opencv \
&& rm -r /opencv_contrib
RUN ln -s \
  /usr/local/python/cv2/python-3.7/cv2.cpython-37m-aarch64-linux-gnu.so \
  /usr/local/lib/python3.7/site-packages/cv2.so
