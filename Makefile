
$(info start...)

# Beautify output
# ---------------------------------------------------------------------------
#
# Normally, we echo the whole command before executing it. By making
# that echo $($(quiet)$(cmd)), we now have the possibility to set
# $(quiet) to choose other forms of output instead, e.g.
#
#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
#
# If $(quiet) is empty, the whole command will be printed.
# If it is set to "quiet_", only the short version will be printed.
# If it is set to "silent_", nothing will be printed at all, since
# the variable $(silent_cmd_cc_o_c) doesn't exist.
#
# A simple variant is to prefix commands with $(Q) - that's useful
# for commands that shall be hidden in non-verbose mode.
#
#	$(Q)ln $@ :<
#
# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.
#
# Use 'make V=0' to see the simple commands
# Use 'make V=1' to see the full commands

ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 1
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif

export quiet Q KBUILD_VERBOSE

#-------------------------------------------
HOSTARCH := $(shell uname -m | \
	sed -e s/i.86/x86/ \
	    -e s/sun4u/sparc64/ \
	    -e s/arm.*/arm/ \
	    -e s/sa110/arm/ \
	    -e s/ppc64/powerpc/ \
	    -e s/ppc/powerpc/ \
	    -e s/macppc/powerpc/\
	    -e s/sh.*/sh/)

HOSTOS := $(shell uname -s | tr '[:upper:]' '[:lower:]' | \
	    sed -e 's/\(cygwin\).*/cygwin/')

export	HOSTARCH HOSTOS
# $(info HOSTARCH: $(HOSTARCH), HOSTOS: $(HOSTOS))

CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

HOSTCC       = cc
HOSTCXX      = c++
HOSTCFLAGS   = -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS = -O2

export CONFIG_SHELL HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS
# $(info CONFIG_SHELL: $(CONFIG_SHELL))

#-------------------------------------------
# ARCH := arm
CROSS_COMPILE := arm-linux-gnueabihf-

AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
# LD		= $(CROSS_COMPILE)ld.bfd
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
LDR		= $(CROSS_COMPILE)ldr
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

export CROSS_COMPILE AS LD CC CPP AR NM LDR STRIP OBJCOPY OBJDUMP

#-------------------------------------------
srctree := .
KBUILD_BUILTIN := 1
export srctree KBUILD_BUILTIN

MAKEFLAGS += --no-print-directory

include tools/Kbuild.include

KBUILD_CFLAGS   := -Wall -Wstrict-prototypes \
		   -Wno-format-security \
		   -fno-builtin -ffreestanding
# KBUILD_CFLAGS	+= -O2
KBUILD_CFLAGS	+= -O0
KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
KBUILD_CFLAGS += $(call cc-option,-fno-delete-null-pointer-checks)
KBUILD_CFLAGS	+= -g
KBUILD_CFLAGS += -fstack-usage
KBUILD_CFLAGS += $(call cc-option,-Wno-format-nonliteral)
# Prohibit date/time macros, which would make the build non-deterministic
KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
KBUILD_CFLAGS += $(KCFLAGS)

KBUILD_CPPFLAGS := -D__KERNEL__ -D__UBOOT__
# 用户想加编译选项可以通过 KCPPFLAGS
KBUILD_CPPFLAGS += $(KCPPFLAGS)
# PLATFORM_CPPFLAGS 这个是为不同平台准备的接口，不同的平台可以差异化编译选项
cpp_flags := $(KBUILD_CPPFLAGS) $(PLATFORM_CPPFLAGS) $(UBOOTINCLUDE) \
							$(NOSTDINC_FLAGS)

c_flags := $(KBUILD_CFLAGS) $(cpp_flags)

PHONY := _all
_all: tools_basic
	$(MAKE) $(build)=gpio_int

# Basic helpers built in scripts/
PHONY += tools_basic
tools_basic:
	$(Q)$(MAKE) $(build)=tools/basic
	$(Q)rm -f .tmp_quiet_recordmcount

# PHONY += $(u-boot-dirs)
# $(u-boot-dirs): prepare scripts
# 	@echo here....
# 	$(Q)$(MAKE) $(build)=$@

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
