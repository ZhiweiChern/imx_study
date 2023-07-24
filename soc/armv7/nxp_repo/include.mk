
LOCAL_PATH_nxp_repo := $(INC_PATH_TEMP)
INC_PATH_TEMP := $(LOCAL_PATH_nxp_repo)/$(SOC_FAMILY)

inc-y += $(LOCAL_PATH_nxp_repo)
-include $(INC_PATH_TEMP)/include.mk
