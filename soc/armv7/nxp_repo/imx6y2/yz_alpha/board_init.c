/**************************************************************

**************************************************************/

#include "MCIMX6Y2.h"
#include "fsl_iomuxc.h"
#include "clock_config.h"

static int pins_init(void);

int board_init(void)
{
	SystemInitIrqTable();
    pins_init();
    BOARD_BootClockRUN();

	return 0;
}

static int pins_init(void)
{
    // LED0
    IOMUXC_SetPinMux(IOMUXC_GPIO1_IO03_GPIO1_IO03, 0U);
	IOMUXC_SetPinConfig(IOMUXC_GPIO1_IO03_GPIO1_IO03,
        IOMUXC_SW_PAD_CTL_PAD_SRE(0U) |
        IOMUXC_SW_PAD_CTL_PAD_DSE(6U) |
        IOMUXC_SW_PAD_CTL_PAD_SPEED(0U) |
        IOMUXC_SW_PAD_CTL_PAD_ODE(0U) |
        IOMUXC_SW_PAD_CTL_PAD_PKE(1U) |
        IOMUXC_SW_PAD_CTL_PAD_PUE(0U) |
        IOMUXC_SW_PAD_CTL_PAD_PUS(0U) |
        IOMUXC_SW_PAD_CTL_PAD_HYS(0U));

    // KEY0
    IOMUXC_SetPinMux(IOMUXC_UART1_CTS_B_GPIO1_IO18, 0U);
    IOMUXC_SetPinConfig(IOMUXC_UART1_CTS_B_GPIO1_IO18,
        IOMUXC_SW_PAD_CTL_PAD_SRE(0U) |
        IOMUXC_SW_PAD_CTL_PAD_DSE(6U) |
        IOMUXC_SW_PAD_CTL_PAD_SPEED(2U) |
        IOMUXC_SW_PAD_CTL_PAD_ODE(0) |
        IOMUXC_SW_PAD_CTL_PAD_PKE(1) |
        IOMUXC_SW_PAD_CTL_PAD_PUE(0) |
        IOMUXC_SW_PAD_CTL_PAD_PUS(0) |
        IOMUXC_SW_PAD_CTL_PAD_HYS(1U));

    return 0;
}
