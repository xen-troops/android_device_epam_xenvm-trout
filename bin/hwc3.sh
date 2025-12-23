#!/system/bin/sh
# Wrapper, in case the hwc is requested before the display connector is created.

TRIES=20
SLEEP_SEC=1

found=0

while [ "$i" -le "$TRIES" ]; do
    for st in /sys/class/drm/card*-*/status; do
        if [ -e "$st" ]; then
            log -t dfw "DRM connector found: $st"
            found=1
            break
        fi
    done

    [ "$found" -eq 1 ] && break

    log -t dfw "DRM connector not found (try $i/$TRIES), sleeping..."
    sleep "$SLEEP_SEC"
    i=$((i + 1))
done

log -t dfw "starting hwc ..."

/vendor/bin/hw/android.hardware.composer.hwc3-service.drm.xt
