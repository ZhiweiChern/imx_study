/**********************************************************************
 * FilePath: gpio.c
 * Author: 
 * Date: 2023-8-23 15:40:20
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "fsl_iomuxc.h"
#include "fsl_gpio.h"
#include "MCIMX6Y2.h"


int pins_iomux_init(void)
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

gpio_pin_config_t led0_config = {
    kGPIO_DigitalOutput,
    0,  // 0 is led on
    kGPIO_NoIntmode,
};

/* Define the init structure for the input key0 pin */
gpio_pin_config_t key0_config = {
    kGPIO_DigitalInput,
    0,
    kGPIO_IntRisingEdge,
};

static void key0_irqhandler(void);

void gpio_init(void)
{
    /* ----- init led0 ----- */
    GPIO_PinInit(GPIO1, 3, &led0_config);

    /* ----- init key0 ----- */
    SystemInstallIrqHandler(GPIO1_Combined_16_31_IRQn, (system_irq_handler_t)key0_irqhandler, NULL);

    /* Init input switch GPIO. */
    EnableIRQ(GPIO1_Combined_16_31_IRQn);
    GPIO_PinInit(GPIO1, 18, &key0_config);

    /* Enable GPIO pin interrupt */  
    GPIO_EnableInterrupts(GPIO1, 1U << 18);
}

#define LED_ON      1
#define LED_OFF     0
void led0_ctrl(int status)
{
    if(status == LED_ON)
        GPIO_WritePinOutput(GPIO1, 3, 0);   // 0 is led on
    else
        GPIO_WritePinOutput(GPIO1, 3, 1);
}

unsigned char led0_state = LED_ON;

static void key0_irqhandler(void)
{
    /* clear the interrupt status */
    GPIO_ClearPinsInterruptFlags(GPIO1, 1U << 18);

    led0_state = !led0_state;
    led0_ctrl(led0_state);
}

/******************** end of file ********************/
