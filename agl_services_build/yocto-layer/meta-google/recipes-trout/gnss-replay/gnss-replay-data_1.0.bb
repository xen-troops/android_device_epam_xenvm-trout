SUMMARY = "GNSS replay fixture for the Trout virtio-console backend"
DESCRIPTION = "Synchronized Fix and Raw measurements used by the GNSS replay service"

LICENSE = "CC-BY-4.0"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/CC-BY-4.0;md5=9b33bbd06fb58995fb0e299cd38d1838 \
    file://NOTICE;md5=b05514bf5a5b9e74add0ed6fb00e25ef \
"

SRC_URI = " \
    file://gnss-replay-data.tar.gz \
    file://NOTICE \
"

S = "${UNPACKDIR}"

inherit allarch

do_install() {
    install -d ${D}${datadir}/gnss
    install -m 0644 \
        ${UNPACKDIR}/google-overlay/usr/share/gnss/test.csv \
        ${D}${datadir}/gnss/test.csv

    install -d ${D}${datadir}/doc/gnss-replay
    install -m 0644 ${UNPACKDIR}/NOTICE \
        ${D}${datadir}/doc/gnss-replay/NOTICE
}

FILES:${PN} = " \
    ${datadir}/gnss/test.csv \
    ${datadir}/doc/gnss-replay/NOTICE \
"
