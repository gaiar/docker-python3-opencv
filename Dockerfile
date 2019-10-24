FROM arm64v8/debian:buster
LABEL maintainer="gaiar@baimuratov.ru"

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get install -yq --no-install-recommends apt-utils
RUN apt-get install -yq --no-install-recommends \
	python3-dev \
	python3.7 \
	python3-pip \
	python3-setuptools \
	libssl-dev \
	libffi-dev \
	libblas3 \
	liblapack3 \
	cython3 \
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
        libjpeg-dev \
	libtiff5-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
        libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libv4l-dev \
	libxvidcore-dev \
	libx264-dev \
        libfontconfig1-dev \
	libcairo2-dev \
        libgdk-pixbuf2.0-dev \
	libpango1.0-dev \
        libgtk2.0-dev \
	libgtk-3-dev \
	libblis-dev \
	libopenblas-dev \
        libatlas-base-dev \
	gfortran \
        libhdf5-dev \
	libhdf5-serial-dev \
	libhdf5-103 \
        libqtgui4 \
	libqtwebkit4 \
	libqt4-test \
	python3-pyqt5 \
    && rm -rf /var/lib/apt/lists/*

#RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#    locale-gen

RUN wget -O numpy.zip https://github.com/numpy/numpy/releases/download/v1.17.2/numpy-1.17.2.zip \
	&& unzip numpy.zip \
	&& mv numpy-1.17.2 numpy \
	&& cd /numpy \
	&& NPY_NUM_BUILD_JOBS=6 python3 setup.py install 

#RUN pip install numpy

WORKDIR /
ENV OPENCV_VERSION="4.1.2"
RUN wget -O opencv-${OPENCV_VERSION}.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& wget -O opencv_contrib-${OPENCV_VERSION}.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&& unzip opencv-${OPENCV_VERSION}.zip \
&& unzip opencv_contrib-${OPENCV_VERSION}.zip \
&& mv opencv-${OPENCV_VERSION} opencv \
&& mv opencv_contrib-${OPENCV_VERSION} opencv_contrib \
&& mkdir /opencv/cmake_binary \
&& cd /opencv/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
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
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DPYTHON_EXECUTABLE=$(which python3.7) \
  -DPYTHON_INCLUDE_DIR=$(python3.7 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make -j$(nproc) install \
&& rm /opencv-${OPENCV_VERSION}.zip \
&& rm /opencv_contrib-${OPENCV_VERSION}.zip \
&& rm -r /opencv \
&& rm -r /opencv_contrib
RUN ln -s \ 
	/usr/local/lib/python3.7/dist-packages/cv2/python-3.7/cv2.cpython-37m-aarch64-linux-gnu.so \
	/usr/local/lib/python3.7/dist-packages/cv2/python-3.7/cv2.so
