DESCRIPTION = "Native GRPC Build utilities"

DEPENDS += "go-native"

SRCREV_FORMAT = "default"

TROUT_target_install = "\
    protoc:aprotoc \
    grpc_cpp_plugin:protoc-gen-grpc-cpp-plugin \
"

EXTRA_OECMAKE += "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

require common.inc

inherit native
