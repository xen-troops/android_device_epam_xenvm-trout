Trout AGL Service Yocto Build Layer
===================================

This is a yocto meta-layer defining the build recipes for several Trout AGL services (e.g., vehicle HAL server). This needs to be tested with the AGL BSP source tree.

### Prerequisite

Acquire a Yocto BSP as needed for your use cases.

### Add layers

First copy this directory to `ROOT_OF_AGL_BSP/apps/apps_proc`

```
bitbake-layers add-layer meta-clang meta-google
```

### Build
`bitbake google-trout-agl-services`

### GNSS replay unit tests

Run the replay tests from the root of the `android_device_epam_xenvm-trout`
repository. They load the recipe's Python source and replay fixture
directly, so a configured Yocto build directory is not required.

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest -v \
    agl_services_build/tests/test_gnss_replay.py
```

The tests exercise fragmented and coalesced newline-delimited requests,
complete response framing, unknown commands, and connection shutdown.
These tests cover monotonic Fix replay, runtime clock refresh, speed and
accuracy limits, and Raw replay behavior.
