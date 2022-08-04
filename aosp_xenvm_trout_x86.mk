$(call inherit-product, device/google/trout/aosp_trout_x86.mk)

include device/epam/aosp-xenvm-trout/aosp_xenvm_trout_common.mk

PRODUCT_NAME := aosp_xenvm_trout_x86
PRODUCT_DEVICE := xenvm_trout_x86
PRODUCT_MODEL := xenvm x86 trout