
$(info start...)

srctree := .
KBUILD_BUILTIN := 1

export srctree KBUILD_BUILTIN


# ARCH := arm
CROSS_COMPILE := arm-linux-gnueabihf-

AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld.bfd
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
LDR		= $(CROSS_COMPILE)ldr
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

export CROSS_COMPILE AS LD CC CPP AR NM LDR STRIP OBJCOPY OBJDUMP

include Kbuild.include

# PHONY := _all
# _all:

scripts_basic:
	$(MAKE) $(build)=.

# PHONY += $(u-boot-dirs)
# $(u-boot-dirs): prepare scripts
# 	@echo here....
# 	$(Q)$(MAKE) $(build)=$@



PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
