SUMMARY = "Google package group for AGL services"

inherit packagegroup

PACKAGES = "packagegroup-google-agl"

RDEPENDS:${PN} += "\
    gnss-replay-data \
    google-trout-agl-services \
"
