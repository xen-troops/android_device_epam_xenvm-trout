LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

PHONY_OVERRIDE_PACKAGES := \
   com.android.hardware.uwb \

LOCAL_MODULE := phony_override_packages
LOCAL_MODULE_TAGS := optional
PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(PHONY_OVERRIDE_PACKAGES))
include $(BUILD_PHONY_PACKAGE)
