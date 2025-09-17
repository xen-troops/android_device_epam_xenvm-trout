
TARGET_USERDATAIMAGE_PARTITION_SIZE := 7516192768 # 7 GB

ifneq ($(TARGET_PREBUILT_MODULES_DIR),)
    SYSTEM_DLKM_SRC := $(TARGET_PREBUILT_MODULES_DIR)
endif

include device/google/trout/trout_arm64/BoardConfig.mk

ifneq ($(TARGET_PREBUILT_MODULES_DIR),)
    # Set KERNEL_MODULES_PATH to the directory with modules
    KERNEL_MODULES_PATH := $(TARGET_PREBUILT_MODULES_DIR)
    BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(filter-out $(TARGET_PREBUILT_MODULES_DIR),$(shell find $(TARGET_PREBUILT_MODULES_DIR) -type f -name *.ko))
    BOARD_VENDOR_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES)
endif

BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648 # 2 GB

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy/private

BOARD_BOOTCONFIG := androidboot.fstab_name=fstab
BOARD_BOOTCONFIG += androidboot.fstab_suffix=trout_xenvm
BOARD_BOOTCONFIG += androidboot.boot_devices=passthrough/16a003e00.virtio_mmio
BOARD_BOOTCONFIG += androidboot.vendor.apex.com.android.hardware.keymint=com.android.hardware.keymint.rust_nonsecure
BOARD_BOOTCONFIG += androidboot.vendor.apex.com.android.hardware.gatekeeper=com.android.hardware.gatekeeper.nonsecure
#Using the local GRPC vehicle server that running on the same VM as the client VMADDR_CID_LOCAL
BOARD_BOOTCONFIG += androidboot.vendor.vehiclehal.server.cid=1
BOARD_BOOTCONFIG += androidboot.vendor.vehiclehal.server.port=9210
BOARD_BOOTCONFIG += androidboot.vendor.vehiclehal.server.psf=/data/data/power.file
BOARD_BOOTCONFIG += androidboot.vendor.vehiclehal.server.pss=/data/data/power.socket
BOARD_BOOTCONFIG += androidboot.selinux=permissive
BOARD_BOOTCONFIG += androidboot.android_dt_dir=/proc/device-tree/firmware#1/android/
BOARD_BOOTCONFIG += kernel.vmw_vsock_virtio_transport_common.virtio_transport_max_vsock_pkt_buf_size=16384
BOARD_BOOTCONFIG += androidboot.load_modules_parallel=true
BOARD_BOOTCONFIG += androidboot.enable_bootanimation=1
BOARD_BOOTCONFIG += androidboot.lcd_density=160
BOARD_BOOTCONFIG += androidboot.hardware.hwcomposer=ranchu
BOARD_BOOTCONFIG += androidboot.hardware.hwcomposer.mode=client
BOARD_BOOTCONFIG += androidboot.hardware.hwcomposer.display_finder_mode=drm
BOARD_BOOTCONFIG += androidboot.hardware.gralloc=minigbm
BOARD_BOOTCONFIG += androidboot.hardware.egl=mesa
BOARD_BOOTCONFIG += androidboot.openthread_node_id=1

# Reuse trout androidboot properties
BOARD_BOOTCONFIG += androidboot.hardware=cutf_cvm
BOARD_BOOTCONFIG += androidboot.serialno=CUTTLEFISHCVD01
BOARD_BOOTCONFIG += androidboot.cf_devcfg=1

# Set GPU properties
BOARD_BOOTCONFIG += androidboot.cpuvulkan.version=0

# Add WiFi configuration for VirtWifi network
BOARD_BOOTCONFIG += androidboot.wifi_mac_prefix=5554

# Override trout cmdline
BOARD_KERNEL_CMDLINE = enforcing=0
BOARD_KERNEL_CMDLINE += mac80211_hwsim.radios=0
BOARD_KERNEL_CMDLINE += audit=1
BOARD_KERNEL_CMDLINE += panic=-1
BOARD_KERNEL_CMDLINE += 8250.nr_uarts=1

BOARD_VENDOR_SEPOLICY_DIRS += device/google/cuttlefish/shared/virgl/sepolicy
# vendor sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += device/google/cuttlefish/shared/sepolicy/vendor
BOARD_VENDOR_SEPOLICY_DIRS += device/google/cuttlefish/shared/sepolicy/vendor/seriallogging
BOARD_VENDOR_SEPOLICY_DIRS += device/google/cuttlefish/shared/sepolicy/vendor/google

# Use virgl and mesa3d upstream
BOARD_MESA3D_USES_MESON_BUILD := true
BOARD_MESA3D_GALLIUM_DRIVERS := virgl
