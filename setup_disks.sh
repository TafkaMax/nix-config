#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "No disk specified. Canceling"
else
    ROOT_DISK=/dev/$1
    parted -a opt --script "${ROOT_DISK}" \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary 512MiB 100% \
    set 1 esp on \
    name 1 boot \
    set 2 lvm on \
    name 2 root
fi