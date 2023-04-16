FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

GOOGLE_OVERLAY_SRC_URI = "file://google-overlay"

GOOGLE_OVERLAY_ROOT_DIRS = "google-overlay"

IMAGE_INSTALL:append = " packagegroup-google-agl"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit google-image-overlay
