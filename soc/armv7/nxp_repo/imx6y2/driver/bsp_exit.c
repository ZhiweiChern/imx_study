/**********************************************************************
 * FilePath: 
 * Author: 
 * Date: 
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "bsp_exit.h"
#include "bsp_gpio.h"
#include "bsp_int.h"
#include "bsp_led.h"
#include "fsl_iomuxc.h"

/*
 * @description			: 初始化外部中断
 * @param				: 无
 * @return 				: 无
 */
void exit_init(void)
{
    gpio_pin_config_t key_config;

    /* 1、设置IO复用 */
    IOMUXC_SetPinMux(IOMUXC_UART1_CTS_B_GPIO1_IO18,0);			/* 复用为GPIO1_IO18 */
    IOMUXC_SetPinConfig(IOMUXC_UART1_CTS_B_GPIO1_IO18,0xF080);

    /* 2、初始化GPIO为中断模式 */
    key_config.direction = kGPIO_DigitalInput;
    key_config.interruptMode = kGPIO_IntFallingEdge;
    key_config.outputLogic = 1;
    gpio_init(GPIO1, 18, &key_config);

    GIC_EnableIRQ(GPIO1_Combined_16_31_IRQn);				/* 使能GIC中对应的中断 */
    system_register_irqhandler(GPIO1_Combined_16_31_IRQn, (system_irq_handler_t)gpio1_io18_irqhandler, NULL);	/* 注册中断服务函数 */
    gpio_enableint(GPIO1, 18);								/* 使能GPIO1_IO18的中断功能 */
}

extern unsigned char state;
/*
 * @description			: GPIO1_IO18最终的中断处理函数
 * @param				: 无
 * @return 				: 无
 */
void gpio1_io18_irqhandler(void)
{ 
    static unsigned char state = 0;

    if(gpio_pinread(GPIO1, 18) == 0)	/* 按键按下了  */
    {
        state = !state;
        led_switch(LED0, state);
    }
    
    gpio_clearintflags(GPIO1, 18); /* 清除中断标志位 */
}

/******************** end of file ********************/
