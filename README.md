# raspi-prepare
[![MIT License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](http://moutend.mit-license.org/)

`raspi-prepare` is small bash-script for configuring
SSH connection to your Raspberry Pi and run `raspi-config` without GUI.
Currently, it does the following tasks:

* Disable password authentication, root login and PAM.
* Enable public key authentication.
* Expand root file system
* Disable raspi-conf at boot

It targets RASPBIAN and similar OS.



# Quick start

On your PC, please run:

    % git clone https://github.com/moutend/raspi-prepare.git
    % cd ./raspi-prepare
    % ./raspi-prepare pi 192.168.1.123

If you not specified, `192.168.2.2` will be used as default IP address.



# LICENSE

MIT
