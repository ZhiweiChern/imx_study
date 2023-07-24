
# $(info start...)

ARCH_PATH := armv7
MANUFACT := nxp_repo
SOC_FAMILY := imx6
BOARD_NAME := yz_alpha

export ARCH_PATH MANUFACT SOC_FAMILY BOARD_NAME


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

# Call a source code checker (by default, "sparse") as part of the
# C compilation.
#
# Use 'make C=1' to enable checking of only re-compiled files.
# Use 'make C=2' to enable checking of *all* source files, regardless
# of whether they are re-compiled or not.
#
# See the file "Documentation/sparse.txt" for more details, including
# where to get the "sparse" utility.

ifeq ("$(origin C)", "command line")
  KBUILD_CHECKSRC = $(C)
endif
ifndef KBUILD_CHECKSRC
  KBUILD_CHECKSRC = 0
endif

export KBUILD_CHECKSRC

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

KBUILD_AFLAGS := -D__ASSEMBLY__
KBUILD_AFLAGS += -g
KBUILD_AFLAGS += $(KAFLAGS)

KBUILD_CFLAGS   := -Wall -Wstrict-prototypes \
		   -Wno-format-security \
		   -fno-builtin -ffreestanding
# KBUILD_CFLAGS	+= -O2
KBUILD_CFLAGS += -O0
KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
KBUILD_CFLAGS += $(call cc-option,-fno-delete-null-pointer-checks)
KBUILD_CFLAGS += -g
export KBUILD_CFLAGS KBUILD_AFLAGS

# KBUILD_CFLAGS += -fstack-usage
KBUILD_CFLAGS += $(call cc-option,-Wno-format-nonliteral)
# Prohibit date/time macros, which would make the build non-deterministic
KBUILD_CFLAGS += $(call cc-option,-Werror=date-time)

# 用户可以通过 KCFLAGS 添加加额外的编译选项
KBUILD_CFLAGS += $(KCFLAGS)

KBUILD_CPPFLAGS := -D__KERNEL__ -D__RTBOOT__
# 用户可以通过 KCPPFLAGS 添加加额外的编译选项
KBUILD_CPPFLAGS += $(KCPPFLAGS)

inc-y :=
-include $(srctree)/soc/$(ARCH_PATH)/include.mk
inc-y := $(sort $(inc-y))
inc-y := $(patsubst %,-I%, $(inc-y))

# Use RTBOOTINCLUDE when you must reference the include/ directory.
# Needed to be compatible with the O= option
RTBOOTINCLUDE :=  -I$(srctree) $(inc-y)

NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)

# PLATFORM_CPPFLAGS 这个是为不同平台准备的接口，不同的平台可以差异化编译选项
cpp_flags := $(KBUILD_CPPFLAGS) $(PLATFORM_CPPFLAGS) $(RTBOOTINCLUDE) \
							$(NOSTDINC_FLAGS)

c_flags := $(KBUILD_CFLAGS) $(cpp_flags)

export KBUILD_CPPFLAGS NOSTDINC_FLAGS RTBOOTINCLUDE

#   OBJCOPYFLAGS LDFLAGS

#============================================================
soc-y :=
soc-y += soc/$(ARCH_PATH)/
soc-y := $(sort $(soc-y))
soc-dirs := $(patsubst %/,%,$(filter %/, $(soc-y)))
soc-y := $(patsubst %/, %/built-in.o, $(soc-y))
rt-boot-soc := $(soc-y)

libs-y :=
libs-y += init/
libs-y := $(sort $(libs-y))
rt-boot-dirs := $(patsubst %/,%,$(filter %/, $(libs-y)))
# 关于 libs-，如果后续使用了 CONFIG_XXX 并且 CONFIG_XXX 没有被配置的话，libs- 会有值
rt-boot-alldirs := $(sort $(rt-boot-dirs) $(patsubst %/,%,$(filter %/, $(libs-))))

libs-y := $(patsubst %/, %/built-in.o, $(libs-y))
rt-boot-main := $(libs-y)

