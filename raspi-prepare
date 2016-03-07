#!/bin/bash

trap 'exit' INT

RPI_USER="pi"
RPI_ADDR="192.168.2.2"

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
  echo "usage: raspi-prepare [RPI_USER RPI_ADDR]"
  echo "	default RPI_USER=pi"
  echo "	default RPI_ADDR=192.168.2.2"
  exit 0
fi

if [ ! "$1" == "" ]
then
  RPI_USER=$1
fi

if [ ! "$2" == "" ]
then
  RPI_ADDR=$2
fi

echo "Info:	RPI_USER=$RPI_USER"
echo "Info:	RPI_ADDR=$RPI_ADDR"
KEY="id_ecdsa.rpi"
if [ -e "$HOME/.ssh/$KEY" ]
then
  TS=`ruby -e 'puts (Time.now.to_f * 1000000).to_i'`
  mv $HOME/.ssh/$KEY $HOME/.ssh/$KEY$TS
  mv $HOME/.ssh/$KEY.pub $HOME/.ssh/$KEY$TS.pub
fi

echo "Info:	Create new key pair"
ssh-keygen -t ecdsa -b 521 -f "$HOME/.ssh/$KEY"

RPI_HOST="$RPI_USER@$RPI_ADDR"
echo "Info:	Create /home/$RPI_USER/.ssh if not exists"
echo '[ -d $HOME/.ssh ] || mkdir $HOME/.ssh' | ssh $RPI_HOST sh

echo "Info:	Add the pub key to /home/$RPI_USER/.ssh/authorized_keys"
cat $HOME/.ssh/$KEY.pub | ssh $RPI_HOST tee -a '$HOME/.ssh/authorized_keys'

echo "Info:	Expand root file system"
cat ./expand_rootfs.sh | ssh $RPI_HOST sudo sh

echo "🍺  Successfully done!"
