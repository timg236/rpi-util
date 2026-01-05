#!/bin/bash

BLOCK=${2:-cust}
INDEX=${3:-0}
V=${4:-00000000}
V=$(printf %08x $V)
#echo V:$V

case "$1" in
read)
sudo dd if=/sys/bus/nvmem/devices/nvmem_${BLOCK}0/nvmem bs=4 count=1 skip=${INDEX} status=none | hexdump -e '"" 4/4 "%08x " "\n"'
;;
write)
printf "\x${V:6:2}\x${V:4:2}\x${V:2:2}\x${V:0:2}" | sudo dd of=/sys/bus/nvmem/devices/nvmem_${BLOCK}0/nvmem bs=4 count=1 seek=${INDEX} status=none
;;
*)
echo "Usage: $0 [read|write] [otp|cust|priv] [offset] [value]"
;;
esac
