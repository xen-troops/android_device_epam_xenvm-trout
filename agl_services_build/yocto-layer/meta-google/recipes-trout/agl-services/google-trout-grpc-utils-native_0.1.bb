DESCRIPTION = "Native GRPC Build utilities"

DEPENDS += "go-native"

TROUT_target_install = "\
    protoc:aprotoc \
    grpc_cpp_plugin:protoc-gen-grpc-cpp-plugin \
"

require common.inc

inherit native
