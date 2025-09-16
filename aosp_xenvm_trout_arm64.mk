# TARGET_PREBUILT_KERNEL - environment variable which could contain path to the prebuilt kernel.
ifneq ($(TARGET_PREBUILT_KERNEL),)
   # Set TARGET_KERNEL_PATH variable which defines which kernel will be used in trout device.
   TARGET_KERNEL_PATH := $(TARGET_PREBUILT_KERNEL)

   TARGET_KERNEL_USE := 6.1
endif

# Disable UWB HAL
PRODUCT_COPY_FILES += \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.uwb.xml \

PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/init/xenvm_trout.init.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/xenvm_trout.init.rc

LOCAL_OEMLOCK_PRODUCT_PACKAGE := android.hardware.oemlock-service.example

DEVICE_VIRTWIFI_PORT := eth0

PRODUCT_VENDOR_PROPERTIES += \
    ro.carwatchdog.client_healthcheck.interval=20 \
    ro.carwatchdog.vhal_healthcheck.interval=10 \

ENABLE_EVS_SERVICE := false
ENABLE_EVS_SAMPLE := false

# Enable Thread Network HAL with simulation RCP
PRODUCT_PACKAGES += \
    com.android.hardware.threadnetwork-simulation-rcp

TARGET_RECOVERY_FSTAB := device/epam/aosp-xenvm-trout/shared/config/fstab.trout_xenvm

PRODUCT_VENDOR_PROPERTIES += \
	persist.vendor.otsim.local_interface=eth1

# Ensure unique overlays for Car Emulator Audio HAL
LOCAL_AUDIO_PROPERTIES := \
    ro.hardware.audio.primary=caremu \
    ro.vendor.caremu.audiohal.out_period_ms=40 \
    ro.vendor.caremu.audiohal.in_period_ms=40

LOCAL_AUDIO_PRODUCT_PACKAGE := \
    audio.primary.caremu \
    audio.r_submix.default \
    android.hardware.audio@6.0-impl:32 \
    android.hardware.audio.effect@6.0-impl:32 \
    android.hardware.audio.service-caremu \
    android.hardware.soundtrigger@2.3-impl

# used by trout
#LOCAL_AUDIO_DEVICE_PACKAGE_OVERLAYS := device/generic/car/emulator/audio/overlay

## Intentionally not adding LOCAL_AUDIOCONTROL_HAL_PRODUCT_PACKAGE to avoid
## re-introducing conflicting audiocontrol services; caremu is covered above.
LOCAL_AUDIOCONTROL_HAL_PRODUCT_PACKAGE :=

# Prevent mk2rbc mapping from re-adding the same overlay path via LOCAL_AUDIO_DEVICE_PACKAGE_OVERLAYS
#LOCAL_AUDIO_DEVICE_PACKAGE_OVERLAYS :=

TARGET_USES_CUTTLEFISH_AUDIO ?= false
AUDIO_FEATURE_HFP_ENABLED ?= true

$(call inherit-product, device/google/cuttlefish/shared/virgl/device_vendor.mk)
$(call inherit-product, device/google/trout/aosp_trout_arm64.mk)
$(call inherit-product, device/epam/aosp-xenvm-trout/aosp_xenvm_trout_common.mk)

LOCAL_BT_PROPERTIES = \
 vendor.ser.bt-uart=/dev/hvc5 \

PRODUCT_NAME := aosp_xenvm_trout_arm64
PRODUCT_DEVICE := xenvm_trout_arm64
PRODUCT_MODEL := xenvm arm64 trout