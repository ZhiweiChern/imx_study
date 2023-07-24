
INC_PATH_armv7 := $(srctree)/soc/$(ARCH_PATH)

INC_PATH_TEMP := $(INC_PATH_armv7)/$(MANUFACT)

inc-y += $(INC_PATH_armv7)
-include $(INC_PATH_TEMP)/include.mk
