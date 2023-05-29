BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy

PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/shared/config/init.vendor.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.xenvm_trout.rc \
    device/epam/aosp-xenvm-trout/shared/config/init.recovery.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.xenvm_trout.rc \
    device/epam/aosp-xenvm-trout/shared/config/ueventd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/ueventd.xenvm_trout.rc

LOCAL_AUDIO_PROPERTIES ?= \
    ro.hardware.audio.primary=caremu-extended \
    ro.vendor.caremu.audiohal.out_period_ms=40 \
    ro.vendor.caremu.audiohal.in_period_ms=40 \

PRODUCT_PACKAGES += audio.primary.caremu-extended \
                    android.hardware.automotive.vehicle@2.0-virtualization-grpc-server-extended
