#!/bin/sh

if [ $1 = update ]
then
  cd ~/draw
  git pull
  whiptail --msgbox "EtherDraw updated!" 8 32
  break
fi
[ $1 = remove ] && sh sysutils/supervisor.sh remove EtherDraw && rm -rf draw && whiptail --msgbox "EtherDraw removed!" 8 32 && break

# ARM architecture don't appear to work
if [ $ARCH = arm ] || [ $ARCH = armv6 ]
then
  whiptail --yesno "Your architecture ($ARCH) don't appear to be supported yet, continue anyway?" 8 48
  [ $? = 1 ] && 	sed -i "/\bEtherDraw\b/d" installed-apps && break
fi

. sysutils/NodeJS.sh

cd
# Install Requirements
$install libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++

# Install EtherDraw
git clone https://github.com/JohnMcLear/draw

#prepare the enviroment
cd draw
sh bin/installDeps.sh

# Add supervisor process and run the server
sh $DIR/sysutils/supervisor.sh EtherDraw "node server.js" $HOME/draw

whiptail --msgbox "EtherDraw successfully installed!

Open http://$IP:9002 in your browser and make a drawing\!" 10 64
