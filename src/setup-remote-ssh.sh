#!/bin/sh

# disable_raspi_config_at_boot was extracted from `raspi-config`
# Please see https://github.com/asb/raspi-config/
#
# Copyright (c) 2012 Alex Bradbury <asb@asbradbury.org>
# raspi-config is licensed under the terms of the MIT license reproduced below.
# https://github.com/asb/raspi-config/blob/e45b6d421f168e52c8708de698d37be571183b7b/LICENSE

setup_ssh() {
  echo SSH
  sudo sed -i 's/PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
  sudo sed -i 's/UsePAM .*/UsePAM no/' /etc/ssh/sshd_config
  sudo sed -i 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' /etc/pam.d/sshd

  if grep --quiet "^PasswordAuthentication" /etc/ssh/sshd_config
  then
    sudo sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
  else
    echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config
  fi
}

do_expand_rootfs() {
  if ! [ -h /dev/root ]; then
    echo "/dev/root does not exist or is not a symlink."
    return 0
  fi

  ROOT_PART=$(readlink /dev/root)
  PART_NUM=${ROOT_PART#mmcblk0p}

  if [ "$PART_NUM" = "$ROOT_PART" ]; then
    echo "/dev/root is not an SD card."
    return 0
  fi

  LAST_PART_NUM=$(parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)

  if [ "$LAST_PART_NUM" != "$PART_NUM" ]; then
    echo "/dev/root is not the last partition."
    return 0
  fi

  # Get the starting offset of the root partition
  PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d:)
  [ "$PART_START" ] || return 1
  # Return value will likely be error for fdisk as it fails to reload the
  # partition table because the root fs is mounted
  fdisk /dev/mmcblk0 <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START

p
w
EOF

  # now set up an init.d script
cat <<\EOF > /etc/init.d/resize2fs_once &&
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
  start)
    log_daemon_msg "Starting resize2fs_once" &&
    resize2fs /dev/root &&
    rm /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once remove &&
    log_end_msg $?
    ;;
  *)
    echo "Usage: $0 start" >&2
    exit 3
    ;;
esac
EOF
  chmod +x /etc/init.d/resize2fs_once &&
  update-rc.d resize2fs_once defaults &&

  if [ "$INTERACTIVE" = True ]; then
    echo "Root partition has been resized.\nThe filesystem will be enlarged upon the next reboot" 20 60 2
  fi
}

disable_raspi_config_at_boot() {
  if [ -e /etc/profile.d/raspi-config.sh ]; then
    echo Initialize.
    rm -f /etc/profile.d/raspi-config.sh
    sed -i /etc/inittab \
      -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" \
      -e "/#\s*RPICFG_TO_DISABLE/d"
    telinit q
  fi

  sync
  reboot
}

setup_ssh
do_expand_rootfs
disable_raspi_config_at_boot
