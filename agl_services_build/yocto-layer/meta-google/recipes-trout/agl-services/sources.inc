# TODO(chenhaosjtuacm): set it to the correct license, license file is needed
LICENSE = "CLOSED"

# Since repo is not working correctly in our case (b/165933540), we simulate
# the behavior of device/google/trout/agl_services_build/repo_manifest.xml
# in the unpacking task.

ANDROID_REMOTE = "git://android.googlesource.com"
BORINGSSL_REMOTE = "git://boringssl.googlesource.com"
GITHUB_REMOTE = "git://github.com"

DEFAULT_REVISION = "s-v2-fs-release"

FETCH_CODE_PREFIX = "src"

S = "${WORKDIR}/${FETCH_CODE_PREFIX}"

# Pull the source from git server remote/name to path
def trout_git_uri(d, remote, name, path, revision):
    return '{}/{};protocol=https;nobranch=1;' \
           'destsuffix={}/{};rev={}'.format(
               d.getVar(remote), name,
               d.getVar('FETCH_CODE_PREFIX'), path, revision)

# TODO (chenhaosjtuacm): generate SRC_URI from the manifest

SRC_URI = "\
    file://${FETCH_CODE_PREFIX}/device/google/trout \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/external/fmtlib', 'third_party/fmtlib', '62f93cae8a2b34c258733674bfbb320ffb37e828')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/external/grpc-grpc', 'third_party/grpc-grpc', '8c84d36ef0c626b51697f177906af6992d4a89bd')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/external/jsoncpp', 'third_party/jsoncpp',   '1b2c7506fd0ea96c1ffa5de4fc0342ceed420416')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/external/protobuf', 'third_party/protobuf',     '564fd16025f8d7913e19b15dd94ac3fec1bdf999')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/hardware/interfaces', 'hardware/interfaces', '27e43a9c18689826f67fc4ba14939fb679d40a47')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/system/core', 'third_party/android/system_core', '70ffe2bc893ba769ba6aaeffc4b3686fa4f6dd32')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/system/libbase', 'third_party/android/libbase', '988723798df152824c20a4d5e13290d4690df00a')} \
    ${@trout_git_uri(d, 'ANDROID_REMOTE', 'platform/system/logging', 'third_party/android/logging', '16ee30b1f2a84dde0d6d3084fb2fc891397e150c')} \
    ${@trout_git_uri(d, 'BORINGSSL_REMOTE', 'boringssl', 'third_party/boringssl', '0b710a305b42b67522003a314dea3e3868485665')} \
    ${@trout_git_uri(d, 'GITHUB_REMOTE', 'c-ares/c-ares', 'third_party/cares', '3be1924221e1326df520f8498d704a5c4c8d0cce')} \
    ${@trout_git_uri(d, 'GITHUB_REMOTE', 'gflags/gflags', 'third_party/gflags', '28f50e0fed19872e0fd50dd23ce2ee8cd759338e')} \
    ${@trout_git_uri(d, 'GITHUB_REMOTE', 'madler/zlib', 'third_party/zlib', 'cacf7f1d4e3d44d871b605da3b647f07d718623f')} \
    ${@trout_git_uri(d, 'GITHUB_REMOTE', 'google/googletest', 'third_party/googletest', '1fb1bb23bb8418dc73a5a9a82bbed31dc610fec7')} \
"

SRC_SYMLINKS = "\
   device/google/trout/agl_services_build/build.sh:build.sh \
   device/google/trout/agl_services_build/CMakeLists.txt:CMakeLists.txt \
   device/google/trout/agl_services_build/cmake:cmake \
   device/google/trout/agl_services_build/toolchain:toolchain \
   device/google/trout/hal/audiocontrol:audiocontrol \
   device/google/trout/hal/dumpstate/1.1:dumpstate_server \
   device/google/trout/hal/vehicle/2.0:vehicle_hal_server \
   device/google/trout/hal/common/agl/watchdog:watchdog_test_server \
   hardware/interfaces/automotive/vehicle/2.0/default:third_party/default_native_vehicle_hal \
"

def force_create_symlink(src, dst):
    src = os.path.relpath(src, os.path.dirname(dst))
    tmplink = '{}.templink'.format(dst)
    os.symlink(src, tmplink)
    os.rename(tmplink, dst)

python do_unpack:append() {
    os.chdir(d.getVar('S'))
    linkfile_rules = d.getVar('SRC_SYMLINKS').split()
    for src, dst in map(lambda x: x.split(':'), linkfile_rules):
        force_create_symlink(src, dst)
}
