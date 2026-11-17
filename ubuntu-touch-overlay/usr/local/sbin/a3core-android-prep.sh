#!/bin/bash
set -e
mkdir -p /android/system_ext /android/product
mountpoint -q /android/system_ext || ([ -b /dev/mapper/system_ext ] && mount -o ro /dev/mapper/system_ext /android/system_ext) || true
mountpoint -q /android/product || ([ -b /dev/mapper/product ] && mount -o ro /dev/mapper/product /android/product) || true

mkdir -p /dev/__properties__
if ! mountpoint -q /dev/__properties__; then
    mount -t tmpfs -o mode=0755,nosuid,nodev,noexec tmpfs /dev/__properties__
fi
rm -rf /dev/__properties__/* 2>/dev/null || true
rm -f /dev/watchdog* 2>/dev/null || true

mkdir -p /sys/fs/selinux
mountpoint -q /sys/fs/selinux || mount -t selinuxfs selinuxfs /sys/fs/selinux || true

if [ -f /sys/fs/selinux/load ] && [ ! -f /run/android-sepolicy.loaded ]; then
    SEPOL="/var/lib/lxc/android/sepolicy.compiled"
    if [ -s "$SEPOL" ]; then
        python3 -c '
data = open("/var/lib/lxc/android/sepolicy.compiled", "rb").read()
with open("/sys/fs/selinux/load", "wb") as f:
    f.write(data)
'
        echo 0 > /sys/fs/selinux/enforce || true
        touch /run/android-sepolicy.loaded
    fi
fi

mkdir -p /dev/block/platform/soc/soc:ap-ahb/20600000.sdio
ln -sfn /dev/disk/by-partlabel /dev/block/platform/soc/soc:ap-ahb/20600000.sdio/by-name
