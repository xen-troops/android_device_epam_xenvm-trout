SUMMARY = "Google package group for AGL services"

inherit packagegroup

PACKAGES = "packagegroup-google-agl"

RDEPENDS:${PN} += "\
    google-trout-agl-services \
"
