#!/system/bin/sh
# Remote proc part, need to start communication with real-time cluster
cd /vendor/firmware/
echo ./disfwk.elf > /sys/class/remoteproc/remoteproc0/firmware
echo start > /sys/class/remoteproc/remoteproc0/state
log -t dfw "remote proc started ..."
# WA: need to be sure that Taurus initialization is complete before starting KM
sleep 2
insmod /vendor/lib/modules/disfwk_fe.ko
log -t dfw "disfwk_fe starting ..."
