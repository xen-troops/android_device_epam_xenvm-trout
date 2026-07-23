DESCRIPTION = "Android Automotive OS Virtualization - AGL Services"

TOOLCHAIN = "clang"

TARGET_CFLAGS:append = " -Wno-error=vla-cxx-extension"
TARGET_CXXFLAGS:append = " -Wno-error=vla-cxx-extension"
TARGET_CFLAGS:append = " -Wno-error=array-parameter"
TARGET_CXXFLAGS:append = " -Wno-error=array-parameter"
TARGET_CFLAGS:append = " -Wno-error=unused-but-set-variable"
TARGET_CXXFLAGS:append = " -Wno-error=deprecated-declarations"
TARGET_CFLAGS:append = " -Wno-error=incompatible-pointer-types-discards-qualifiers"
TARGET_CXXFLAGS:append = " -Wno-error=incompatible-pointer-types-discards-qualifiers"

EXTRA_OECMAKE += "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

SRCREV_FORMAT = "default"

DEPENDS += "\
    google-trout-grpc-utils-native \
    systemd \
    libxml2 \
"

TROUT_target_install = "\
    vehicle_hal_grpc_server \
    dumpstate_grpc_server \
    garage_mode_helper \
"

COMMON_OPTIMIZATION = ""

inherit perlnative python3native

require common.inc
