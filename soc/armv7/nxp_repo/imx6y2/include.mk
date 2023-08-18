
LOCAL_PATH_imx6 := $(INC_PATH_TEMP)
inc-y += $(LOCAL_PATH_imx6)

INC_PATH_TEMP := $(LOCAL_PATH_imx6)/$(BOARD_NAME)
-include $(INC_PATH_TEMP)/include.mk

INC_PATH_TEMP := $(LOCAL_PATH_imx6)/driver
-include $(INC_PATH_TEMP)/include.mk