head-y := soc/$(ARCH_PATH)/start.o
rt-boot-init := $(head-y)

#============================================================
ALL-y :=
ALL-y += rt-boot.bin


PHONY := _all
_all: $(ALL-y)
	@:

quiet_cmd_objcopy = OBJCOPY $@
cmd_objcopy = $(OBJCOPY) --gap-fill=0xff $(OBJCOPYFLAGS) \
	$(OBJCOPYFLAGS_$(@F)) $< $@

rt-boot.bin: rt-boot FORCE
	$(call if_changed,objcopy)
	$(call DO_STATIC_RELA,$<,$@,$(CONFIG_SYS_TEXT_BASE))
	$(BOARD_SIZE_CHECK)

# Rule to link rt-boot
# May be overridden by arch/$(ARCH)/config.mk
quiet_cmd_rt-boot__ ?= LD      $@
      cmd_rt-boot__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_rt-boot) -o $@ \
      -T rt-boot.lds $(rt-boot-init)                             \
      --start-group $(rt-boot-soc) $(rt-boot-main) --end-group
#      $(PLATFORM_LIBS) -Map rt-boot.map

ifeq (1, 0)
quiet_cmd_smap = GEN     common/system_map.o
cmd_smap = \
	smap=`$(call SYSTEM_MAP,u-boot) | \
		awk '$$2 ~ /[tTwW]/ {printf $$1 $$3 "\\\\000"}'` ; \
	$(CC) $(c_flags) -DSYSTEM_MAP="\"$${smap}\"" \
		-c $(srctree)/common/system_map.c -o common/system_map.o
endif

rt-boot: $(rt-boot-init) $(rt-boot-main) rt-boot.lds FORCE
	$(call if_changed,rt-boot__)
#	$(call cmd,smap)
#	$(call cmd,u-boot__) common/system_map.o

rt-boot.lds: FORCE
	cp soc/$(ARCH_PATH)/rt-boot.lds ./

$(sort $(rt-boot-init) $(rt-boot-main)): $(rt-boot-dirs)
	@:

$(rt-boot-dirs): $(rt-boot-soc)
	$(Q)$(MAKE) $(build)=$@

$(rt-boot-soc): $(soc-dirs)
	@:

$(soc-dirs): tools_basic
	$(Q)$(MAKE) $(build)=$@

# $(head-dirs): tools_basic
# 	$(Q)$(MAKE) $(build)=$@

# Basic helpers built in scripts/
PHONY += tools_basic
tools_basic:
	$(Q)$(MAKE) $(build)=tools/basic
	$(Q)rm -f .tmp_quiet_recordmcount

#============================================================
###
# Cleaning is done on three levels.
# make clean     Delete most generated files
#                Leave enough to build external modules
# make mrproper  Delete the current configuration, and all generated files
# make distclean Remove editor backup files, patch leftover files and the like

# Directories & files removed with 'make clean'
CLEAN_DIRS  :=
CLEAN_FILES :=

# Directories & files removed with 'make mrproper'
MRPROPER_DIRS  :=
MRPROPER_FILES :=

# clean - Delete most, but leave enough to build external modules
#
clean: rm-dirs  := $(CLEAN_DIRS)
clean: rm-files := $(CLEAN_FILES)

clean-dirs	:= $(foreach f,$(bulid-alldirs),$(if $(wildcard $(srctree)/$f/Makefile),$f))
clean-dirs      := $(addprefix _clean_, $(clean-dirs))

PHONY += $(clean-dirs) clean
$(clean-dirs):
	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)

# TODO: Do not use *.cfgtmp
clean: $(clean-dirs)
	$(call cmd,rmdirs)
	$(call cmd,rmfiles)
	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
		-o -name '*.ko.*' -o -name '*.su' -o -name '*.cfgtmp' \
		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
		-o -name '*.symtypes' -o -name 'modules.order' \
		-o -name modules.builtin -o -name '.tmp_*.o.*' \
		-o -name '*.gcno' \) -type f -print | xargs rm -f
#============================================================

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
