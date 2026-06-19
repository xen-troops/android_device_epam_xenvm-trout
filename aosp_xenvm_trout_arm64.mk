# TARGET_PREBUILT_KERNEL - environment variable which could contain path to the prebuilt kernel.
ifneq ($(TARGET_PREBUILT_KERNEL),)
   # Set TARGET_KERNEL_PATH variable which defines which kernel will be used in trout device.
   TARGET_KERNEL_PATH := $(TARGET_PREBUILT_KERNEL)

   TARGET_KERNEL_USE := 6.1
endif

PRODUCT_SYSTEM_EXT_PROPERTIES += \
   dalvik.vm.usejit=false \

# Configure single touch device
PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/conf/Vendor_0627_Product_0003.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_0627_Product_0003.idc

# Disable UWB HAL
PRODUCT_COPY_FILES += \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.uwb.xml \

PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/init/xenvm_trout.init.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/xenvm_trout.init.rc \

UEVENTD_ODM_COPY_FILE = device/epam/aosp-xenvm-trout/init/ueventd.xenvm.rc

LOCAL_OEMLOCK_PRODUCT_PACKAGE := android.hardware.oemlock-service.example


PRODUCT_VENDOR_PROPERTIES += ro.hardware.egl=powervr
PRODUCT_VENDOR_PROPERTIES += ro.hardware.vulkan=powervr


# To override VHAL, declare LOCAL_VHAL_PRODUCT_PACKAGE
# prior to device/google/trout/aosp_trout_arm64.mk include
LOCAL_VHAL_PRODUCT_PACKAGE = android.hardware.automotive.vehicle@2.0-virtualization-service

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

# Testing tool for vhost-vsock
PRODUCT_PACKAGES += \
    lisot

# Hwcomposer
PRODUCT_PACKAGES += \
    android.hardware.composer.hwc3-service.drm.xt \

# Img deps
PRODUCT_PACKAGES += \
    libdmabufinfo \
    libprotobuf-cpp-lite \
    perfetto_trace_protos \
    libperfetto_client_experimental \
    android.hardware.atrace@1.0.vendor \
    android.hardware.dumpstate@1.0.vendor \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal@1.0.vendor \
    libion.vendor \
    libdmabufheap.vendor \
    libdumpstateutil.vendor \
    android.hardware.memtrack-V1-ndk.vendor \
    libdrm \
    libarect \
    perfetto_trace_protos

# Global for IMG DDK

PRODUCT_PACKAGES += \
    android.hardware.graphics.common@1.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.renderscript@1.0-impl \
    libion \
    libdrm \
    libLLVM \
    img-deps \



# Graphics allocator/mapper HIDL HALs
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1

# Graphics allocator AIDL V1 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0.vndk-sp \
    android.hardware.graphics.mapper@2.0.vndk-sp \
    android.hardware.graphics.mapper@2.1.vndk-sp \
    android.hardware.graphics.common@1.0.vndk-sp \
    android.hardware.atrace@1.0.vndk-sp \
    libhwbinder.vndk-sp \
    libbase.vndk-sp \
    libcutils.vndk-sp \
    libhardware.vndk-sp \
    libhidlbase.vndk-sp \
    libhidltransport.vndk-sp \
    libutils.vndk-sp \
    libc++.vndk-sp \
    libRS_internal.vndk-sp \
    libRSDriver.vndk-sp \
    libRSCpuRef.vndk-sp \
    libbcinfo.vndk-sp \
    libblas.vndk-sp \
    libft2.vndk-sp \
    libpng.vndk-sp \
    libcompiler_rt.vndk-sp \
    libbacktrace.vndk-sp \
    libunwind.vndk-sp \
    libunwindstack.vndk-sp \
    liblzma.vndk-sp \
    libion.vndk-sp \
    android.hardware.graphics.composer@2.1 \
    android.hardware.graphics.allocator-V2-ndk.vendor \
    libgralloctypes.vendor


