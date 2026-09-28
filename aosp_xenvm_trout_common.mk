PRODUCT_SHIPPING_API_LEVEL := 37

BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy
BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy/system_ext/private


PRODUCT_PACKAGES += dhcpclient.recovery

PRODUCT_SOONG_NAMESPACES += \
    external/v4l2_codec2

PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2-service-v4l2 \
    libc2plugin_store \
    libv4l2_codec2_vendor_allocator \
    libv4l2_codec2_vendor_allocator_system

# Install extended policy for codec2.
PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/conf/android.hardware.media.c2-extended-seccomp_policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    device/epam/aosp-xenvm-trout/conf/android.hardware.media.c2-extended-seccomp_policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/android.hardware.media.c2-extended-seccomp_policy

# Set the customized property of v4l2_codec2, including:
# - The maximum concurrent instances for decoder/encoder.
#   It should be the same as "concurrent-instances" at media_codec_c2.xml.
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.v4l2_codec2.decode_concurrent_instances=8 \
    ro.vendor.v4l2_codec2.encode_concurrent_instances=4

# If ION is chosen, then the mask should be 0xf50000
# external/v4l2_codec2/README.md
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.c2-poolmask=0xf50000

LOCAL_AUDIO_PROPERTIES ?= \
    ro.hardware.audio.primary=caremu-ext \
    ro.vendor.caremu.audiohal.out_period_ms=40 \
    ro.vendor.caremu.audiohal.in_period_ms=40 \

PRODUCT_PACKAGES += audio.primary.caremu-ext

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

PRODUCT_PACKAGES += xenvm_overlay_connectivity
