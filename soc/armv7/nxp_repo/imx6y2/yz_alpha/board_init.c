/**********************************************************************
 * FilePath: board_init.c
 * Author: 
 * Date: 2023-8-23 15:40:20
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "gpio.h"
#include "bsp_clk.h"
#include "bsp_int.h"
#include "bsp_led.h"

static void delay(void);


int board_init(void)
{
    int_init();
    imx6u_clkinit();
    clk_enable();
    led_init();

    delay();
    led_switch(LED0, OFF);

    return 1;
}

static void delay(void)
{
    volatile uint32_t i = 0;
    for (i = 0; i < 5000000; ++i)
    {
        // __NOP(); /* delay */
        __ASM volatile ("nop");
    }
}

/******************** end of file ********************/
