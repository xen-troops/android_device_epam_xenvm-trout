LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

PHONY_OVERRIDE_PACKAGES := \
   com.android.hardware.uwb \
   com.android.hardware.gatekeeper.cf_remote \
   com.android.hardware.gatekeeper.nonsecure \
   com.android.hardware.keymint.rust_cf_remote \
   com.android.hardware.keymint.rust_nonsecure \
   com.android.hardware.keymint.rust_cf_guest_trusty_nonsecure \

LOCAL_MODULE := phony_override_packages
LOCAL_MODULE_TAGS := optional
PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(PHONY_OVERRIDE_PACKAGES))
include $(BUILD_PHONY_PACKAGE)
