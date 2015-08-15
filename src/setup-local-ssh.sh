#!/bin/bash

echo "Adding the following settings into $HOME/.ssh/config:\n"
if grep --quiet "^Host rpi" ~/.ssh/config 2> /dev/null
then
  echo Already exists.
else
  cat <<EOF | tee -a ~/.ssh/config
Host rpi
    HostName        $2
    IdentityFile    ~/.ssh/id_ecdsa.rpi
    User            $1
EOF
  echo "\nAdded $HOME/.ssh/configure"
fi
