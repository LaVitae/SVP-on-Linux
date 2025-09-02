#!/bin/bash
# Copyright (c) 2025 LaVitae
# GNU General Public License v3.0 or later (see https://www.gnu.org/licenses/gpl-3.0.txt)

# variables
GREETINGS="Hi! This script will install dependencies for SVP4 on Ubuntu-based distros."
ERROR_SUDO_REQ="You must be the superuser to run this script. Please use 'sudo ./'"
CONFIRMATION="Would you like to continue the process? Please type 1 or 2 respectively ..."
SUCCESS="Successful"
SVP_DOWN="Downloading SVP4 ..."
SVP_UNPACK="Unpacking SVP4 ..."
SVP_LINK="https://www.svp-team.com/files/svp4-linux.4.6.263.tar.bz2"
SVP_FILENAME="svp4-linux.4.6.263.tar.bz2"
SVP_INSTALL_MANUAL="Please continue installing SVP4 manually while the rest of the script is running. DO NOT RUN IT YET AFTER INSTALLING!"
EXITING_NOW="Exiting now!"
USER=""
CONFIRMATION_USERNAME="Please enter your user name as listed in directories. It is crucial that it is correct!"
JMPYN="Do you want to install Jellyfin Media Player?"
JMP="Downloading and installing Jellyfin Media Player. This may take a while ..."

# main script
if [ $(id -u) != "0" ]; then
	echo -e $ERROR_SUDO_REQ
	echo $EXITING_NOW
	exit 10
fi
echo $GREETINGS
echo $CONFIRMATION
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) echo $EXITING_NOW; sleep 3; exit;;
    esac
done
echo $CONFIRMATION_USERNAME
read USER
cd /home/$USER/Downloads
wget $SVP_LINK -P /home/$USER/Downloads
echo $SVP_UNPACK
tar xvf /home/$USER/Downloads/$SVP_FILENAME
chmod +x svp4-linux-64.run
echo $SUCCESS
echo $SVP_INSTALL_MANUAL
sleep 20
sudo add-apt-repository ppa:rvm/smplayer -y
sudo apt update
sudo apt install mediainfo libqt5concurrent5 libqt5svg5 libqt5qml5 libdisplay-info-dev wget g++ make autoconf automake libtool pkg-config nasm git meson smplayer smplayer-themes smplayer-skins cython3 libssl-dev libfribidi-dev libharfbuzz-dev libluajit-5.1-dev libx264-dev xorg-dev libxpresent-dev libegl1-mesa-dev libfreetype-dev libfontconfig-dev libffmpeg-nvenc-dev libva-dev libdrm-dev libplacebo-dev libasound2-dev libpulse-dev python-is-python3 -y
git clone --branch release-3.0.6 https://github.com/sekrit-twc/zimg.git
cd zimg   
./autogen.sh
./configure
make -j4
sudo make install
cd..
git clone --branch R72 https://github.com/vapoursynth/vapoursynth.git
cd vapoursynth
./autogen.sh
./configure
make -j4
sudo make install
cd..
sudo ldconfig
sudo ln -s /usr/local/lib/python3.12/site-packages/vapoursynth.so /usr/lib/python3.12/lib-dynload/vapoursynth.so
git clone https://github.com/mpv-player/mpv-build.git
cd mpv-build
./use-ffmpeg-release
echo --enable-libx264 >> ffmpeg_options
echo --enable-nvdec >> ffmpeg_options
echo --enable-vaapi >> ffmpeg_options
echo -Dvapoursynth=enabled >> mpv_options
echo -Dlibmpv=true >> mpv_options
echo -Ddrm=enabled >> mpv_options
./rebuild -j4
sudo ./install
sudo ln -s /usr/local/lib/x86_64-linux-gnu/libmpv.so /usr/local/lib/x86_64-linux-gnu/libmpv.so.1
sudo ln -sf /usr/local/lib/x86_64-linux-gnu/libmpv.so /usr/local/lib/libmpv.so.2
sudo ldconfig
cd /home/$USER/Downloads
rm -rf zimg

#Jellyfin Media Player
echo $JMPYN
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
			echo $JMP
			sleep 1
			cd /home/$USER/Downloads
            sudo apt install build-essential autoconf automake libtool libharfbuzz-dev libfreetype6-dev libfontconfig1-dev libx11-dev libxrandr-dev libvdpau-dev libva-dev mesa-common-dev libegl1-mesa-dev yasm libasound2-dev libpulse-dev libuchardet-dev zlib1g-dev libfribidi-dev git libgnutls28-dev libgl1-mesa-dev libsdl2-dev cmake wget meson nasm ninja-build python3 g++ qtwebengine5-dev qtquickcontrols2-5-dev libqt5x11extras5-dev libcec-dev qml-module-qtquick-controls qml-module-qtwebengine qml-module-qtwebchannel qtbase5-private-dev curl unzip -y
            mkdir ~/jmp
            cd ~/jmp
            git clone https://github.com/jellyfin/jellyfin-media-player.git
            cd jellyfin-media-player
            mkdir build
            cd build
            cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/local/ -G Ninja ..
            ninja
            sudo ninja install
            rm -rf ~/jmp/
			break;;
		No ) break;;
	esac
done
echo $SUCCESS
