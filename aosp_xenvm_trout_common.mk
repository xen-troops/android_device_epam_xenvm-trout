BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy


LOCAL_AUDIO_PROPERTIES ?= \
    ro.hardware.audio.primary=caremu \
    ro.vendor.caremu.audiohal.out_period_ms=40 \
    ro.vendor.caremu.audiohal.in_period_ms=40 \

PRODUCT_PACKAGES += audio.primary.caremu



PRODUCT_PACKAGE_OVERLAYS += device/epam/aosp-xenvm-trout/overlay
