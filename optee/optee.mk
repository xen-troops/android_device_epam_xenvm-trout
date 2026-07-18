##############################################################################
# OP-TEE integration for DomA
#
# OPTEE OS IPL is built in DomD with virtualization support and can be
# reached from other domains (DomD/DomA) through the Xen OPTEE mediator.
# DomA runs the OP-TEE client stack (tee-supplicant + libteec).
##############################################################################

PRODUCT_PACKAGES += \
        tee-supplicant \
        libteec
