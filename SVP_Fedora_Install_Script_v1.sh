#!/bin/sh
# Copyright (c) 2025 LaVitae
# GNU General Public License v3.0 (see https://www.gnu.org/licenses/gpl-3.0.txt)

# variables
GREETINGS="Hi! This script will install dependencies for SVP4 on Fedora"
ERROR_SUDO_REQ="You must be the superuser to run this script. Please use 'sudo ./'"
CONFIRMATION="Would you like to continue the process? Please type 1 or 2 respectively ..."
CONFIRMATION_USERNAME="Please enter your user name as listed in directories. It is crucial that it is correct!"
USER=""
DEPEND_SCRIPT="Downloading dependencies for this script to work, if not installed already ..."
SVP_DOWN="Downloading SVP4 ..."
SVP_UNPACK="Unpacking SVP4 ..."
SVP_INSTALL_MANUAL="Please continue installing SVP4 manually while the rest of the script is running..."
DEPEND_TRY="Trying to install all dependencies for SVP4. This will take some time depending on your network speed..."
BIG_DEPEND_LIST="@development-tools mediainfo gcc g++ autoconf automake libtool python3 python3-devel python3-cython meson freetype-devel fribidi-devel nasm gstreamer1-vaapi-devel libavcodec-free-devel libva-devel pipewire-devel wayland-protocols-devel libxkbcommon-devel libdrm-devel x264-devel fontconfig-devel nv-codec-headers"
ZIMG="Downloading and building zimg. This may take a while ..."
VAPOURSYNTH="Downloading and building vapoursynth. This may take a while ..."
MPV="Downloading, building and configuring mpv. This may take a while ..."
SMPLAYER="Downloading and installing SMPlayer. This may take a while ..."
JMPYN="Do you want to install Jellyfin Media Player?"
JMP="Downloading and installing Jellyfin Media Player. This may take a while ..."
TEST_VIDEO="Do you want to download a test video?"
SUCCESS="Successful, continuing ..."
CLEAN_UP="Cleaning up downloaded files and directories ..."
ALL_DONE="Everything is done!"
EXITING_NOW="Exiting now!"

# variables that may change in the future
SVP_LINK="https://www.svp-team.com/files/svp4-linux.4.6.263.tar.bz2"
SVP_FILENAME="svp4-linux.4.6.263.tar.bz2"
RPMFUSION_LINK="https://download1.rpmfusion.org/free/fedora/releases/39/Everything/x86_64/os/Packages/r/rpmfusion-free-release-39-1.noarch.rpm"
RPMFUSION_FILENAME="rpmfusion-free-release-39-1.noarch.rpm"
ZIMG_LINK="--branch release-3.0.5 https://github.com/sekrit-twc/zimg.git"
VAPOURSYNTH_LINK="--branch R66 https://github.com/vapoursynth/vapoursynth.git "
MPV_LINK="https://github.com/mpv-player/mpv-build.git"
TEST_VIDEO_LINK="https://www.youtube.com/watch?v=grGeRsgFXhA"

# main script
echo $GREETINGS

if [ $(id -u) != "0" ]; then
	echo -e $ERROR_SUDO_REQ
	echo $EXITING_NOW
	exit 10
fi

echo $CONFIRMATION
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) echo $EXITING_NOW; sleep 3; exit;;
    esac
done

echo $CONFIRMATION_USERNAME
read USER

echo $DEPEND_SCRIPT
sleep 1
dnf -y install wget tar rpm git
echo $SUCCESS

echo $SVP_DOWN
sleep 1
wget $SVP_LINK -P /home/$USER/Downloads
echo $SUCCESS

echo $SVP_UNPACK
sleep 1
tar xvf /home/$USER/Downloads/$SVP_FILENAME
chmod +x svp4-linux-64.run
echo $SUCCESS
echo $SVP_INSTALL_MANUAL
sleep 15

echo $DEPEND_SCRIPT
sleep 1
wget $RPMFUSION_LINK -P /home/$USER/Downloads
rpm -Uvh $RPMFUSION_FILENAME
echo $SUCCESS
sleep 1

echo $DEPEND_TRY
sleep 1
dnf -y install $BIG_DEPEND_LIST
echo $SUCCESS
sleep 1

echo $ZIMG
sleep 2
cd /home/$USER/Downloads
mkdir git
cd git/
git clone $ZIMG_LINK
cd zimg
./autogen.sh 
./configure 
make -j4
make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
cd ..
$SUCCESS
sleep 1

echo $VAPOURSYNTH
sleep 1
git clone $VAPOURSYNTH_LINK
cd vapoursynth 
./autogen.sh 
./configure 
make -j4
make install
cd ..
ldconfig
ln -s /usr/local/lib64/python3.13/site-packages/vapoursynth.so /usr/lib64/python3.13/lib-dynload/vapoursynth.so
echo $SUCCESS
sleep 1

echo $MPV
sleep 1
git clone $MPV_LINK
cd mpv-build
./use-ffmpeg-release
echo --enable-libx264 >> ffmpeg_options
echo --enable-nvdec >> ffmpeg_options
echo --enable-vaapi >> ffmpeg_options
echo -Dvapoursynth=enabled >> mpv_options
echo -Dlibmpv=true >> mpv_options
echo -Ddmabuf-wayland=enabled >> mpv_options
echo -Dvaapi-wayland=enabled >> mpv_options
echo -Dwayland=enabled >> mpv_options
echo -Ddrm=enabled >> mpv_options
./rebuild -j4
./install
echo $SUCCESS
sleep 1

echo $SMPLAYER
sleep 1
dnf install smplayer -y
sleep 1

echo $TEST_VIDEO
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
			cd /home/$USER/Downloads
			dnf install -y yt-dlp
			yt-dlp $TEST_VIDEO_LINK
			break;;
		No ) break;;
	esac
done
echo $SUCCESS
sleep 1

echo $JMPYN
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
			echo $JMP
			sleep 1
			dnf install qt5-qtquickcontrols -y
			dnf copr enable sammyette/jellyfin-media-player -y
			dnf install jellyfin-media-player -y
			sleep 1
			break;;
		No ) break;;
	esac
done
echo $SUCCESS
sleep 1

# Removing old files
echo $CLEAN_UP
sleep 1
cd /home/$USER/Downloads
rm $SVP_FILENAME
rm $RPMFUSION_FILENAME
rm -r git/
rm svp4-linux-64.run
echo $SUCCESS
sleep 2
echo $ALL_DONE
echo $EXITING_NOW
sleep 1
exit
