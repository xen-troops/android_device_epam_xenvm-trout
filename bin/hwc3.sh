#!/system/bin/sh
# Wrapper, in case the hwc is requested before the display connector is created.

TRIES=20
SLEEP_SEC=1

found=0
card_id=1


while [ "$i" -le "$TRIES" ]; do
    for st in /sys/class/drm/card*-*/status; do
        if [ -e "$st" ]; then
            log -t dfw "DRM connector found: $st"
            found=1
            # Extract the card ID (e.g., /sys/.../card0-DP-1/status -> 0)
            # We strip the path prefix and everything after the first dash
            card_full=$(basename "$st")
            card_id=$(echo "$card_full" | cut -d'-' -f1 | sed 's/card//')
            break
        fi
    done

    [ "$found" -eq 1 ] && break

    log -t dfw "DRM connector not found (try $i/$TRIES), sleeping..."
    sleep "$SLEEP_SEC"
    i=$((i + 1))
done

log -t dfw "Setting vendor.hwc.drm.device to /dev/dri/card$card_id"
setprop vendor.hwc.drm.device "/dev/dri/card$card_id"
log -t dfw "starting hwc ..."

if [ "$found" -eq 1 ]; then
    # Extract card ID from path like /sys/class/drm/card0-HDMI-A-1/status
    card_node=$(echo "$st" | sed 's|/sys/class/drm/\(card[0-9]*\)-.*|\1|')
    setprop vendor.hwc.drm.device "/dev/dri/$card_node"
    log -t dfw "Display card detected, will use vendor.hwc.drm.device = /dev/dri/$card_node"
fi

/vendor/bin/hw/android.hardware.composer.hwc3-service.drm.xt
