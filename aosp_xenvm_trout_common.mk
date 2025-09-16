PRODUCT_SHIPPING_API_LEVEL := 35

BOARD_SEPOLICY_DIRS += device/epam/aosp-xenvm-trout/sepolicy

PRODUCT_PACKAGES += dhcpclient.recovery

# Reference AIDL Vehicle HAL (AOSP). See trout ENABLE_VHAL_FAKE_GRPC_SERVER
PRODUCT_PACKAGES += android.hardware.automotive.vehicle@default-trout-service
PRODUCT_PACKAGES += android.hardware.automotive.vehicle@default-trout-fake-hardware-grpc-server
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.vehiclehal.server.use_local_fake_server=true

# Reference HIDL Vehicle HAL (AOSP)
PRODUCT_PACKAGES += android.hardware.automotive.vehicle@2.0-default-service

# Add basic audio HAL services for automotive
PRODUCT_PACKAGES += \
    android.hardware.audio.service-aidl.example \
    android.hardware.audio.effect.service-aidl.example

# Add missing audio HAL AIDL services for automotive
PRODUCT_PACKAGES += \
    vendor.audio-hal-aidl \
    vendor.audio-effect-hal-aidl \
    audio_proxy_service

# Add automotive type permission (correct file that exists)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml

# Exclude automotive health service to avoid conflicts with cuttlefish
PRODUCT_PACKAGES += \
    -android.hardware.health-service.automotive \
    -android.hardware.health-service.automotive_recovery

# Default HAL's for compliance
PRODUCT_PACKAGES += \
    android.hardware.atrace@1.0-service \
    android.hardware.lights-service.example \
    android.system.suspend-service

# Entropy solutions for VM environment
PRODUCT_PACKAGES += \
    rngd

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

PRODUCT_PACKAGES += xenvm_overlay_connectivity

# Disable StrongBox KeyMint for VM environment
BOARD_USES_STRONGBOX_KEYSTORE := false
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml
# Remove StrongBox feature requirements
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.strongbox_keystore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.strongbox_keystore.xml

# Add car-specific overlays for proper resource mapping
PRODUCT_PACKAGE_OVERLAYS += \
    packages/services/Car/car_product/overlay \
    device/generic/car/common/overlay \
    packages/apps/Car/Launcher/overlay

# Add car resource overlays for idmap2
PRODUCT_PACKAGES += \
    CarSystemUIEvsOverlay \
    CarSettingsProviderOverlay

# Add core system services for activity management
PRODUCT_PACKAGES += \
    services \
    system_server \
    framework-res \
    core-oj \
    core-libart

# Add essential font assets required by system services
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)

# Add ICU and internationalization assets for proper Zygote preloading
$(call inherit-product-if-exists, external/icu/icu4j/main/classes/core/Android.mk)
$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)


# Ensure required bootstrap services are available for system_server startup
PRODUCT_PACKAGES += \
    watchdog \
    PowerManagerService \
    ThermalManagerService \
    PackageManagerService \
    UserManagerService

# Add additional framework components for complete Zygote preloading
PRODUCT_PACKAGES += \
    framework-minus-apex \
    ext \
    telephony-common

# Add car framework and resource packages
PRODUCT_PACKAGES += \
    android.car \
    car-frameworks-service \
    car-service-lib \
    automotive-framework-res

# Add modern AIDL framework services for system server
PRODUCT_PACKAGES += \
    framework-aidl-services \
    android.app.aidl-services

# Add Car-specific packages for Android Automotive
PRODUCT_PACKAGES += \
    CarLauncher \
    CarSystemUI \
    CarService \
    CarServiceUpdater

# Add Android Automotive UI resources and themes
PRODUCT_PACKAGES += \
    CarUiLib \
    car-ui-lib \
    car-theme-lib \
    androidx-car-app \
    CarTheme \
    car-resources

# Add launcher icon and resource packages for Android 15
PRODUCT_PACKAGES += \
    CarLauncherIcons \
    automotive-launcher-icons

# Configure activity manager for proper AIDL service startup
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.activity_manager.enable_aidl=true \
    ro.config.aidl_lazy_service_timeout=60000 \
    ro.config.activity.aidl_service=true \
    persist.vendor.activity.service.enable=true

# Add comprehensive automotive resources to fix idmap2 resource failures
PRODUCT_PACKAGES += \
    CarThemes \
    CarThemeOverlay \
    automotive-resource-overlay \
    car-theme-overlay

# Add automotive color scheme and theming resources
PRODUCT_PACKAGES += \
    automotive-frameworks-res \
    car-ui-themes \
    automotive-colors \
    car-colors-lib

# Add automotive drawables and UI components
PRODUCT_PACKAGES += \
    automotive-drawable-res \
    car-drawable-lib \
    CarMaterialTheme \
    CarUiTheme

# Use optimized preloaded-classes for faster Zygote preloading in VM
PRODUCT_COPY_FILES += \
    device/epam/aosp-xenvm-trout/preloader/preloaded-classes-optimized:system/etc/preloaded-classes

# Disable excessive framework class preloading for VM
PRODUCT_PROPERTY_OVERRIDES += \
    ro.zygote.preload_framework_classes=false \
    ro.config.zygote_preload_essential_only=true
