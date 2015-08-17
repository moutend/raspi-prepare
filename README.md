raspi-prepare
==============

`raspi-prepare` is the tool to configure SSH
and run `raspi-config` without GUI.
Currently, it does the following tasks:

* Prepare SSH
  * Disable password authentication, root login and PAM.
  * Enable public key authentication.
* raspi-config
  * Expand root file system
  * Disable raspi-conf at boot

It targets RASPBIAN and similar OS..



## Usage

On your PC:

    git clone https://github.com/moutend/raspi-prepare.git
    cd ./raspi-prepar
    ./raspi-prepare -a RPI_ADDR

`RPI_ADDR` is an IP address assigned to Raspberry Pi.
If you not specified, `192.168.2.2` will be used as default IP address.



## LICENSE

MIT
