#!/bin/sh

# RPI_ADDR=192.168.2.2

ssh-keygen -t ecdsa -b 521 -f $HOME/.ssh/id_ecdsa.rpi
sh ./src/setup-local-ssh.sh pi $RPI_ADDR
echo '[ -d $HOME/.ssh ] || mkdir $HOME/.ssh' | ssh pi@$RPI_ADDR sh
cat $HOME/.ssh/id_ecdsa.rpi.pub | ssh pi@$RPI_ADDR tee -a '$HOME/.ssh/authorized_keys'
cat ./src/setup-remote-ssh.sh | ssh pi@$RPI_ADDR sudo sh
