/**********************************************************************
 * FilePath: board_init.c
 * Author: 
 * Date: 2023-8-23 15:40:20
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "bsp_clk.h"
#include "bsp_int.h"
#include "bsp_led.h"
#include "bsp_exit.h"
#include "bsp_key.h"

static void delay(void);

unsigned char state = 0;

int board_init(void)
{
    int active = 1;

    int_init();
    imx6u_clkinit();
    clk_enable();
    led_init();
    key_init();
    exit_init();

    while (active) {
        delay();
        state = !state;
        led_switch(LED0, state);
    }

    return 1;
}

static void delay(void)
{
    volatile uint32_t i = 0;
    for (i = 0; i < 1000000; ++i)
    {
        __NOP(); /* delay */
    }
}

/******************** end of file ********************/
