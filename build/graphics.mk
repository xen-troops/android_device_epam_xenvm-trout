#
# Copyright (C) 2016 The Android Open-Source Project
# Copyright (C) 2018, 2026 EPAM Systems Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Graphics / GPU configuration — PowerVR (IMG DDK) & Display
#

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=powervr \
    ro.hardware.vulkan=powervr \
    ro.opengles.version=196610

# PowerVR mapper / memtrack services + VINTF fragments
PRODUCT_PACKAGES += \
    mapper.powervr \
    libpvr_mapper_utils \
    android.hardware.memtrack-service.img \
    android.hardware.graphics.allocator-service \
    android.hardware.graphics.allocator.aidl-service.img.rc \
    android.hardware.memtrack.aidl.img.rc \
    img_vintf_android.hardware.graphics.allocator.aidl-service.img-v2.xml \
    img_vintf_android.hardware.memtrack.aidl.img.xml \
    img_vintf_mapper.powervr.xml \

# Graphics HALs
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V2-ndk.vendor \
    android.hardware.memtrack-V1-ndk.vendor \
    android.hardware.drm-V1-ndk.vendor \
    libgralloctypes.vendor \
    libEGL_powervr \
    libGLESv1_CM_powervr \
    libGLESv2_powervr \
    vulkan.powervr \
    libIMGegl \
    libpvrANDROID_WSEGL \
    libPVROCL \
    libPVRScopeServices \
    libsrv_um \
    libufwriter \
    libusc \
    libgpudataproducer \
    rgx.sh.35.2.1632.35 \
    img-deps

# HWC
PRODUCT_PACKAGES += com.android.hardware.graphics.composer.drm_hwcomposer
PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client

# Display driver
PRODUCT_COPY_FILES += \
    vendor/prebuilts/renesas/firmware/disfwk.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/disfwk.elf \
    device/epam/aosp-xenvm-trout/bin/dfw.sh:$(TARGET_COPY_OUT_VENDOR)/bin/dfw.sh \
    device/epam/aosp-xenvm-trout/bin/hwc3.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hw/hwc3.sh

# Feature permissions
hardware_features := \
    vulkan.level-1 \
    vulkan.version-1_4 \
    vulkan.compute-0

software_features := \
    vulkan.deqp.level-2026-03-01 \
    opengles.deqp.level-2026-03-01

PRODUCT_COPY_FILES += \
    $(foreach _f,$(hardware_features),frameworks/native/data/etc/android.hardware.$(_f).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.$(_f).xml) \
    $(foreach _f,$(software_features),frameworks/native/data/etc/android.software.$(_f).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.$(_f).xml)

# Neural Networks HAL
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks-V4-ndk \
    android.hardware.neuralnetworks-V4-ndk.vendor

PRODUCT_PACKAGES += \
    libneuralnetworks_common \
    libneuralnetworks_common_cl \
    libneuralnetworks_cl \
    libneuralnetworks_shim_static \
    neuralnetworks_supportlibrary_loader \
    neuralnetworks_types_cl \
    neuralnetworks_utils_hal_aidl \
    neuralnetworks_utils_hal_common \
    lib_nnCache \
    libBlobCache \
    libRScpp_static \
    librs_jni \
    libLLVM

# -----------------------------------------------------------------------------
# Shared libraries
# -----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    libaidlcommonsupport \
    libarect \
    libbase_ndk \
    libcrypto_static \
    libcutils \
    libdmabufheap.vendor \
    libdmabufinfo \
    libdrm \
    libdrm.vendor \
    libion \
    libion.vendor \
    libnl.vendor \
    libperfetto_client_experimental \
    libpng.vendor \
    libprotobuf-cpp-lite \
    libui.vendor \
    libutilscallstack \
    libutilscallstack.vendor \
    libyuv \
    perfetto_trace_protos

# Debug / profiling tools
PRODUCT_PACKAGES += \
    egltrace \
    eglretrace \
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
    libdumpstateutil \
    libdumpstateutil.vendor

# Do not use vulkan from CF
override TARGET_VULKAN_SUPPORT := false

# Using vulkan backend for hwui.
TARGET_USES_VULKAN := true
