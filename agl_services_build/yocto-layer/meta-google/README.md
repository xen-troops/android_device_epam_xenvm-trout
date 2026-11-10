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
repository. They load the recipe's Python source and compressed fixture
directly, so a configured Yocto build directory is not required.

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest -v \
    agl_services_build/tests/test_gnss_replay.py
```

These tests cover:

- fragmented and coalesced newline-delimited requests;
- complete response framing, unknown commands, and connection shutdown;
- the shared Fix/Raw replay timeline;
- live clock and timestamp translation;
- measurement-session control;
- runtime speed and accuracy limits;
- the contents of the packaged dataset;
- deterministic satellite status.

### GNSS backend protocol

The Android GNSS HAL sends these commands over the GNSS virtio-console port:

- `CMD_GET_LOCATION\n`
- `CMD_GET_RAWMEASUREMENT\n`
- `CMD_GET_SV_STATUS\n`
- `CMD_SET_MEASUREMENT_CONFIG,<full-tracking>,<correlation-vectors>,<interval-ms>\n`
- `CMD_STOP_MEASUREMENT\n`

Requests are single-line commands terminated by one newline byte. Responses
may contain multiple CSV lines and retain the existing four-newline end marker
expected by Android `DeviceFileReader`. The `full-tracking` and
`correlation-vectors` flags are encoded as `0` or `1`, and the interval is a
positive integer in milliseconds.
Configuration and stop commands return `OK` when the requested state was
applied and `ERROR` when the configuration was rejected. A hardware backend
must stop receiver measurement acquisition before acknowledging
`CMD_STOP_MEASUREMENT`. Both commands are idempotent: retrying the same
configuration keeps that configuration active, and stopping an already stopped
session still returns `OK`.

`CMD_GET_SV_STATUS` returns one CSV epoch. Its header and every record use this
schema:

```text
# SvStatus,Svid,ConstellationType,Cn0DbHz,BasebandCn0DbHz,ElevationDegrees,AzimuthDegrees,CarrierFrequencyHz,CodeType,SvFlags,ElapsedRealtimeFlags,ElapsedRealtimeNanos,ElapsedRealtimeUncertaintyNanos
```

The replay service publishes a deterministic 13-signal sky matching the AOSP
default HAL test data. A hardware backend should populate the same schema from
the receiver's navigation engine.
