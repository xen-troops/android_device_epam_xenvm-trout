BOARD_KERNEL_CMDLINE += androidboot.fstab_name=fstab androidboot.fstab_suffix=trout_xenvm

-include device/google/trout/trout_arm64/BoardConfig.mk

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648 # 2 GB
