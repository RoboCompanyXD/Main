#!/bin/bash

# Instalar OpenCV 4.2.0

OPENCV_VERSION='4.2.0'

sudo apt-get -y update

sudo apt-get install -y build-essential cmake
sudo apt-get install -y qt5-default libvtk6-dev
sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev \

                        libopenexr-dev libgdal-dev

sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \

                        libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \

                        libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

sudo apt-get install -y libfontconfig1-dev libcairo2-dev
sudo apt-get install -y libgdk-pixbuf2.0-dev libpango1.0-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libtbb-dev libeigen3-dev

sudo apt-get install -y libatlas-base-dev gfortran

sudo apt-get install -y libhdf5-dev libhdf5-serial-dev libhdf5-103
sudo apt-get install -y libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5

sudo apt-get install -y python-dev  python-tk  pylint  python-numpy  \

                        python3-dev python3-tk pylint3 python3-numpy flake8

sudo apt-get install -y qt5-default

wget https://bootstrap.pypa.io/get-pip.py

sudo python get-pip.py
sudo python3 get-pip.py
sudo rm -rf ~/.cache/pip

sudo echo "# virtualenv and virtualenvwrapper" >> ~/.bashrc
sudo echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
sudo echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
sudo echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

source ~/.bashrc

sudo pip install virtualenv virtualenvwrapper

pip install "picamera[array]"

pip install numpy

sudo apt-get install -y ant default-jdk

sudo apt-get install -y doxygen unzip wget

wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip

unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip

mv opencv-${OPENCV_VERSION} OpenCV

wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip

unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip

mv opencv_contrib-${OPENCV_VERSION} opencv_contrib

mv opencv_contrib OpenCV

cd OpenCV && mkdir build && cd build

cmake \
-D WITH_OPENGL=ON \
-D FORCE_VTK=ON \
-D WITH_TBB=ON \
-D WITH_GDAL=ON \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D WITH_XINE=ON \
-D ENABLE_PRECOMPILED_HEADERS=OFF \
-D PYTHON_EXECUTABLE=/usr/bin/python3.7 \
-D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3.7 \
-D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=/usr/lib/python3/dist-packages/numpy/core/include \
-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
-D BUILD_TESTS=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D CMAKE_SHARED_LINKER_FLAGS=-latomic \
-D OPENCV_GENERATE_PKGCONFIG=YES \
-D CMAKE_INSTALL_PREFIX=/usr/local \
..

echo "Comprueba que está todo correcto, pulsa a para abortar o cualquier tecla para continuar: "

read -rsn1 input
if [ "$input" = "a" ]; then
    echo "Abortando..."
    exit 1
fi

make -j6

sudo make install

sudo ldconfig

# Instalar Bluez

BLUEZ_VERSION='5.53'

sudo apt-get install -y libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev

wget http://www.kernel.org/pub/linux/bluetooth/bluez-${BLUEZ_VERSION}.tar.xz
tar xvf bluez-${BLUEZ_VERSION}.tar.xz && rm bluez-${BLUEZ_VERSION}.tar.xz

mv bluez-${BLUEZ_VERSION} bluez

cd bluez

./configure --enable-library

make -j6

sudo make install

sudo sed -i "s@ExecStart=/usr/local/libexec/bluetooth/bluetoothd@ExecStart=/usr/local/libexec/bluetooth/bluetoothd --experimental --noplugin=sap@" /lib/systemd/system/bluetooth.service

pip3 install pybluez
pip install pybluez

sudo systemctl daemon-reload
sudo service bluetooth restart

systemctl status bluetooth

# Instalar libreria de bitalino

pip3 install bitalino
pip install bitalino

# Instalar NoIp

wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz
tar vzxf noip-duc-linux.tar.gz
rm noip-duc-linux.tar.gz
mv noip-* noip
cd noip
sudo make

echo 'noconfiginstall: ${TGT}' >> ./Makefile
echo -e '\tif [ ! -d ${BINDIR} ]; then mkdir -p ${BINDIR};fi' >> ./Makefile
echo -e '\tif [ ! -d ${CONFDIR} ]; then mkdir -p ${CONFDIR};fi' >> ./Makefile
echo -e '\tcp ${TGT} ${BINDIR}/${TGT}' >> ./Makefile

sudo make noconfiginstall
sudo echo "port 22" >> /etc/ssh/sshd_config
sudo echo "port 12366" >> /etc/ssh/sshd_config
sudo systemctl restart ssh