PRODUCT_PACKAGES += \
    img_vintf_android.hardware.graphics.allocator.aidl-service.img-v2.xml \
    img_vintf_android.hardware.memtrack.aidl.img.xml \
    img_vintf_mapper.powervr.xml \
    android.hardware.graphics.allocator.aidl-service.img.rc \
    android.hardware.memtrack.aidl.img.rc \
    hwperfbin2jsont \
    pvrdebug \
    pvrhtb2txt \
    pvrhtbd \
    pvrhwperf \
    pvrhwperfd \
    pvrlogdump \
    pvrlogsplit \
    pvrsrvctl \
    pvrtld \
    android.hardware.graphics.allocator-service \
    android.hardware.memtrack-service.img \
    rgx.fw.35.2.1632.35 \
    rgx.sh.35.2.1632.35 \
    libgpudataproducer \
    libIMGegl \
    libpvrANDROID_WSEGL \
    libPVROCL \
    libPVRScopeServices \
    libsrv_um \
    libufwriter \
    libusc \
    libEGL_powervr \
    libGLESv1_CM_powervr \
    libGLESv2_powervr \
    mapper.powervr \
    vulkan.powervr \
    libpvr_mapper_utils \
    android.hardware.graphics.mapper@4.0-impl \
    img_vintf_android.hardware.graphics.mapper@4.0-passthrough.img.xml


LOCAL_DUMPSTATE_PRODUCT_PACKAGE = android.hardware.dumpstate-service.img \
	android.hardware.dumpstate.aidl-service.img.rc \
	img_vintf_android.hardware.dumpstate.aidl-service.img.xml


PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client

# Graphics composer HIDL HAL (service added below)
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.1-impl

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Dumpstate
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.1 \
    android.hardware.dumpstate@1.1.vendor \
    android.hardware.dumpstate-V1-ndk.vendor

 # Testing tool for for display
 PRODUCT_PACKAGES += \
    modetest \

# Display driver
PRODUCT_COPY_FILES += \
    vendor/prebuilts/renesas/firmware/disfwk.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/disfwk.elf \
    device/epam/aosp-xenvm-trout/bin/dfw.sh:$(TARGET_COPY_OUT_VENDOR)/bin/dfw.sh \
    device/epam/aosp-xenvm-trout/bin/hwc3.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/hwc3.sh

# Display settings for multi-display support
# Must be before the emulator's vendor.mk.
PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/display_settings.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display_settings.xml

# Display layout for multi-display support
# Must be before the emulator's vendor.mk.
PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/display_layout_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_layout_configuration.xml

# Display permissions for multi-display support
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:system/etc/permissions/android.software.activities_on_secondary_displays.xml

# CarService RRO overlay for multi-display support
PRODUCT_PACKAGES += CarServiceOverlayXenVm
# Default launcher package for secondary display for multi-display and multi-user support
PRODUCT_PACKAGES += com.android.car.carlauncher

# ---- Multi-display / Multi-user (UserPicker) configuration ----
# Enable visible background users on secondary displays.
# This is the key property that gates UserPicker, CarUserService callbacks,
# and the entire multi-user-on-multi-display feature.
# The overlay sets config_multiuserVisibleBackgroundUsers=true, but we also
# set the system property explicitly to ensure it takes effect early at boot
# (before Resources.getSystem() overlay application).
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += fw.visible_bg_users=true

# Auto-populate 1 passenger user so display 1 shows UserPicker at boot
# (same as Cuttlefish auto_md reference)
# PRODUCT_SYSTEM_DEFAULT_PROPERTIES += com.android.car.internal.debug.num_auto_populated_users=1

LOCAL_DEVICE_FCM_MANIFEST_FILE = device/epam/aosp-xenvm-trout/manifest.xml
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/epam/aosp-xenvm-trout/compatibility_matrix.xml

# Enable auto ethernet setup and config scripts for eth1
# interface used for host-guest communication in xenvm
PRODUCT_PACKAGES += \
    auto_ethernet_setup_script_xenvm \
    auto_ethernet_config_script_xenvm

TARGET_NO_TELEPHONY := true

$(call inherit-product, device/epam/aosp-xenvm-trout/build/graphics.mk)
$(call inherit-product, device/google/trout/aosp_trout_arm64.mk)
$(call inherit-product, device/epam/aosp-xenvm-trout/aosp_xenvm_trout_common.mk)

LOCAL_BT_PROPERTIES = \
 vendor.ser.bt-uart=/dev/hvc5 \

PRODUCT_NAME := aosp_xenvm_trout_arm64
PRODUCT_DEVICE := xenvm_trout_arm64
PRODUCT_MODEL := xenvm arm64 trout
