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
    device/epam/aosp-xenvm-trout/init/ueventd.xenvm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \

LOCAL_OEMLOCK_PRODUCT_PACKAGE := android.hardware.oemlock-service.example


PRODUCT_VENDOR_PROPERTIES += ro.hardware.egl=powervr
PRODUCT_VENDOR_PROPERTIES += ro.hardware.vulkan=powervr


# To override VHAL, declare LOCAL_VHAL_PRODUCT_PACKAGE
# prior to device/google/trout/aosp_trout_arm64.mk include
LOCAL_VHAL_PRODUCT_PACKAGE = android.hardware.automotive.vehicle@2.0-virtualization-service

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

# Testing tool for vhost-vsock
PRODUCT_PACKAGES += \
    lisot

# Composer 2.3
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.3-hal \
    android.hardware.graphics.composer@2.3-passthrough \
    android.hardware.graphics.composer@2.3-service \
    hwcomposer.xenvm_trout_arm64 \

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
    img_vintf_android.hardware.dumpstate@1.1-service.img.xml \
    android.hardware.dumpstate@1.1-service.img.rc \
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
    android.hardware.dumpstate@1.1-service.img \
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
    gralloc.xenvm_trout_arm64 \
    mapper.powervr \
    vulkan.powervr

PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client

# Graphics composer HIDL HAL (service added below)
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.1-impl

# Dumpstate
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.1 \
    android.hardware.dumpstate@1.1.vendor

 # Testing tool for for display
 PRODUCT_PACKAGES += \
    modetest \

PRODUCT_COPY_FILES += \
    vendor/prebuilts/renesas/firmware/disfwk.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/disfwk.elf \
    device/epam/aosp-xenvm-trout/init/displ_fe.sh:$(TARGET_COPY_OUT_VENDOR)/etc/init/displ_fe.sh \

LOCAL_DEVICE_FCM_MANIFEST_FILE = device/epam/aosp-xenvm-trout/manifest.xml

$(call inherit-product, device/epam/aosp-xenvm-trout/build/graphics.mk)
$(call inherit-product, device/google/cuttlefish/shared/virgl/device_vendor.mk)
$(call inherit-product, device/google/trout/aosp_trout_arm64.mk)
$(call inherit-product, device/epam/aosp-xenvm-trout/aosp_xenvm_trout_common.mk)

LOCAL_BT_PROPERTIES = \
 vendor.ser.bt-uart=/dev/hvc5 \

PRODUCT_NAME := aosp_xenvm_trout_arm64
PRODUCT_DEVICE := xenvm_trout_arm64
PRODUCT_MODEL := xenvm arm64 trout
