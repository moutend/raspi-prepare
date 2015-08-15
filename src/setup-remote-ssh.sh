#!/bin/sh

echo Enable publick key authentication.
sudo sed -i 's/PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/UsePAM .*/UsePAM no/' /etc/ssh/sshd_config
sudo sed -i 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' /etc/pam.d/sshd

if grep --quiet "^PasswordAuthentication" /etc/ssh/sshd_config
then
  sudo sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
else
  echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config
fi
