PRODUCT_SHIPPING_API_LEVEL := 35

BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy


LOCAL_AUDIO_PROPERTIES ?= \
    ro.hardware.audio.primary=caremu \
    ro.vendor.caremu.audiohal.out_period_ms=40 \
    ro.vendor.caremu.audiohal.in_period_ms=40 \

PRODUCT_PACKAGES += audio.primary.caremu

# Packages that will disable inherited ones
PRODUCT_PACKAGES += phony_override_packages

PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm:$(TARGET_COPY_OUT_RAMDISK)/fstab.trout_xenvm \
    device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm:$(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.trout_xenvm \
    device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.trout_xenvm \
    device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.trout_xenvm \
    device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm:$(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.trout_xenvm

PRODUCT_PACKAGE_OVERLAYS += device/epam/aosp-xenvm-trout/overlay

PRODUCT_VENDOR_PROPERTIES += vendor.ser.gnss-uart=/dev/vport6p2

# Upstream mesa3d graphics dependancies
PRODUCT_PACKAGES += \
        libEGL_mesa \
        libGLESv1_CM_mesa \
        libGLESv2_mesa \
        libgallium_dri \
        libglapi
