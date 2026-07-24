##############################################################################
# OP-TEE integration for DomA
#
# OPTEE OS IPL is built in DomD with virtualization support and can be
# reached from other domains (DomD/DomA) through the Xen OPTEE mediator.
# DomA runs the OP-TEE client stack (tee-supplicant + libteec).
#
# Provides the variables that vendor/optee/optee_os/mk/aosp_optee.mk expects,
# and points BUILD_OPTEE_MK at that file. aosp_optee.mk builds the OP-TEE OS
# from vendor/optee/optee_os, emits the TA dev kit (export-ta_arm64 +
# host_include) and builds/signs the xtest TAs against it.
##############################################################################

OPTEE_OS_DIR          := vendor/optee/optee_os
OPTEE_TA_TARGETS      := ta_arm64
OPTEE_CFG_ARM64_CORE  := y
OPTEE_PLATFORM        := rcar_gen5
OPTEE_PLATFORM_FLAVOR := X5H

# Use exactly the same options as in domd/domu optee-os
OPTEE_EXTRA_FLAGS      = CFG_INSECURE=y RCAR_DEBUG_LOG=0 CFG_SCIF=n CFG_NS_VIRTUALIZATION=y

# Build the OP-TEE OS and the TAs with the AOSP prebuilt clang
# LLVM_PREBUILTS_PATH points at the same clang
# It is only defined in the Android.mk phase, while this file is parsed as a
# product fragment, hence the deferred (=) assignments
CROSS_COMPILE64       := aarch64-linux-gnu-
OPTEE_CLANG_BIN        = $(abspath $(LLVM_PREBUILTS_PATH))
OPTEE_TOOLCHAIN_FLAGS  = COMPILER=clang \
                         OPTEE_CLANG_COMPILER_PATH=$(OPTEE_CLANG_BIN)/ \
                         PYTHON3=/usr/bin/python3

# Reset SRECFLAGS for llvm-objcopy
OPTEE_EXTRA_FLAGS     += $(OPTEE_TOOLCHAIN_FLAGS) SRECFLAGS=
OPTEE_EXTRA_TA_FLAGS   = $(OPTEE_TOOLCHAIN_FLAGS)

# Use as is configuration from xen-troops fork (based on the Renesas BSP)
BUILD_OPTEE_MK := $(OPTEE_OS_DIR)/mk/aosp_optee.mk

# optee_test gates its GP socket tests on CFG_GP_SOCKETS from the dev-kit
# conf.mk, which is not generated yet when kati parses it on a clean build.
# Set it here (parsed first, as a product fragment) so the tests are not
# dropped; conf.mk later re-sets it to the same value.
CFG_GP_SOCKETS := y

# Enable tee-supplicant optional features to pass several xtest tests:
# GP sockets (required for regression_2001.2/2002.1/2003.2/2004.2) and
# plugins (required for regression_1033)
$(call soong_config_set,optee_client,cfg_gp_sockets,true)
$(call soong_config_set,optee_client,cfg_tee_supp_plugins,true)

PRODUCT_PACKAGES += \
        tee-supplicant \
        libteec

PRODUCT_PACKAGES += xtest

# Core regression TAs (always built):
PRODUCT_PACKAGES += \
    cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta \
    5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta \
    ffd2bded-ab7d-4988-95ee-e4962fff7154.ta \
    b3091a65-9751-4784-abf7-0298a7cc35ba.ta \
    d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta \
    e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta \
    a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta \
    c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta \
    528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta \
    b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta \
    731e279e-aafb-4575-a771-38caa6f0cca6.ta \
    f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta \
    e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta \
    5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta \
    25497083-a58a-4fc5-8a72-1ad7b69b8562.ta \
    02a42f43-d8b7-4a57-aa4d-87bd9b5587cb.ta \
    873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta

# tee-supplicant test plugin + its TA
# needed for the RPC / plugin xtest cases
PRODUCT_PACKAGES += \
    f07bfc66-958c-4a15-99c0-260e4e7375dd.plugin \
    380231ac-fb99-47ad-a689-9e017eb6e78a.ta

# subkey-signed regression TAs (xtest regression_1039)
PRODUCT_PACKAGES += \
    5c206987-16a3-59cc-ab0f-64b9cfc9e758.ta \
    a720ccbb-51da-417d-b82e-e5445d474a7a.ta
