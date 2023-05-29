$(call inherit-product, device/google/trout/aosp_trout_arm64.mk)

include device/epam/aosp-xenvm-trout/aosp_xenvm_trout_common.mk

LOCAL_BT_PROPERTIES = \
 vendor.ser.bt-uart=/dev/hvc5 \

PRODUCT_NAME := aosp_xenvm_trout_arm64
PRODUCT_DEVICE := xenvm_trout_arm64
PRODUCT_MODEL := xenvm arm64 trout