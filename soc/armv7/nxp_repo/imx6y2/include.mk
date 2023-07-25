
LOCAL_PATH_imx6 := $(INC_PATH_TEMP)
INC_PATH_TEMP := $(LOCAL_PATH_imx6)/$(BOARD_NAME)

inc-y += $(LOCAL_PATH_imx6)
-include $(INC_PATH_TEMP)/include.mk
